Marble Racing
================
Francis Lin | \#TidyTuesday |
2020-06-02

# Introduction

Did you know marble racing was a thing? I had no idea. This week’s data
comes from [Jelle’s Marble
Runs](https://www.youtube.com/channel/UCYJdpnjuSWVOLgGT9fIzL0g) and
contains track completion time for each marble. I wouldn’t have guessed,
but some marbles do consistently perform better than others. I took the
opportunity to see if I can replicate [this visualization by Randal
Olson](http://www.randalolson.com/2020/05/24/a-data-driven-look-at-marble-racing/).

# R Program

## Set up

``` r
# source utilities
source("../utilities.R")

# packages
library(tidyverse)
library(scales)

# set data path
data_path <- set_data_path()

# create plot folder if doesn't exist
if (!dir.exists("./plot")) {dir.create("./plot")}
```

## Load Data

``` r
marbles <- read_csv(paste0(data_path, "marbles.csv"))
```

## Manipulate data

``` r
# find average race time of each race
marbles_avg_time <- marbles %>%
    group_by(race) %>%
    summarize(avg_time_race = mean(time_s, na.rm=TRUE))

# calculate time difference between each marble's time per race and the average race time
marbles_diff <- marbles %>%
    left_join(marbles_avg_time, by="race") %>%
    filter(!is.na(time_s)) %>%
    mutate(time_diff = 1+(time_s - avg_time_race)/avg_time_race)
```

## Plot Data

``` r
# create color palette
colorpalette = colorRampPalette(c("#5d669e", "#8dc4a6", "#f6f3c1", "#e39065", "#9a254c"))

p <- ggplot(marbles_diff, aes(x=fct_reorder(marble_name, time_diff, .fun=median, .desc=TRUE), 
                         y=time_diff
                         )) +
    stat_boxplot(geom ='errorbar', width = 0.5) + 
    geom_boxplot(fill=colorpalette(32), outlier.shape=18) +
    scale_y_continuous(labels=scales::number_format(accuracy=0.01, suffix="x")) +
    coord_flip() +
    labs(x="Marble Names", 
         y="Individual Race Times Relative to Average Race Times",
         title="Not all marble racers are created equal") +
    theme(panel.grid.minor=element_blank(),
          panel.grid.major.x=element_line(colour="grey90", size=0.5),
          panel.grid.major.y=element_blank(),
          panel.background=element_blank(),
          panel.border=element_rect(colour = "grey80", fill=NA, size=0.5),
          axis.title=element_text(size=16),
          axis.ticks=element_blank(),
          axis.text=element_text(size=12),
          plot.title = element_text(size=18, hjust = 0.5))
p
```

![](README_files/figure-gfm/plot%20data-1.png)<!-- -->

## Save Image

``` r
ggsave("plot/plot_2020-06-02.png", p, width=9, height=12, units="in")
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
    ##  [1] scales_1.1.0       RColorBrewer_1.1-2 forcats_0.5.0      stringr_1.4.0      dplyr_0.8.5       
    ##  [6] purrr_0.3.3        readr_1.3.1        tidyr_1.0.2        tibble_3.0.0       ggplot2_3.3.0     
    ## [11] tidyverse_1.3.0   
    ## 
    ## loaded via a namespace (and not attached):
    ##  [1] Rcpp_1.0.4.6       lubridate_1.7.4    lattice_0.20-38    prettyunits_1.1.1  ps_1.3.2          
    ##  [6] assertthat_0.2.1   packrat_0.5.0      digest_0.6.25      R6_2.4.1           cellranger_1.1.0  
    ## [11] backports_1.1.6    reprex_0.3.0       stats4_3.6.1       evaluate_0.14      httr_1.4.1        
    ## [16] pillar_1.4.3       rlang_0.4.5        readxl_1.3.1       rstudioapi_0.11    callr_3.4.3       
    ## [21] rmarkdown_2.1      labeling_0.3       loo_2.2.0          munsell_0.5.0      broom_0.5.5       
    ## [26] compiler_3.6.1     modelr_0.1.6       xfun_0.12          rstan_2.19.3       pkgconfig_2.0.3   
    ## [31] pkgbuild_1.0.6     htmltools_0.4.0    tidyselect_1.0.0   gridExtra_2.3      matrixStats_0.56.0
    ## [36] fansi_0.4.1        crayon_1.3.4       dbplyr_1.4.2       withr_2.1.2        grid_3.6.1        
    ## [41] nlme_3.1-145       jsonlite_1.6.1     gtable_0.3.0       lifecycle_0.2.0    DBI_1.1.0         
    ## [46] magrittr_1.5       StanHeaders_2.19.0 cli_2.0.2          stringi_1.4.6      farver_2.0.3      
    ## [51] fs_1.4.0           xml2_1.3.1         ellipsis_0.3.0     generics_0.0.2     vctrs_0.2.4       
    ## [56] tools_3.6.1        glue_1.4.0         hms_0.5.3          yaml_2.2.1         processx_3.4.2    
    ## [61] parallel_3.6.1     inline_0.3.15      colorspace_1.4-1   rvest_0.3.5        knitr_1.28        
    ## [66] haven_2.2.0
