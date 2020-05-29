# import packages
library(shiny)
library(DT)
library(tidyverse)
library(gsubfn)

# read in data
boston_cocktails <- read_csv(url("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-05-26/boston_cocktails.csv"))
mr_boston_flattened <- read_csv(url("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-05-26/mr-boston-flattened.csv"))

# change fraction measurement to decimal
defractionize <- function(measurement) {
    
    # turn fraction into decimal
    if (!grepl("-ml", measurement)) {
        return(gsubfn("(\\d+) (\\d+)", ~ as.numeric(x) + as.numeric(y), gsubfn("(\\d+)/(\\d+)", ~ as.numeric(x)/as.numeric(y), gsub("\\s+"," ", measurement))))
    }
    # if mL, then multiply instead
    else if (grepl("-ml", measurement)) {
        nums = as.numeric(strsplit(measurement, "\\D+")[[1]])
        return(paste(as.character(nums[1]*nums[2]), "mL"))
    }
    
}

# convert measurement to ounces
convert <- function(measurement) {
    if (grepl("oz", measurement)) {
        return(as.numeric(gsub("oz.*", "", measurement)))
    }
    # measurement in dash
    if (grepl("dash", measurement)) {
        # 1 dash is 0.021 ounces
        return(as.numeric(gsub("dash.*", "", measurement)) * 0.021)
    }
    # measurement in tsp
    else if (grepl("tsp", measurement)) {
        # 1 tsp is 1/6 ounces
        return(as.numeric(gsub("tsp.*", "", measurement)) / 6)
    }
    # measurement in mL
    else if (grepl("mL", measurement)) {
        # 1 mL is 0.033814 ounces
        return(as.numeric(gsub("mL.*", "", measurement)) * 0.033814)
    }
    # measurement in splash
    else if (grepl("splash", measurement)) {
        # 1 splash is 1/5 ounces
        splash = as.numeric(gsub("splash.*", "", measurement))
        if (is.na(splash)) {
            return (0.2)
        } else {
            return(as.numeric(splash) / 5)
        }
        
    }
    # measurement in cup
    else if (grepl("[0-9]c", measurement)) {
        # 1 cup is 8 ounces
        return(as.numeric(gsub("c.*", "", measurement)) * 8)
    }
    # measurement in cup
    else if (grepl("bottle", measurement)) {
        # 1 bottle is 25.4 ounces
        return(as.numeric(gsub("bottle.*", "", measurement)) * 25.4)
    }
    # measurement in drops
    else if (grepl("drop", measurement)) {
        # 1 drop is 0.0016907 ounces
        return(as.numeric(strsplit("2-3 drops", "\\D+")[[1]][1]) * 0.0016907)
    }
    else return(0)
}

# process boston_cocktails
boston_cocktails <- boston_cocktails %>%
    mutate(measure = sapply(measure, defractionize)) %>%
    mutate(ounces = sapply(measure, convert))

# server
function(input, output){
    output$text <- renderUI({
        
        HTML("<p>This is a simple Shiny app to look up cocktail recipes based on ingredients you already have. Full code available <a href=\"https://github.com/francislin96/tidytuesday/tree/master/projects/2020-05-26\">here</a>.</p><br>")
    })
    output$table <- renderDataTable({
        
        # if ingredients aren't selected
        if(!isTruthy(input$ingredients_list)) {
            
            # return default dataset with additional information
            df <- boston_cocktails %>% 
                
                # drop category because exists in other dataset
                select(-category) %>%
                
                # join with other dataset containing additional info on drink
                left_join(mr_boston_flattened, by="name") %>%
                
                # rename columns
                rename_all(~str_replace_all(.,"\\-","_")) %>%
                
                # get ingredients for drink
                group_by(name) %>%
                mutate(ingredients = paste(gsub("(NA )|( NA)|NA", "", paste(measurement_1, ingredient_1)), 
                                           gsub("(NA )|( NA)|NA", "", paste(measurement_2, ingredient_2)), 
                                           gsub("(NA )|( NA)|NA", "", paste(measurement_3, ingredient_3)), 
                                           gsub("(NA )|( NA)|NA", "", paste(measurement_4, ingredient_4)), 
                                           gsub("(NA )|( NA)|NA", "", paste(measurement_5, ingredient_5)), 
                                           gsub("(NA )|( NA)|NA", "", paste(measurement_6, ingredient_6)), sep=", "),
                       ingredients = gsub("(, )+$", "", ingredients)) %>%
                ungroup() %>%
                
                # keep relevant columns
                select(name, category, glass, glass_size, ingredients, instructions) %>%
                
                # rename
                rename("Drink"=name, 
                       "Drink Category"=category,
                       "Glass"=glass,
                       "Glass Size"=glass_size,
                       "Ingredients"=ingredients,
                       "Instructions"=instructions)
            return(df)
        }
        
        # if ingredients are selected
        else {
            df <- boston_cocktails %>% 
                # check if selected ingredients are in drink
                # and create ingredient-measure if ingredient wasn't selected
                mutate(bools = ifelse(ingredient %in% input$ingredients_list, 1, 0),
                       ingredient_measure = ifelse(bools==0, paste(measure, ingredient), NA)) %>%
                
                # find the missing ingredients per drink
                group_by(name) %>%
                summarize(drink_volume = sum(ounces), 
                          ingredients_volume = sum(bools*ounces), 
                          unmeasured_ingredients = sum(ounces==0)) %>%
                
                # score the drink by completeness, using crude algorithm
                mutate(ingredients_percentage = ingredients_volume/drink_volume - unmeasured_ingredients*0.1) %>%
                arrange(desc(ingredients_percentage)) %>%
                
                # join with other dataset containing additional info on drink
                left_join(mr_boston_flattened, by="name") %>%
                rename_all(~str_replace_all(.,"\\-","_")) %>%
                
                # get ingredients for drink
                group_by(name) %>%
                mutate(ingredients = paste(gsub("(NA )|( NA)|NA", "", paste(measurement_1, ingredient_1)), 
                                           gsub("(NA )|( NA)|NA", "", paste(measurement_2, ingredient_2)), 
                                           gsub("(NA )|( NA)|NA", "", paste(measurement_3, ingredient_3)), 
                                           gsub("(NA )|( NA)|NA", "", paste(measurement_4, ingredient_4)), 
                                           gsub("(NA )|( NA)|NA", "", paste(measurement_5, ingredient_5)), 
                                           gsub("(NA )|( NA)|NA", "", paste(measurement_6, ingredient_6)), sep=", "),
                       ingredients = gsub("(, )+$", "", ingredients)) %>%
                ungroup() %>%
                
                # keep relevant columns
                select(name, category, glass, glass_size, ingredients, instructions) %>%
                
                # rename
                rename("Drink"=name, 
                       "Drink Category"=category,
                       "Glass"=glass,
                       "Glass Size"=glass_size,
                       "Ingredients"=ingredients,
                       "Instructions"=instructions)
            
            return(df)
        }
        
        
    },
    escape = FALSE,
    extensions="Responsive"
    )
}