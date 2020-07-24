Astronaut database
================
Francis Lin | \#TidyTuesday |
2020-07-14

# Introduction

# R Program

This week’s data was collected [from
NASA](https://data.mendeley.com/datasets/86tsnnbv2w/1). Since mission
duration time was in the dataset, I wanted to take a look to see if the
mission duration increased as time went on.

## Set up

``` r
# source utilities
source("../utilities.R")

# packages
library(tidyverse)

# set data path
data_path <- set_data_path()

# create plot folder if doesn't exist
if (!dir.exists("./plot")) {dir.create("./plot")}
```

## Load Data

``` r
astronauts <- read_csv(paste0(data_path, "astronauts.csv"))
```

## Manipulate data

``` r
astronauts_missiontimes <- astronauts %>%
    select(year_of_mission, hours_mission, sex) %>%
    mutate(days_mission=hours_mission/24) %>%
    drop_na()

astronauts_missiontimes_avg <- astronauts_missiontimes %>%
    group_by(year_of_mission) %>%
    summarize(avg=mean(days_mission))
```

    ## `summarise()` ungrouping output (override with `.groups` argument)

## Plot Data

``` r
p <- ggplot() +
    geom_point(data=astronauts_missiontimes, aes(x=year_of_mission, y=days_mission, color=sex), alpha=0.3) +
    geom_line(data=astronauts_missiontimes_avg, aes(x=year_of_mission, y=avg), alpha=0.7, color="red") + 
    labs(x="Year", y="Days", title="Astronaut Duration of Missions", subtitle="Average mission duration is shown in red")
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
    ## [1] forcats_0.5.0   stringr_1.4.0   dplyr_1.0.0     purrr_0.3.4     readr_1.3.1     tidyr_1.1.0    
    ## [7] tibble_3.0.1    ggplot2_3.3.1   tidyverse_1.3.0
    ## 
    ## loaded via a namespace (and not attached):
    ##  [1] Rcpp_1.0.4.6       lubridate_1.7.9    lattice_0.20-41    prettyunits_1.1.1  ps_1.3.3          
    ##  [6] assertthat_0.2.1   digest_0.6.25      packrat_0.5.0      R6_2.4.1           cellranger_1.1.0  
    ## [11] backports_1.1.7    reprex_0.3.0       stats4_3.6.3       evaluate_0.14      httr_1.4.1        
    ## [16] pillar_1.4.4       rlang_0.4.6        readxl_1.3.1       rstudioapi_0.11    callr_3.4.3       
    ## [21] blob_1.2.1         rmarkdown_2.2      labeling_0.3       loo_2.2.0          munsell_0.5.0     
    ## [26] broom_0.5.6        compiler_3.6.3     modelr_0.1.8       xfun_0.14          rstan_2.19.3      
    ## [31] pkgconfig_2.0.3    pkgbuild_1.0.8     htmltools_0.4.0    tidyselect_1.1.0   gridExtra_2.3     
    ## [36] matrixStats_0.56.0 fansi_0.4.1        crayon_1.3.4       dbplyr_1.4.4       withr_2.2.0       
    ## [41] grid_3.6.3         nlme_3.1-148       jsonlite_1.6.1     gtable_0.3.0       lifecycle_0.2.0   
    ## [46] DBI_1.1.0          magrittr_1.5       StanHeaders_2.19.0 scales_1.1.1       cli_2.0.2         
    ## [51] stringi_1.4.6      farver_2.0.3       fs_1.4.1           xml2_1.3.2         ellipsis_0.3.1    
    ## [56] generics_0.0.2     vctrs_0.3.1        tools_3.6.3        glue_1.4.1         hms_0.5.3         
    ## [61] processx_3.4.2     parallel_3.6.3     yaml_2.2.1         inline_0.3.15      colorspace_1.4-1  
    ## [66] rvest_0.3.5        knitr_1.28         haven_2.3.1
