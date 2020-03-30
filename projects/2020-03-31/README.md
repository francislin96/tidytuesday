Beer Production
================
Francis Lin | \#TidyTuesday |
2020-03-31

# Introduction

This week’s data comes from the [Alcohol and Tobacco Tax and Trade
Bureau](https://www.ttb.gov/beer/statistics). Here, I wanted to take a
look to see how brewing materials has changed over time.

# R Program

## Set up

``` r
# source utilities
source("../utilities.R")

# packages
library(tidyverse)
library(lubridate)
library(gridExtra)

# set data path
data_path <- set_data_path()

# create plot folder if doesn't exist
if (!dir.exists("./plot")) {dir.create("./plot")}
```

## Load Data

``` r
beer_states <- read_csv(paste0(data_path, "beer_states.csv"))
beer_taxed <- read_csv(paste0(data_path, "beer_taxed.csv"))
brewer_size <- read_csv(paste0(data_path, "brewer_size.csv"))
brewing_materials <- read_csv(paste0(data_path, "brewing_materials.csv"))
```

## Manipulate data

Here, I filtered out all of the rows that displayed aggregate data, and
reordered the “type” column so that the category “Other” appears last in
the plots below.

``` r
materials <- brewing_materials %>%
    filter(!grepl("^Total", material_type)) %>%
    mutate(date=ymd(paste(year, month, 1,sep="-")), amount_tons = month_current/2000) %>%
    mutate(type=fct_relevel(factor(type), "Other", after=Inf)) %>%
    select(date, material_type, type, amount_tons)
```

## Plot Data

This week, I learned a few more tricks on using `ggplot`. The
`grid.arrange` function from the `gridExtra` package allows me to have
different legends for each of the plots in the plot matrix.

``` r
options(scipen=100000)
materials_split = split(materials, f=materials$material_type)

p1 <- ggplot(materials_split$`Grain Products`, aes(x=date, y=amount_tons, color=type)) + 
    geom_line() + 
    labs(x="Date", y="Amount (tons)", color="Type") +
    facet_wrap(~material_type)
p2 <- p1 %+% materials_split$`Non-Grain Products`

p <- grid.arrange(p1, p2)
```

![](README_files/figure-gfm/plot%20data-1.png)<!-- -->

According to the data, malt products have decreased drastically in 2016,
and hops had two large spikes in at the end of 2014 and 2015. I’m not
sure how accurate this data is, but it looks that way.

## Save Image

``` r
ggsave("plot/plot_2020-03-31.png", p, width=7, height=5, units="in")
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
    ##  [1] scales_1.1.0    gridExtra_2.3   lubridate_1.7.4 forcats_0.4.0   stringr_1.4.0  
    ##  [6] dplyr_0.8.4     purrr_0.3.3     readr_1.3.1     tidyr_1.0.2     tibble_2.1.3   
    ## [11] ggplot2_3.2.1   tidyverse_1.3.0
    ## 
    ## loaded via a namespace (and not attached):
    ##  [1] Rcpp_1.0.3         lattice_0.20-38    prettyunits_1.1.1  ps_1.3.2          
    ##  [5] utf8_1.1.4         assertthat_0.2.1   packrat_0.5.0      digest_0.6.25     
    ##  [9] plyr_1.8.5         R6_2.4.1           cellranger_1.1.0   backports_1.1.5   
    ## [13] reprex_0.3.0       stats4_3.6.1       evaluate_0.14      httr_1.4.1        
    ## [17] pillar_1.4.3       rlang_0.4.5        lazyeval_0.2.2     readxl_1.3.1      
    ## [21] rstudioapi_0.11    callr_3.4.2        rmarkdown_2.1      labeling_0.3      
    ## [25] loo_2.2.0          munsell_0.5.0      broom_0.5.4        compiler_3.6.1    
    ## [29] modelr_0.1.6       xfun_0.12          rstan_2.19.3       pkgconfig_2.0.3   
    ## [33] pkgbuild_1.0.6     htmltools_0.4.0    tidyselect_1.0.0   matrixStats_0.55.0
    ## [37] fansi_0.4.1        crayon_1.3.4       dbplyr_1.4.2       withr_2.1.2       
    ## [41] grid_3.6.1         nlme_3.1-144       jsonlite_1.6.1     gtable_0.3.0      
    ## [45] lifecycle_0.1.0    DBI_1.1.0          magrittr_1.5       StanHeaders_2.19.0
    ## [49] cli_2.0.2          stringi_1.4.6      reshape2_1.4.3     farver_2.0.3      
    ## [53] fs_1.3.1           xml2_1.2.2         generics_0.0.2     vctrs_0.2.4       
    ## [57] tools_3.6.1        glue_1.3.1         hms_0.5.3          yaml_2.2.1        
    ## [61] processx_3.4.2     parallel_3.6.1     inline_0.3.15      colorspace_1.4-1  
    ## [65] rvest_0.3.5        knitr_1.28         haven_2.2.0
