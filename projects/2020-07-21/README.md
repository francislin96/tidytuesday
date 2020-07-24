Australian Pets
================
Francis Lin | \#TidyTuesday |
2020-07-14

# Introduction

It’s sad seeing so many cats and dogs being euthanized in this dataset.
Cats have a higher euthanization rate compared to dogs, although that
gap is narrowing as both cats and dogs euthanization rates have lowered
in recent years. According to [American
Humane](https://americanhumane.org/fact-sheet/animal-shelter-euthanasia-2/),
cats are euthanized more frequently since they are less likely to have
owner identification when entering a shelter.

# R Program

## Set up

``` r
# source utilities
source("../utilities.R")

# packages
library(tidyverse)
library(magick)

# set data path
data_path <- set_data_path()

# create plot folder if doesn't exist
if (!dir.exists("./plot")) {dir.create("./plot")}
```

## Load Data

``` r
animal_outcomes <- read_csv(paste0(data_path, "animal_outcomes.csv"))
```

## Manipulate data

``` r
outcomes <- animal_outcomes %>% 
    select(year, animal_type, outcome, Total) %>%
    filter(animal_type %in% c("Cats", "Dogs")) %>%
    mutate(outcome_type = factor(case_when(outcome %in% c("Reclaimed", "Rehomed") ~ "Positive",
                     outcome == "Euthanized" ~ "Negative",
                     TRUE ~ "Other"), levels=c("Positive", "Negative", "Other"))) %>%
    group_by(year, animal_type, outcome_type) %>%
    summarize(total = sum(Total)) %>%
    group_by(year, animal_type) %>%
    mutate(percentage = total/sum(total)*100) %>%
    filter(outcome_type=="Negative")
```

    ## `summarise()` regrouping output by 'year', 'animal_type' (override with `.groups` argument)

## Plot Data

``` r
# used for plotting images
imagexcoord <- 2000
dogycoord <- (outcomes %>% filter(year==imagexcoord, animal_type=="Dogs"))%>% `[[`("percentage")
catycoord <- (outcomes %>% filter(year==imagexcoord, animal_type=="Cats"))%>% `[[`("percentage")

# plot
p <- ggplot(outcomes) +
    geom_line(aes(x=year, y=percentage, color=animal_type)) +
    ylim(0,100) +
    labs(x="Year", y="Percentage Euthanized", color="Animal", title="Euthanization Rates of Cats and Dogs in Australia", subtitle="Cats have consistently been euthanized at a higher rate than dogs, although both are trending lower") + 
    theme(plot.subtitle=element_text(size=8), legend.position = "none") +
    
    # add images of dog and cat
    annotation_raster(image_read("https://cdn.pixabay.com/photo/2016/02/07/19/47/dog-1185460_960_720.png"), imagexcoord-1, imagexcoord+1, dogycoord, dogycoord+10) +
    annotation_raster(image_read("https://freesvg.org/img/molumen-cat-icons-4.png"), imagexcoord-0.9, imagexcoord+0.9, catycoord-1, catycoord+13)
p
```

![](README_files/figure-gfm/plot%20data-1.png)<!-- -->

## Save Image

``` r
ggsave("plot/plot_2020-07-14.png", p, width=7, height=5, units="in")
```

## Session Info

``` r
sessionInfo()
```

    ## R version 3.6.3 (2020-02-29)
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
    ##  [1] magick_2.3      forcats_0.5.0   stringr_1.4.0   dplyr_1.0.0     purrr_0.3.4     readr_1.3.1    
    ##  [7] tidyr_1.1.0     tibble_3.0.1    ggplot2_3.3.1   tidyverse_1.3.0
    ## 
    ## loaded via a namespace (and not attached):
    ##  [1] Rcpp_1.0.4.6       lubridate_1.7.9    lattice_0.20-41    prettyunits_1.1.1  ps_1.3.3          
    ##  [6] utf8_1.1.4         assertthat_0.2.1   digest_0.6.25      packrat_0.5.0      R6_2.4.1          
    ## [11] cellranger_1.1.0   backports_1.1.7    reprex_0.3.0       stats4_3.6.3       evaluate_0.14     
    ## [16] httr_1.4.1         pillar_1.4.4       rlang_0.4.6        curl_4.3           readxl_1.3.1      
    ## [21] rstudioapi_0.11    callr_3.4.3        blob_1.2.1         rmarkdown_2.2      labeling_0.3      
    ## [26] loo_2.2.0          munsell_0.5.0      broom_0.5.6        compiler_3.6.3     modelr_0.1.8      
    ## [31] xfun_0.14          rstan_2.19.3       pkgconfig_2.0.3    pkgbuild_1.0.8     htmltools_0.4.0   
    ## [36] tidyselect_1.1.0   gridExtra_2.3      matrixStats_0.56.0 fansi_0.4.1        crayon_1.3.4      
    ## [41] dbplyr_1.4.4       withr_2.2.0        grid_3.6.3         nlme_3.1-148       jsonlite_1.6.1    
    ## [46] gtable_0.3.0       lifecycle_0.2.0    DBI_1.1.0          magrittr_1.5       StanHeaders_2.19.0
    ## [51] scales_1.1.1       cli_2.0.2          stringi_1.4.6      farver_2.0.3       fs_1.4.1          
    ## [56] xml2_1.3.2         ellipsis_0.3.1     generics_0.0.2     vctrs_0.3.1        tools_3.6.3       
    ## [61] glue_1.4.1         hms_0.5.3          processx_3.4.2     parallel_3.6.3     yaml_2.2.1        
    ## [66] inline_0.3.15      colorspace_1.4-1   rvest_0.3.5        knitr_1.28         haven_2.3.1
