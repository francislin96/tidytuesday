GDPR Fines
================
Francis Lin | \#TidyTuesday |
2020-04-21

# Introduction

According to
[Wikipedia](https://en.wikipedia.org/wiki/General_Data_Protection_Regulation),
The General Data Protection Regulation (EU) 2016/679 (GDPR) is a
regulation in EU law on data protection and privacy in the European
Union (EU) and the European Economic Area (EEA). In this analysis, I
wanted to see which articles result in the highest amounts of fines.

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
gdpr_text <- read_tsv(paste0(data_path, "gdpr_text.tsv"))
gdpr_violations <- read_tsv(paste0(data_path, "gdpr_violations.tsv"))
```

## Manipulate data

A lot of this work was done by [Julia
Silge](https://juliasilge.com/blog/gdpr-violations/).

``` r
gdpr_tidy <- gdpr_violations %>%
  distinct() %>%
  mutate(article = str_extract_all(article_violated, "Art.[:digit:]+|Art. [:digit:]+")) %>%
  mutate(total_articles = map_int(article, length)) %>% 
  mutate(avg_price = price/total_articles) %>%
  unnest(article) %>%
  add_count(article) %>%
  filter(n > 10) %>%
  select(-n) %>%
  select(article, avg_price) %>%
  mutate(article = fct_reorder(article, avg_price))
```

## Plot Data

``` r
p <- ggplot(gdpr_tidy) +
  geom_boxplot(aes(x=article, y=avg_price)) + 
  scale_y_log10() + 
  labs(x="Article", y="Fine (EUR)", title="GDPR Fines")
p
```

    ## Warning: Transformation introduced infinite values in continuous y-axis

    ## Warning: Removed 12 rows containing non-finite values (stat_boxplot).

![](README_files/figure-gfm/plot%20data-1.png)<!-- -->

Article 32 resulted in the highest average fine amount. You can find the
text of the regulation
[here](https://www.privacy-regulation.eu/en/article-32-security-of-processing-GDPR.htm).

## Save Image

``` r
ggsave("plot/plot_2020-04-21.png", p, width=7, height=5, units="in")
```

    ## Warning: Transformation introduced infinite values in continuous y-axis

    ## Warning: Removed 12 rows containing non-finite values (stat_boxplot).

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
    ##  [1] tidyselect_1.0.0 xfun_0.12        haven_2.2.0      lattice_0.20-38  colorspace_1.4-1 vctrs_0.2.4     
    ##  [7] generics_0.0.2   htmltools_0.4.0  yaml_2.2.1       rlang_0.4.5      pillar_1.4.3     glue_1.4.0      
    ## [13] withr_2.1.2      DBI_1.1.0        dbplyr_1.4.2     modelr_0.1.6     readxl_1.3.1     lifecycle_0.2.0 
    ## [19] munsell_0.5.0    gtable_0.3.0     cellranger_1.1.0 rvest_0.3.5      evaluate_0.14    knitr_1.28      
    ## [25] parallel_3.6.1   fansi_0.4.1      broom_0.5.5      Rcpp_1.0.4.6     scales_1.1.0     backports_1.1.6 
    ## [31] jsonlite_1.6.1   farver_2.0.3     fs_1.4.0         hms_0.5.3        packrat_0.5.0    digest_0.6.25   
    ## [37] stringi_1.4.6    grid_3.6.1       cli_2.0.2        tools_3.6.1      magrittr_1.5     crayon_1.3.4    
    ## [43] pkgconfig_2.0.3  ellipsis_0.3.0   xml2_1.3.1       reprex_0.3.0     lubridate_1.7.4  rmarkdown_2.1   
    ## [49] assertthat_0.2.1 httr_1.4.1       rstudioapi_0.11  R6_2.4.1         nlme_3.1-145     compiler_3.6.1
