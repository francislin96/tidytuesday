Rap Artists
================
Francis Lin | \#TidyTuesday |
2020-04-14

# Introduction

[BBC
Music](http://www.bbc.com/culture/story/20191007-the-greatest-hip-hop-songs-of-all-time-who-voted)
asked multiple critics what their top 5 hip-hop tracks were. Based on
the answers, they then awarded points to each song. The analysis below
visualizes their responses.

# R Program

## Set up

``` r
# source utilities
source("../utilities.R")

# packages
library(tidyverse)
library(ggrepel)

# set data path
data_path <- set_data_path()

# create plot folder if doesn't exist
if (!dir.exists("./plot")) {dir.create("./plot")}
```

## Load Data

``` r
rankings <- read_csv(paste0(data_path, "rankings.csv"))
```

## Plot Data

``` r
p <- ggplot(rankings, aes(x=year, y=points, color=gender)) +
    scale_color_manual(values = c("female"="red", "male"="royalblue", "mixed"="purple")) +
    geom_point(alpha=0.25) + 
    geom_text_repel(size = 2.5, box.padding = 0.5, aes(label=ifelse(points>as.numeric(quantile(points,0.95)),paste(title, "\n-", artist),''))) + 
    labs(title="Rap Artists and Critic Ratings", x="Year", y="Critic Points", color="Gender")
p
```

![](README_files/figure-gfm/plot%20data-1.png)<!-- -->

The top 5% rap songs with the highest points given by critics between
1980 to 2019 have all been male artists, even though 13.83% of the songs
are by female or mixed gender artists. “Juicy” by The Notorious B.I.G.
was a huge favorite.

## Save Image

``` r
ggsave("plot/plot_2020-04-14.png", p, width=8, height=5, units="in")
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
    ##  [1] ggrepel_0.8.2   forcats_0.5.0   stringr_1.4.0   dplyr_0.8.5     purrr_0.3.3     readr_1.3.1    
    ##  [7] tidyr_1.0.2     tibble_3.0.0    ggplot2_3.3.0   tidyverse_1.3.0
    ## 
    ## loaded via a namespace (and not attached):
    ##  [1] tidyselect_1.0.0 xfun_0.12        haven_2.2.0      lattice_0.20-38  colorspace_1.4-1 vctrs_0.2.4     
    ##  [7] generics_0.0.2   htmltools_0.4.0  yaml_2.2.1       utf8_1.1.4       rlang_0.4.5      pillar_1.4.3    
    ## [13] glue_1.4.0       withr_2.1.2      DBI_1.1.0        dbplyr_1.4.2     modelr_0.1.6     readxl_1.3.1    
    ## [19] lifecycle_0.2.0  munsell_0.5.0    gtable_0.3.0     cellranger_1.1.0 rvest_0.3.5      evaluate_0.14   
    ## [25] labeling_0.3     knitr_1.28       parallel_3.6.1   fansi_0.4.1      broom_0.5.5      Rcpp_1.0.4.6    
    ## [31] scales_1.1.0     backports_1.1.6  jsonlite_1.6.1   farver_2.0.3     fs_1.4.0         digest_0.6.25   
    ## [37] hms_0.5.3        packrat_0.5.0    stringi_1.4.6    grid_3.6.1       cli_2.0.2        tools_3.6.1     
    ## [43] magrittr_1.5     crayon_1.3.4     pkgconfig_2.0.3  ellipsis_0.3.0   rsconnect_0.8.16 xml2_1.3.1      
    ## [49] reprex_0.3.0     lubridate_1.7.4  rmarkdown_2.1    assertthat_0.2.1 httr_1.4.1       rstudioapi_0.11 
    ## [55] R6_2.4.1         nlme_3.1-145     compiler_3.6.1
