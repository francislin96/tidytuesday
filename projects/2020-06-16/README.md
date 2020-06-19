American Slavery and Juneteenth
================
Francis Lin | \#TidyTuesday |
2020-06-16

# Introduction

In continuation of support for BLM and celebration for Juneteenth, this
week’s data comes from [U.S. Census’s
Archives](https://www.census.gov/content/dam/Census/library/working-papers/2002/demo/POP-twps0056.pdf)

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
census <- read_csv(paste0(data_path, "census.csv"))
```

## Manipulate data

``` r
 census_clean <- census %>%
    # select relevant columns
    select(region, year, black_free, black_slaves) %>%
    
    # filter out USA total, because we want to keep only regions
    filter(!grepl("USA Total", region)) %>%
    
    # turn region to factor
    mutate(region = factor(region, levels=c("South", "Northeast", "Midwest", "West"))) %>%
    
    # find number of free/slave
    group_by(region, year) %>%
    summarize(Free=sum(black_free), Slave=sum(black_slaves)) %>%
    
    # pivot longer to create status column for free/slave
    pivot_longer(c(Free, Slave), names_to="status", values_to="count") %>%
    
    # create free/slave percentage label
    group_by(region, year) %>%
    mutate(count=count/1000000, percent_free = round(count/sum(count)*100), total_count=sum(count)) %>%
    rowwise() %>% mutate(label=ifelse(status=="Free", paste0(toString(percent_free), "%"), ""))
```

## Plot Data

``` r
p <- ggplot(census_clean) + 
    geom_bar(aes(year, count, fill=status), stat="identity", position="stack", width=5) + 
    geom_text(aes(year, total_count, label=label), vjust=0, size=3) +
    scale_x_continuous(breaks=seq(1790, 1870, 20)) +
    facet_wrap(~region, nrow = 1) + 
    labs(x="Year", y="Number of Blacks (Millions)", title="Number of Free and Enslaved African Americans in the US 1790-1870", fill="Status") +
    theme(plot.title = element_text(hjust = 0.5, size=16))
p
```

![](README_files/figure-gfm/plot%20data-1.png)<!-- -->

Most African Americans lived in the South, and were not considered freed
until after the Emancipation Proclamation. Even after the signing of the
Emancipation Proclamation, some slaves were not notified of their freed
status as far as June 19, 1865, also known as Juneteenth. In the
Northeast, African Americans slaves were considered rare a couple
decades before slaves everywhere in the US were freed.

## Save Image

``` r
ggsave("plot/plot_2020-06-16.png", p, width=12, height=3, units="in")
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
    ## [1] forcats_0.5.0   stringr_1.4.0   dplyr_0.8.5     purrr_0.3.3    
    ## [5] readr_1.3.1     tidyr_1.0.2     tibble_3.0.0    ggplot2_3.3.0  
    ## [9] tidyverse_1.3.0
    ## 
    ## loaded via a namespace (and not attached):
    ##  [1] Rcpp_1.0.4         lubridate_1.7.4    lattice_0.20-38    prettyunits_1.1.1 
    ##  [5] ps_1.3.2           digest_0.6.25      assertthat_0.2.1   packrat_0.5.0     
    ##  [9] R6_2.4.1           cellranger_1.1.0   backports_1.1.5    reprex_0.3.0      
    ## [13] stats4_3.6.1       evaluate_0.14      httr_1.4.1         pillar_1.4.3      
    ## [17] rlang_0.4.5        readxl_1.3.1       rstudioapi_0.11    callr_3.4.3       
    ## [21] rmarkdown_2.1      labeling_0.3       loo_2.2.0          munsell_0.5.0     
    ## [25] broom_0.5.5        compiler_3.6.1     modelr_0.1.6       xfun_0.12         
    ## [29] rstan_2.19.3       pkgconfig_2.0.3    pkgbuild_1.0.6     htmltools_0.4.0   
    ## [33] tidyselect_1.0.0   gridExtra_2.3      matrixStats_0.56.0 fansi_0.4.1       
    ## [37] crayon_1.3.4       dbplyr_1.4.2       withr_2.1.2        grid_3.6.1        
    ## [41] nlme_3.1-145       jsonlite_1.6.1     gtable_0.3.0       lifecycle_0.2.0   
    ## [45] DBI_1.1.0          magrittr_1.5       StanHeaders_2.19.0 scales_1.1.0      
    ## [49] cli_2.0.2          stringi_1.4.6      farver_2.0.3       fs_1.4.0          
    ## [53] xml2_1.2.5         ellipsis_0.3.0     generics_0.0.2     vctrs_0.2.4       
    ## [57] tools_3.6.1        glue_1.3.2         hms_0.5.3          yaml_2.2.1        
    ## [61] processx_3.4.2     parallel_3.6.1     inline_0.3.15      colorspace_1.4-1  
    ## [65] rvest_0.3.5        knitr_1.28         haven_2.2.0
