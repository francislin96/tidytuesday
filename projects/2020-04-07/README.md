Tour de France
================
Francis Lin | \#TidyTuesday |
2020-04-07

# Introduction

I learned quite a bit about the Tour de France this week doing this
\#TidyTuesday. For example, I found out that even though there is one
general winner for the Tour de France, there are other competitions
within this event. Lesser known teams could win just one portion of the
race to get some publicity, and there are some interesting strategies
that teams try to beat the other teams. This week’s data comes from the
[tdf package](https://github.com/alastairrushworth/tdf).

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
tdf_winners <- read_csv(paste0(data_path, "tdf_winners.csv"))
```

## Manipulate data

In this step, I just selected the relevant columns, turned the
time\_margin to minutes, and dropped any rows with NA.

``` r
winners <- tdf_winners %>% 
    select(start_date, winner_name, time_overall, distance, time_margin) %>%
    mutate(time_margin=time_margin*60) %>%
    drop_na()
```

## Plot Data

``` r
p <- ggplot() + 
    geom_point(data=winners, aes(x=start_date, y=time_overall, size=time_margin, color=distance), alpha=0.5) + 
    scale_color_gradient(low="blue", high="red") + 
    labs(x="Year", y="Total Time (Hours) to Finish Race", size="Time Margin (minutes)", color="Distance (km)", alpha="", title="Tour de France")
p
```

![](README_files/figure-gfm/plot%20data-1.png)<!-- -->

From the graph above, it seems that the Tour de France has become
shorter and and more competitive over time.

## Save Image

``` r
ggsave("plot/plot_2020-04-07.png", p, width=7, height=5, units="in")
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
    ##  [1] LC_CTYPE=en_US.UTF-8       LC_NUMERIC=C               LC_TIME=en_US.UTF-8        LC_COLLATE=en_US.UTF-8    
    ##  [5] LC_MONETARY=en_US.UTF-8    LC_MESSAGES=en_US.UTF-8    LC_PAPER=en_US.UTF-8       LC_NAME=C                 
    ##  [9] LC_ADDRESS=C               LC_TELEPHONE=C             LC_MEASUREMENT=en_US.UTF-8 LC_IDENTIFICATION=C       
    ## 
    ## attached base packages:
    ## [1] stats     graphics  grDevices utils     datasets  methods   base     
    ## 
    ## other attached packages:
    ## [1] forcats_0.5.0   stringr_1.4.0   dplyr_0.8.5     purrr_0.3.3     readr_1.3.1     tidyr_1.0.2    
    ## [7] tibble_3.0.0    ggplot2_3.3.0   tidyverse_1.3.0
    ## 
    ## loaded via a namespace (and not attached):
    ##  [1] tidyselect_1.0.0 xfun_0.12        haven_2.2.0      lattice_0.20-38  colorspace_1.4-1 vctrs_0.2.4     
    ##  [7] generics_0.0.2   htmltools_0.4.0  yaml_2.2.1       rlang_0.4.5      pillar_1.4.3     glue_1.3.2      
    ## [13] withr_2.1.2      DBI_1.1.0        dbplyr_1.4.2     modelr_0.1.6     readxl_1.3.1     lifecycle_0.2.0 
    ## [19] munsell_0.5.0    gtable_0.3.0     cellranger_1.1.0 rvest_0.3.5      evaluate_0.14    labeling_0.3    
    ## [25] knitr_1.28       parallel_3.6.1   fansi_0.4.1      broom_0.5.5      Rcpp_1.0.4       scales_1.1.0    
    ## [31] backports_1.1.5  jsonlite_1.6.1   farver_2.0.3     fs_1.4.0         digest_0.6.25    hms_0.5.3       
    ## [37] packrat_0.5.0    stringi_1.4.6    grid_3.6.1       cli_2.0.2        tools_3.6.1      magrittr_1.5    
    ## [43] crayon_1.3.4     pkgconfig_2.0.3  ellipsis_0.3.0   xml2_1.2.5       reprex_0.3.0     lubridate_1.7.4 
    ## [49] rmarkdown_2.1    assertthat_0.2.1 httr_1.4.1       rstudioapi_0.11  R6_2.4.1         nlme_3.1-145    
    ## [55] compiler_3.6.1
