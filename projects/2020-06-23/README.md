Caribou Location Tracking
================
Francis Lin | \#TidyTuesday |
2020-06-23

# Introduction

This week’s data focuses on caribou location tracking. The data contains
longitude and latitude coordinates of 260 caribou in northern British
Columbia from 1988 to 2016. I didn’t have too much time this week, so I
created a visualization similar to the one I made for [San Francisco
Trees](https://github.com/francislin96/tidytuesday/tree/master/projects/2020-01-28).

# R Program

## Set up

``` r
# source utilities
source("../utilities.R")

# packages
library(tidyverse)
library(ggmap)

# set data path
data_path <- set_data_path()

# create plot folder if doesn't exist
if (!dir.exists("./plot")) {dir.create("./plot")}
```

## Load Data

``` r
locations <- read_csv(paste0(data_path, "locations.csv"))
```

## Create Map

``` r
# read in google maps API key
register_google(key=read_key("google"))

# create ggmap
caribou_map <- get_map(location = c(mean(caribou_locations$longitude), mean(caribou_locations$latitude)), zoom=7)
caribou_ggmap <- ggmap(caribou_map)
```

## Manipulate data

``` r
caribou_locations <- locations %>%
    
    # drop NA
    drop_na(longitude, latitude) %>%
    
    # filter for points within boundaries of map
    filter(between(longitude, min(caribou_ggmap$data$lon), max(caribou_ggmap$data$lon)), between(latitude, min(caribou_ggmap$data$lat), max(caribou_ggmap$data$lat)))
```

## Plot Data

``` r
p <- caribou_ggmap +
    stat_density2d(data=caribou_locations, aes(x=longitude, y=latitude, fill=season), bins=5, alpha=0.5, geom="polygon") +
    labs(x="", y="", title="Location Density of Caribou in Northern British Columbia 1988-2016", fill="Season") +
    theme(plot.title=element_text(hjust = 0.5))
p
```

![](README_files/figure-gfm/plot%20data-1.png)<!-- -->

## Save Image

``` r
ggsave("plot/plot_2020-06-23.png", p, width=7, height=5, units="in")
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
    ##  [1] ggmap_3.0.0     forcats_0.5.0   stringr_1.4.0   dplyr_1.0.0    
    ##  [5] purrr_0.3.4     readr_1.3.1     tidyr_1.1.0     tibble_3.0.1   
    ##  [9] ggplot2_3.3.1   tidyverse_1.3.0
    ## 
    ## loaded via a namespace (and not attached):
    ##  [1] httr_1.4.1          jsonlite_1.6.1      modelr_0.1.8       
    ##  [4] StanHeaders_2.19.0  assertthat_0.2.1    stats4_3.6.3       
    ##  [7] blob_1.2.1          cellranger_1.1.0    yaml_2.2.1         
    ## [10] pillar_1.4.4        backports_1.1.7     lattice_0.20-41    
    ## [13] glue_1.4.1          digest_0.6.25       rvest_0.3.5        
    ## [16] colorspace_1.4-1    htmltools_0.4.0     plyr_1.8.6         
    ## [19] pkgconfig_2.0.3     rstan_2.19.3        broom_0.5.6        
    ## [22] haven_2.3.1         scales_1.1.1        processx_3.4.2     
    ## [25] jpeg_0.1-8.1        farver_2.0.3        generics_0.0.2     
    ## [28] ellipsis_0.3.1      withr_2.2.0         cli_2.0.2          
    ## [31] magrittr_1.5        crayon_1.3.4        readxl_1.3.1       
    ## [34] evaluate_0.14       ps_1.3.3            fs_1.4.1           
    ## [37] fansi_0.4.1         MASS_7.3-51.6       nlme_3.1-148       
    ## [40] xml2_1.3.2          pkgbuild_1.0.8      tools_3.6.3        
    ## [43] loo_2.2.0           prettyunits_1.1.1   hms_0.5.3          
    ## [46] RgoogleMaps_1.4.5.2 lifecycle_0.2.0     matrixStats_0.56.0 
    ## [49] munsell_0.5.0       reprex_0.3.0        callr_3.4.3        
    ## [52] packrat_0.5.0       isoband_0.2.1       compiler_3.6.3     
    ## [55] rlang_0.4.6         grid_3.6.3          rstudioapi_0.11    
    ## [58] rjson_0.2.20        labeling_0.3        bitops_1.0-6       
    ## [61] rmarkdown_2.2       gtable_0.3.0        curl_4.3           
    ## [64] inline_0.3.15       DBI_1.1.0           R6_2.4.1           
    ## [67] gridExtra_2.3       lubridate_1.7.9     knitr_1.28         
    ## [70] stringi_1.4.6       parallel_3.6.3      Rcpp_1.0.4.6       
    ## [73] vctrs_0.3.1         png_0.1-7           dbplyr_1.4.4       
    ## [76] tidyselect_1.1.0    xfun_0.14
