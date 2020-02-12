Hotels
================
Francis Lin | \#TidyTuesday |
2020-02-11

# Introduction

[Antonio, Almeida and
Nunes, 2019](https://www.sciencedirect.com/science/article/pii/S2352340918315191#f0010)
has provided some hotel data for \#TidyTuesday. While looking at this
dataset, I noticed that a large amount of datapoints were reservations
that were eventually cancelled. I decided to focus my efforts on seeing
if I can tease out any trends that I see.

# R Program

## Set up

``` r
# source utilities
source("../utilities.R")

# packages
library(tidyverse)
library(readr)
library(lubridate)

# set data path
data_path <- set_data_path()

# create plot folder if doesn't exist
if (!dir.exists("./plot")) {dir.create("./plot")}
```

## Load Data

``` r
hotels <- read_csv(paste0(data_path, "hotels.csv"))
```

## Manipulate Data

Here, I used the `lubridate` package to derive the scheduled arrival
date from the data, and find the difference in days between the
cancellation date and the scheduled arrival date. I then wanted to see
how the deposit type of the reservation affected the cancellation rates,
so I turned that into factors.

``` r
cancels <- hotels %>%
    filter(reservation_status=="Canceled") %>%
    mutate(arrival_date = ymd(paste(arrival_date_year, arrival_date_month, arrival_date_day_of_month, sep="-"))) %>%
    mutate(cancel_lead_time = as.numeric(arrival_date-ymd(reservation_status_date))) %>%
    mutate(deposit = factor(ifelse(deposit_type == "No Deposit", "No Deposit", "Deposit"), levels=c("Deposit", "No Deposit")))
```

## Plot Data

Here, I plotted the number of cancellations per cancellation lead time.

``` r
p <- ggplot(cancels %>% filter(cancel_lead_time < 51)) +
    geom_bar(aes(x=cancel_lead_time, fill=deposit)) + 
    labs(title="Hotel Cancellations", 
         subtitle="Last-minute hotel cancellations occur more frequently, and tend to have no deposit",
         x="Days between Cancellation and Scheduled Arrival Date", 
         y="Number of Cancellations") + 
    theme(legend.title=element_blank())
p
```

![](README_files/figure-gfm/plot%20data-1.png)<!-- -->

From the plot above, it seems the closer you get to the scheduled
arrival date, the more cancellations you receive, although it tapers off
to the right less drastically than I would have expected. As
cancellation lead time increases, the number of cancellation with no
deposits increase while the number of cancellation with deposits
decrease.

## Save Image

``` r
ggsave("plot/plot_2020-02-11.png", p, width=8, height=5, units="in")
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
    ##  [1] lubridate_1.7.4 forcats_0.4.0   stringr_1.4.0   dplyr_0.8.4     purrr_0.3.3     readr_1.3.1     tidyr_1.0.2     tibble_2.1.3   
    ##  [9] ggplot2_3.2.1   tidyverse_1.3.0
    ## 
    ## loaded via a namespace (and not attached):
    ##  [1] Rcpp_1.0.3         lattice_0.20-38    prettyunits_1.1.1  ps_1.3.0           utf8_1.1.4         assertthat_0.2.1  
    ##  [7] packrat_0.5.0      digest_0.6.23      R6_2.4.1           cellranger_1.1.0   backports_1.1.5    reprex_0.3.0      
    ## [13] stats4_3.6.1       evaluate_0.14      httr_1.4.1         pillar_1.4.3       rlang_0.4.4        lazyeval_0.2.2    
    ## [19] readxl_1.3.1       rstudioapi_0.10    callr_3.4.1        rmarkdown_2.1      labeling_0.3       loo_2.2.0         
    ## [25] munsell_0.5.0      broom_0.5.4        compiler_3.6.1     modelr_0.1.5       xfun_0.12          rstan_2.19.2      
    ## [31] pkgconfig_2.0.3    pkgbuild_1.0.6     htmltools_0.4.0    tidyselect_1.0.0   gridExtra_2.3      matrixStats_0.55.0
    ## [37] fansi_0.4.1        crayon_1.3.4       dbplyr_1.4.2       withr_2.1.2        grid_3.6.1         nlme_3.1-143      
    ## [43] jsonlite_1.6.1     gtable_0.3.0       lifecycle_0.1.0    DBI_1.1.0          magrittr_1.5       StanHeaders_2.19.0
    ## [49] scales_1.1.0       cli_2.0.1          stringi_1.4.5      farver_2.0.3       fs_1.3.1           xml2_1.2.2        
    ## [55] ellipsis_0.3.0     generics_0.0.2     vctrs_0.2.2        tools_3.6.1        glue_1.3.1         hms_0.5.3         
    ## [61] processx_3.4.1     parallel_3.6.1     yaml_2.2.1         inline_0.3.15      colorspace_1.4-1   rvest_0.3.5       
    ## [67] knitr_1.27         haven_2.2.0
