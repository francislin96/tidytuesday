# import packages
library(shiny)
library(DT)
library(tidyverse)
library(gsubfn)

# read in data
boston_cocktails <- read_csv(url("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-05-26/boston_cocktails.csv"))
mr_boston_flattened <- read_csv(url("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-05-26/mr-boston-flattened.csv"))

# get unique ingredients
unique_ingredients = (boston_cocktails %>% group_by(ingredient) %>% summarize(count=n()) %>% arrange(desc(count)))$ingredient

# side_width for sidebar panel
side_width <- 5

# ui
fluidPage(
    titlePanel("What drink would you like to make?"),
    htmlOutput("text"),
    sidebarLayout(
        sidebarPanel(
            selectizeInput(
                'ingredients_list', 'Select Ingredients', choices = unique_ingredients, multiple = TRUE
            )
        ),
        mainPanel(
            fluidRow(column(12, DT::dataTableOutput("table")))
        )
    )
)