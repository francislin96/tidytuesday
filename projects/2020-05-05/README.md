Animal Crossing - New Horizons
================
Francis Lin | \#TidyTuesday |
2020-05-05

# Introduction

During the quarantine, Animal Crossing’s popularity has skyrocketed -
roughly [11 million
people](https://www.theguardian.com/games/2020/may/13/animal-crossing-new-horizons-nintendo-game-coronavirus)
are playing this life simulation game. Using data from
[VillagerDB](https://github.com/jefflomacy/villagerdb), I created a
Sankey diagram to show the flow of characters in regards to their
species, personality, and gender. I’ve always wanted to create Sankey
diagrams, but I didn’t know it was so easy to do in R\!

# R Program

## Set up

``` r
# source utilities
source("../utilities.R")

# packages
library(tidyverse)
library(plotly)

# set data path
data_path <- set_data_path()

# create plot folder if doesn't exist
if (!dir.exists("./plot")) {dir.create("./plot")}
```

## Load Data

``` r
villagers_data <- read_csv(paste0(data_path, "villagers.csv"))
```

## Manipulate data

Here, we manipulate the given data to make it easier to create a Sankey
diagram. We need to create the labels and colors for nodes, as well as
indicate the source, target, and value for each link between nodes.

``` r
# variables to analyze
villagers <- villagers_data %>% 
    select(species, personality, gender)

# list of labels for Sankey diagram for each node
villagers_label <- c(sort(unique(villagers$species)), sort(unique(villagers$personality)), sort(unique(villagers$gender)))

# list of colors for Sankey diagram for each node
villagers_color <- c(rainbow(length(unique(villagers$species))), rainbow(length(unique(villagers$personality))), "#FFC0CB", "#89cff0")

# linkage for species-personality
villagers_species_personality_link <- villagers %>%
    group_by(species, personality) %>%
    summarise(value=n()) %>%
    mutate(source=match(species, villagers_label), target=match(personality, villagers_label))

# linkage for personality-gender
villagers_personality_gender_link <- villagers %>%
    group_by(personality, gender) %>%
    summarise(value=n()) %>%
    mutate(source=match(personality, villagers_label), target=match(gender, villagers_label))

# concatenate linkages
villagers_link <- rbind(villagers_species_personality_link, villagers_personality_gender_link)
```

## Plot Data

``` r
p <- plot_ly(
    type = "sankey",
    orientation = "h",

    node = list(
        label = villagers_label, 
        color = villagers_color
    ),

    link = list(
        source = villagers_link$source-1,
        target = villagers_link$target-1,
        value =  villagers_link$value
    )
) %>% layout(
    title = "Species, Personalities, and Genders in Animal Crossing - New Horizons",
    font = list(
      size = 10
    )
)

p
```

![](README_files/figure-gfm/plot%20data-1.png)<!-- -->

![ANCH Sankey Diagram](plot/plot_2020-05-05.png)

Interestingly, the personality types are unique to gender in ACNH\!

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
    ##  [1] LC_CTYPE=en_US.UTF-8       LC_NUMERIC=C               LC_TIME=en_US.UTF-8       
    ##  [4] LC_COLLATE=en_US.UTF-8     LC_MONETARY=en_US.UTF-8    LC_MESSAGES=en_US.UTF-8   
    ##  [7] LC_PAPER=en_US.UTF-8       LC_NAME=C                  LC_ADDRESS=C              
    ## [10] LC_TELEPHONE=C             LC_MEASUREMENT=en_US.UTF-8 LC_IDENTIFICATION=C       
    ## 
    ## attached base packages:
    ## [1] stats     graphics  grDevices utils     datasets  methods   base     
    ## 
    ## other attached packages:
    ##  [1] plotly_4.9.1    forcats_0.5.0   stringr_1.4.0   dplyr_0.8.5     purrr_0.3.3    
    ##  [6] readr_1.3.1     tidyr_1.0.2     tibble_3.0.0    ggplot2_3.3.0   tidyverse_1.3.0
    ## 
    ## loaded via a namespace (and not attached):
    ##  [1] Rcpp_1.0.4.6       lubridate_1.7.4    lattice_0.20-38    prettyunits_1.1.1 
    ##  [5] ps_1.3.2           assertthat_0.2.1   packrat_0.5.0      digest_0.6.25     
    ##  [9] R6_2.4.1           cellranger_1.1.0   backports_1.1.6    stats4_3.6.1      
    ## [13] reprex_0.3.0       evaluate_0.14      httr_1.4.1         pillar_1.4.3      
    ## [17] rlang_0.4.5        lazyeval_0.2.2     readxl_1.3.1       rstudioapi_0.11   
    ## [21] data.table_1.12.8  callr_3.4.3        rmarkdown_2.1      webshot_0.5.2     
    ## [25] loo_2.2.0          htmlwidgets_1.5.1  munsell_0.5.0      broom_0.5.5       
    ## [29] rstan_2.19.3       compiler_3.6.1     modelr_0.1.6       xfun_0.12         
    ## [33] pkgconfig_2.0.3    pkgbuild_1.0.6     htmltools_0.4.0    tidyselect_1.0.0  
    ## [37] gridExtra_2.3      matrixStats_0.56.0 fansi_0.4.1        viridisLite_0.3.0 
    ## [41] crayon_1.3.4       dbplyr_1.4.2       withr_2.1.2        grid_3.6.1        
    ## [45] nlme_3.1-145       jsonlite_1.6.1     gtable_0.3.0       lifecycle_0.2.0   
    ## [49] DBI_1.1.0          magrittr_1.5       StanHeaders_2.19.0 scales_1.1.0      
    ## [53] cli_2.0.2          stringi_1.4.6      fs_1.4.0           xml2_1.3.1        
    ## [57] ellipsis_0.3.0     generics_0.0.2     vctrs_0.2.4        tools_3.6.1       
    ## [61] glue_1.4.0         hms_0.5.3          crosstalk_1.1.0.1  processx_3.4.2    
    ## [65] parallel_3.6.1     yaml_2.2.1         inline_0.3.15      colorspace_1.4-1  
    ## [69] rvest_0.3.5        knitr_1.28         haven_2.2.0
