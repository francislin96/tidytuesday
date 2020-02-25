Measles
================
Francis Lin | \#TidyTuesday |
2020-02-25

# Introduction

Get vaccinated\! This week’s data comes from the [Wall Street
Journal](https://github.com/WSJ/measles-data). I tried to plot this on a
map by county, but couldn’t make it happen. Instead, I decided to
explore violin graphs\! While the data isn’t super suitable for them, I
just wanted to give it a try and see what happens.

# R Program

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
measles <- read_csv(paste0(data_path, "measles.csv"))
```

## Plot Data

``` r
# filter out datapoints with negative mmr or invalid type
m <- measles %>%
    filter(mmr >= 0, !is.na(type))

# plot violin graphs
p <- ggplot(data=m, aes(x=type, y=mmr, fill=type)) +
    geom_violin() + 
    theme(legend.position = "none") + 
    labs(title="School's Measles, Mumps, and Rubella (MMR) vaccination rate", x="School Type", y="Percentage (%)")
p
```

![](README_files/figure-gfm/plot%20data-1.png)<!-- -->

## Save Image

``` r
ggsave("plot/plot_2020-02-25.png", p, width=8, height=4, units="in")
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
    ## [1] forcats_0.4.0   stringr_1.4.0   dplyr_0.8.4     purrr_0.3.3     readr_1.3.1     tidyr_1.0.2    
    ## [7] tibble_2.1.3    ggplot2_3.2.1   tidyverse_1.3.0
    ## 
    ## loaded via a namespace (and not attached):
    ##  [1] tidyselect_1.0.0 xfun_0.12        haven_2.2.0      lattice_0.20-38  colorspace_1.4-1
    ##  [6] vctrs_0.2.2      generics_0.0.2   htmltools_0.4.0  yaml_2.2.1       rlang_0.4.4     
    ## [11] pillar_1.4.3     glue_1.3.1       withr_2.1.2      DBI_1.1.0        dbplyr_1.4.2    
    ## [16] modelr_0.1.5     readxl_1.3.1     lifecycle_0.1.0  munsell_0.5.0    gtable_0.3.0    
    ## [21] cellranger_1.1.0 rvest_0.3.5      evaluate_0.14    labeling_0.3     knitr_1.27      
    ## [26] parallel_3.6.1   fansi_0.4.1      broom_0.5.4      Rcpp_1.0.3       scales_1.1.0    
    ## [31] backports_1.1.5  jsonlite_1.6.1   farver_2.0.3     fs_1.3.1         digest_0.6.23   
    ## [36] hms_0.5.3        packrat_0.5.0    stringi_1.4.5    grid_3.6.1       cli_2.0.1       
    ## [41] tools_3.6.1      magrittr_1.5     lazyeval_0.2.2   crayon_1.3.4     pkgconfig_2.0.3 
    ## [46] xml2_1.2.2       reprex_0.3.0     lubridate_1.7.4  assertthat_0.2.1 rmarkdown_2.1   
    ## [51] httr_1.4.1       rstudioapi_0.10  R6_2.4.1         nlme_3.1-143     compiler_3.6.1
