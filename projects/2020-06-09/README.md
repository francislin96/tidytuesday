African American Achievements
================
Francis Lin | \#TidyTuesday |
2020-06-09

# Introduction

[George Floyd’s
death](https://www.nytimes.com/2020/05/31/us/george-floyd-investigation.html)
has sparked massive protests across the United States in support of
\#BlackLivesMatter. This week’s data comes from
[Wikipedia](https://en.wikipedia.org/wiki/List_of_African-American_firsts)
and celebrates African American achievements. I wanted to take a look at
if the percentage of female achievements increases over time.

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
firsts <- read_csv(paste0(data_path, "firsts.csv"))
```

## Manipulate data

``` r
# calculate median year
median_year <- median(firsts$year)

firsts_grouped <- firsts %>%
    # factorize gender
    mutate(gender=factor(gender, levels=c("Female African American Firsts", "African-American Firsts"))) %>%
    
    # create factors based on each category-year combination
    mutate(year=ifelse(year>=median_year, paste("after", median_year), paste("before", median_year))) %>%
    unite("category", category, year, sep="\n", remove=FALSE) %>%
    mutate(category = factor(category, levels=c(sort(unique(.$category)[1:8]), sort(unique(.$category)[9:16])))) %>%
    
    # count by gender for each category
    group_by(category, year, gender) %>%
    summarize(count=n()) %>%
    
    # include calculations for pie chart
    mutate(fraction=count/sum(count),
           label=ifelse(grepl("Female", gender), paste0(round(fraction*100,1), "%"), ifelse(fraction==1, "0.0%", "")),
           ymax=cumsum(fraction),
           ymin=c(0, head(ymax, n=-1)))
```

## Plot Data

``` r
p <- ggplot(firsts_grouped, aes(ymax=ymax, ymin=ymin, xmax=4, xmin=3, fill=gender)) +
    
    # pie chart
    geom_rect() +
    coord_polar("y", start=0) +
    xlim(c(1, 5)) +
    
    # facet wrap per category
    facet_wrap(~ category, nrow = 2) +
    
    # labels
    labs(title="African American Achievements", fill="", subtitle="The percentage of female African American achievements have increased in all categories except Social & Jobs and Sports.") +
    geom_text(aes(label = label, x = 1, y = 0), size=3) +
    
    # aesthetics
    theme_void() + 
    theme(legend.position = "bottom",
          plot.title = element_text(margin = margin(b=5), size = 20, hjust = 0.5),
          plot.subtitle = element_text(margin = margin(b=10), size = 10, hjust = 0.5)
          )
p
```

![](README_files/figure-gfm/plot%20data-1.png)<!-- -->

From the image above, we can see that the percentage of female African
American achievements have increased in all categories except Social &
Jobs and Sports.

## Save Image

``` r
ggsave("plot/plot_2020-06-09.png", p, width=12, height=5, units="in")
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
    ##  [1] scales_1.1.0    forcats_0.5.0   stringr_1.4.0   dplyr_0.8.5     purrr_0.3.3    
    ##  [6] readr_1.3.1     tidyr_1.0.2     tibble_3.0.0    ggplot2_3.3.0   tidyverse_1.3.0
    ## 
    ## loaded via a namespace (and not attached):
    ##  [1] Rcpp_1.0.4.6       lubridate_1.7.4    lattice_0.20-38    prettyunits_1.1.1 
    ##  [5] ps_1.3.2           assertthat_0.2.1   packrat_0.5.0      digest_0.6.25     
    ##  [9] R6_2.4.1           cellranger_1.1.0   backports_1.1.6    reprex_0.3.0      
    ## [13] stats4_3.6.1       evaluate_0.14      httr_1.4.1         pillar_1.4.3      
    ## [17] rlang_0.4.5        readxl_1.3.1       rstudioapi_0.11    callr_3.4.3       
    ## [21] rmarkdown_2.1      labeling_0.3       loo_2.2.0          munsell_0.5.0     
    ## [25] broom_0.5.5        compiler_3.6.1     modelr_0.1.6       xfun_0.12         
    ## [29] rstan_2.19.3       pkgconfig_2.0.3    pkgbuild_1.0.6     htmltools_0.4.0   
    ## [33] tidyselect_1.0.0   gridExtra_2.3      matrixStats_0.56.0 fansi_0.4.1       
    ## [37] crayon_1.3.4       dbplyr_1.4.2       withr_2.1.2        grid_3.6.1        
    ## [41] nlme_3.1-145       jsonlite_1.6.1     gtable_0.3.0       lifecycle_0.2.0   
    ## [45] DBI_1.1.0          magrittr_1.5       StanHeaders_2.19.0 cli_2.0.2         
    ## [49] stringi_1.4.6      farver_2.0.3       fs_1.4.0           xml2_1.3.1        
    ## [53] ellipsis_0.3.0     generics_0.0.2     vctrs_0.2.4        tools_3.6.1       
    ## [57] glue_1.4.0         hms_0.5.3          yaml_2.2.1         processx_3.4.2    
    ## [61] parallel_3.6.1     inline_0.3.15      colorspace_1.4-1   rvest_0.3.5       
    ## [65] knitr_1.28         haven_2.2.0
