Food Consumption and CO2 Emissions
================
Francis Lin | \#TidyTuesday |
2020-02-18

# Introduction

I’m not a bad cook, but my knowledge about cooking meat definitely
exceeds my knowledge about making vegetarian or vegan dishes. In this
dataset provided by
[nu3](https://www.nu3.de/blogs/nutrition/food-carbon-footprint-index-2018),
the consumption and corresponding CO2 emissions for each food category
in each country allows us to see just how much more CO2 is produced by
meat consumption. Here, I focused on only visualizing the meat category.

# R Program

## Set up

``` r
# source utilities
source("../utilities.R")

# packages
library(tidyverse)
library(readr)
library(countrycode)

# set data path
data_path <- set_data_path()

# create plot folder if doesn't exist
if (!dir.exists("./plot")) {dir.create("./plot")}
```

## Load Data

``` r
food_consumption <- read_csv(paste0(data_path, "food_consumption.csv"))
```

## Manipulate Data

Using the `countrycode` package, we can derive the continent that each
country is in.

``` r
# add continent column
food_consumption$continent <- countrycode(sourcevar=food_consumption$country, origin="country.name", destination="continent")

# get average meat consumption
meat_consumption <- food_consumption %>%
    filter(food_category %in% c("Beef", "Fish", "Lamb & Goat", "Pork", "Poultry")) %>%
    group_by(continent, food_category) %>%
    summarise(mean_consumption=mean(consumption), mean_co2=mean(co2_emmission)) %>%
    pivot_longer(c(-continent, -food_category), names_to="consumption", values_to="amount")
```

## Plot Data

``` r
p <- ggplot(meat_consumption, aes(x=continent, y=amount, fill=food_category)) + 
    geom_bar(position="dodge", stat="identity") +
    facet_wrap(~consumption, scales="free", labeller = as_labeller(c(mean_co2 = "Mean CO2 Emission (kg CO2/person/year)", mean_consumption = "Mean Meat Consumption (kg/person/year)"))) + 
    labs(x="Continent", y="", fill='Meat Type')
p
```

![](README_files/figure-gfm/plot%20data-1.png)<!-- -->

I’ll admit that there are a few flaws with this plot. The most glaring
is that it weighs each country in each continent equally and does not
take into account the population. This type of analysis may best be
accompanied by some other dataset with more information about each
country. Then, we can see if country status or GDP has any affect on the
ratio of consumption between meat and non-meat products.

## Save Image

``` r
ggsave("plot/plot_2020-02-18.png", p, width=8, height=4, units="in")
```

## Session Info

``` r
sessionInfo()
```

    ## R version 3.6.1 (2019-07-05)
    ## Platform: x86_64-pc-linux-gnu (64-bit)
    ## Running under: Ubuntu 18.04.3 LTS
    ## 
    ## Matrix products: default
    ## BLAS/LAPACK: /opt/intel/compilers_and_libraries_2018.2.199/linux/mkl/lib/intel64_lin/libmkl_gf_lp64.so
    ## 
    ## locale:
    ##  [1] LC_CTYPE=en_US.UTF-8       LC_NUMERIC=C              
    ##  [3] LC_TIME=en_US.UTF-8        LC_COLLATE=en_US.UTF-8    
    ##  [5] LC_MONETARY=en_US.UTF-8    LC_MESSAGES=en_US.UTF-8   
    ##  [7] LC_PAPER=en_US.UTF-8       LC_NAME=C                 
    ##  [9] LC_ADDRESS=C               LC_TELEPHONE=C            
    ## [11] LC_MEASUREMENT=en_US.UTF-8 LC_IDENTIFICATION=C       
    ## 
    ## attached base packages:
    ## [1] stats     graphics  grDevices utils     datasets  methods   base     
    ## 
    ## other attached packages:
    ##  [1] countrycode_1.1.0 forcats_0.4.0     stringr_1.4.0     dplyr_0.8.4      
    ##  [5] purrr_0.3.3       readr_1.3.1       tidyr_1.0.2       tibble_2.1.3     
    ##  [9] ggplot2_3.2.1     tidyverse_1.3.0  
    ## 
    ## loaded via a namespace (and not attached):
    ##  [1] tidyselect_1.0.0 xfun_0.12        haven_2.2.0      lattice_0.20-38 
    ##  [5] colorspace_1.4-1 vctrs_0.2.2      generics_0.0.2   htmltools_0.4.0 
    ##  [9] yaml_2.2.1       rlang_0.4.4      pillar_1.4.3     glue_1.3.1      
    ## [13] withr_2.1.2      DBI_1.1.0        dbplyr_1.4.2     modelr_0.1.5    
    ## [17] readxl_1.3.1     lifecycle_0.1.0  munsell_0.5.0    gtable_0.3.0    
    ## [21] cellranger_1.1.0 rvest_0.3.5      evaluate_0.14    labeling_0.3    
    ## [25] knitr_1.27       parallel_3.6.1   fansi_0.4.1      broom_0.5.4     
    ## [29] Rcpp_1.0.3       scales_1.1.0     backports_1.1.5  jsonlite_1.6.1  
    ## [33] farver_2.0.3     fs_1.3.1         hms_0.5.3        packrat_0.5.0   
    ## [37] digest_0.6.23    stringi_1.4.5    grid_3.6.1       cli_2.0.1       
    ## [41] tools_3.6.1      magrittr_1.5     lazyeval_0.2.2   crayon_1.3.4    
    ## [45] pkgconfig_2.0.3  xml2_1.2.2       reprex_0.3.0     lubridate_1.7.4 
    ## [49] rmarkdown_2.1    assertthat_0.2.1 httr_1.4.1       rstudioapi_0.10 
    ## [53] R6_2.4.1         nlme_3.1-143     compiler_3.6.1
