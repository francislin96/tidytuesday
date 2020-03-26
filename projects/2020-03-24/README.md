Traumatic Brain Injury (TBI)
================
Francis Lin | \#TidyTuesday |
2020-03-24

# Introduction

March is Brain Injury Awareness Month, and this week’s \#TidyTuesday
brings in Traumatic Brain Injuries (TBI) data from the
[CDC](https://www.cdc.gov/traumaticbraininjury/pdf/TBI-Surveillance-Report-FINAL_508.pdf)
and [Veterans Brain Injury
Center](https://dvbic.dcoe.mil/dod-worldwide-numbers-tbi). I actually
had no idea TBI was so common; one of every 60 people in the U.S. lives
with a TBI related disability. In the analysis below, I wanted to see
the most common ways people received TBI.

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
tbi_age <- read_csv(paste0(data_path, "tbi_age.csv"))
tbi_year <- read_csv(paste0(data_path, "tbi_year.csv"))
tbi_military <- read_csv(paste0(data_path, "tbi_military.csv"))
```

## Manipulate data

``` r
tbi_age <- tbi_age %>%
    filter(!age_group %in% c("Total", "0-17"), injury_mechanism != "Intentional self-harm") %>%
    mutate(age_group = factor(age_group, levels = c("0-4", "5-14", "15-24", "25-34", "35-44", "45-54", "55-64", "65-74", "75+")))
tbi_year_deaths <- tbi_year %>%
    filter(type=="Deaths", injury_mechanism != "Total")
```

## Plot Data

``` r
p1 <- ggplot(tbi_age, aes(x=age_group, y=rate_est, fill=injury_mechanism, )) + 
    geom_bar(position="stack", stat="identity") + 
    labs(x="Age Group", y="Rate/100,000", title="Rate of Traumatic Brain Injury by Age Group", fill="Injury Mechanism") + 
    theme(axis.text.x = element_text(angle=45))
p1
```

![](README_files/figure-gfm/plot%20data%201-1.png)<!-- -->

The 0-4 and the 75+ age groups both have very high rates of
unintentional falls compared to the other age groups. In addition,
people younger than 25 are often unintentionally struck by or against an
object. The 15-24 age group is also more susceptible to motor vehicle
crashes than other age
groups.

``` r
p2 <- ggplot(tbi_year_deaths, aes(x=year, y=rate_est, color=injury_mechanism)) +
    geom_line() +
    labs(x="Year", y="Rate/100,000", title="Rate of Deaths by TBI Over the Years", color="Injury Mechanism")
p2
```

![](README_files/figure-gfm/plot%20data%202-1.png)<!-- -->

The rate of TBI caused by intentional self-harm and unintentional falls
has increased over the years while the rate of TBI caused by motor
vehicle crashes has decreased.

## Save Image

``` r
ggsave("plot/plot1_2020-03-24.png", p1, width=8, height=5, units="in")
ggsave("plot/plot2_2020-03-24.png", p2, width=8, height=5, units="in")
```

## Session Info

``` r
sessionInfo()
```

    ## R version 3.6.0 (2019-04-26)
    ## Platform: x86_64-pc-linux-gnu (64-bit)
    ## Running under: Ubuntu 16.04.4 LTS
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
    ## [1] forcats_0.4.0   stringr_1.4.0   dplyr_0.8.4     purrr_0.3.3    
    ## [5] readr_1.3.1     tidyr_1.0.2     tibble_2.1.3    ggplot2_3.2.0  
    ## [9] tidyverse_1.2.1
    ## 
    ## loaded via a namespace (and not attached):
    ##  [1] Rcpp_1.0.3       cellranger_1.1.0 pillar_1.4.3     compiler_3.6.0  
    ##  [5] tools_3.6.0      digest_0.6.25    packrat_0.5.0    evaluate_0.14   
    ##  [9] lubridate_1.7.4  jsonlite_1.6.1   lifecycle_0.1.0  nlme_3.1-139    
    ## [13] gtable_0.3.0     lattice_0.20-38  pkgconfig_2.0.3  rlang_0.4.4     
    ## [17] cli_2.0.2        rstudioapi_0.11  yaml_2.2.1       parallel_3.6.0  
    ## [21] haven_2.1.1      xfun_0.8         withr_2.1.2      xml2_1.2.2      
    ## [25] httr_1.4.1       knitr_1.23       generics_0.0.2   vctrs_0.2.3     
    ## [29] hms_0.5.0        grid_3.6.0       tidyselect_1.0.0 glue_1.3.1      
    ## [33] R6_2.4.1         fansi_0.4.1      readxl_1.3.1     rmarkdown_1.13  
    ## [37] modelr_0.1.4     magrittr_1.5     htmltools_0.4.0  backports_1.1.5 
    ## [41] scales_1.0.0     rvest_0.3.4      assertthat_0.2.1 colorspace_1.4-1
    ## [45] labeling_0.3     stringi_1.4.6    lazyeval_0.2.2   munsell_0.5.0   
    ## [49] broom_0.5.2      crayon_1.3.4
