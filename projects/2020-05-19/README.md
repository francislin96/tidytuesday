Beach Volleyball
================
Francis Lin | \#TidyTuesday |
2020-05-19

# Introduction

I had just finished the book Outliers by Malcolm Gladwell. In the book,
Gladwell asserts that although hard work is necessary for success, there
are a lot of other factors as well. One example he provided was that
professional baseball and hockey players tend to have birthdates in
certain months depending on when the season started. The successful
players were often just a few months older than their peers in their
assigned age group, which gave them an advantage of being stronger,
faster, and more mature. I was curious to see if I can detect this same
effect in volleyball players.

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
vb_matches <- read_csv(paste0(data_path, "vb_matches.csv"), guess_max = 76000)
```

## Manipulate data

``` r
# get all player names and birthdates
temp <- vb_matches[c("w_player1","w_p1_birthdate")]
vb <- rbind(temp, 
      setNames(vb_matches[c("w_player2","w_p2_birthdate")], names(temp)),
      setNames(vb_matches[c("l_player1","l_p1_birthdate")], names(temp)),
      setNames(vb_matches[c("l_player2","l_p2_birthdate")], names(temp))
      ) %>%
    distinct() %>%
    
    # rename column names
    rename(player=w_player1, birthdate=w_p1_birthdate) %>%
    
    # get birth month count
    mutate(month=as.numeric(format(birthdate, "%m"))) %>%
    group_by(month) %>%
    summarise(n=n()) %>%
    
    # no NA
    filter(!is.na(month)) %>%
    
    # order by month
    mutate(month = factor(month.name[month], levels = month.name)) %>%
    arrange(month)
```

## Plot Data

``` r
p <- ggplot(vb, aes(x=month, y=n)) +
    geom_bar(stat="identity") + 
    labs(title="Beach Volleyball Player Birthdates", x="Month of Birth", y="Number of Players") + 
    theme(axis.text.x = element_text(angle = 90), plot.title = element_text(hjust = 0.5))
p
```

![](README_files/figure-gfm/plot%20data-1.png)<!-- -->

Interestingly, we see two small peaks: one at around April and one at
around September. However, the difference isn’t drastic. As far as I
know, volleyball is a sport played all year round, meaning the impact of
“birthdate drift” due to seasonal scheduling may be dampened. The data
is also global, so if there were seasons for volleyball, it may differ
from country to country.

## Save Image

``` r
ggsave("plot/plot_2020-05-19.png", p, width=7, height=5, units="in")
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
    ## [1] forcats_0.5.0   stringr_1.4.0   dplyr_0.8.5     purrr_0.3.3     readr_1.3.1     tidyr_1.0.2    
    ## [7] tibble_3.0.0    ggplot2_3.3.0   tidyverse_1.3.0
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
    ## [46] magrittr_1.5       StanHeaders_2.19.0 scales_1.1.0       cli_2.0.2          stringi_1.4.6     
    ## [51] farver_2.0.3       fs_1.4.0           xml2_1.3.1         ellipsis_0.3.0     generics_0.0.2    
    ## [56] vctrs_0.2.4        tools_3.6.1        glue_1.4.0         hms_0.5.3          yaml_2.2.1        
    ## [61] processx_3.4.2     parallel_3.6.1     inline_0.3.15      colorspace_1.4-1   rvest_0.3.5       
    ## [66] knitr_1.28         haven_2.2.0
