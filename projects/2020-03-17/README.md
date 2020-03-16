The Office - Words and Numbers
================
Francis Lin | \#TidyTuesday |
2020-03-17

# Introduction

The data of this analysis comes from the IMDB ratings from
[data.world](https://data.world/anujjain7/the-office-imdb-ratings-dataset).
I’ve watched some episodes of “The Office” several times, but I’m glad I
don’t see ‘The Office’ archetypes in my workplace.

# R Program

## Set up

``` r
# source utilities
source("../utilities.R")

# packages
library(tidyverse)
library(RColorBrewer)

# set data path
data_path <- set_data_path()

# create plot folder if doesn't exist
if (!dir.exists("./plot")) {dir.create("./plot")}
```

## Load Data

``` r
office_ratings <- read_csv(paste0(data_path, "office_ratings.csv"))
```

## Manipulate data

``` r
office_ratings <- office_ratings %>%
    mutate(air_date=lubridate::ymd(air_date), season=factor(season))
```

## Plot Data

``` r
p <- ggplot(office_ratings, aes(x=air_date, y=imdb_rating, group=season, colour=season )) +
    geom_line() + 
    scale_color_brewer(palette="Set1") +
    ylim(0, 10) +
    labs(x="Airing Date", y="IMDB Rating", title="\"The Office\" Ratings by Season") +
    theme(legend.position="none")
p
```

![](README_files/figure-gfm/plot%20data-1.png)<!-- -->

If I had a little more time, I’d like to annotate some of the highs and
lows of the ratings.

## Save Image

``` r
ggsave("plot/plot_2020-03-17.png", p, width=8, height=4, units="in")
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
    ##  [1] LC_CTYPE=en_US.UTF-8       LC_NUMERIC=C               LC_TIME=en_US.UTF-8       
    ##  [4] LC_COLLATE=en_US.UTF-8     LC_MONETARY=en_US.UTF-8    LC_MESSAGES=en_US.UTF-8   
    ##  [7] LC_PAPER=en_US.UTF-8       LC_NAME=C                  LC_ADDRESS=C              
    ## [10] LC_TELEPHONE=C             LC_MEASUREMENT=en_US.UTF-8 LC_IDENTIFICATION=C       
    ## 
    ## attached base packages:
    ## [1] stats     graphics  grDevices utils     datasets  methods   base     
    ## 
    ## other attached packages:
    ##  [1] RColorBrewer_1.1-2 forcats_0.4.0      stringr_1.4.0      dplyr_0.8.4        purrr_0.3.3       
    ##  [6] readr_1.3.1        tidyr_1.0.2        tibble_2.1.3       ggplot2_3.2.1      tidyverse_1.3.0   
    ## 
    ## loaded via a namespace (and not attached):
    ##  [1] Rcpp_1.0.3         lubridate_1.7.4    lattice_0.20-38    prettyunits_1.1.1  ps_1.3.2          
    ##  [6] assertthat_0.2.1   packrat_0.5.0      digest_0.6.25      R6_2.4.1           cellranger_1.1.0  
    ## [11] backports_1.1.5    reprex_0.3.0       stats4_3.6.1       evaluate_0.14      httr_1.4.1        
    ## [16] pillar_1.4.3       rlang_0.4.5        lazyeval_0.2.2     readxl_1.3.1       rstudioapi_0.11   
    ## [21] callr_3.4.2        rmarkdown_2.1      labeling_0.3       loo_2.2.0          munsell_0.5.0     
    ## [26] broom_0.5.4        compiler_3.6.1     modelr_0.1.6       xfun_0.12          rstan_2.19.3      
    ## [31] pkgconfig_2.0.3    pkgbuild_1.0.6     htmltools_0.4.0    tidyselect_1.0.0   gridExtra_2.3     
    ## [36] matrixStats_0.55.0 fansi_0.4.1        crayon_1.3.4       dbplyr_1.4.2       withr_2.1.2       
    ## [41] grid_3.6.1         nlme_3.1-144       jsonlite_1.6.1     gtable_0.3.0       lifecycle_0.1.0   
    ## [46] DBI_1.1.0          magrittr_1.5       StanHeaders_2.19.0 scales_1.1.0       cli_2.0.2         
    ## [51] stringi_1.4.6      farver_2.0.3       fs_1.3.1           xml2_1.2.2         generics_0.0.2    
    ## [56] vctrs_0.2.4        tools_3.6.1        glue_1.3.1         hms_0.5.3          yaml_2.2.1        
    ## [61] processx_3.4.2     parallel_3.6.1     inline_0.3.15      colorspace_1.4-1   rvest_0.3.5       
    ## [66] knitr_1.28         haven_2.2.0
