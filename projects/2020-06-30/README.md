Uncanny X-men
================
Francis Lin | \#TidyTuesday |
2020-06-30

# Introduction

This week’s data comes from the [Claremont Run
Project](http://www.claremontrun.com/). It was actually pretty
interesting to take a look at this dataset since I actually taught a
course on superheroes before\! If you’re interested, you can find some
of the material
[here](https://francislin96.github.io/projects/USIE/usie.html).

Comic series, especially those with superpower themes, are often
criticized for appealing to male fantasy and presenting unrealistic body
standards. For this week’s analysis, I wanted to take a look to see how
often issues from the X-men comic series pass the Bechdel test. My hope
is that passing the Bechdel test becomes more frequent as the issue
number increases.

# R Program

## Set up

``` r
# source utilities
source("../utilities.R")

# packages
library(tidyverse)
library(gridExtra)
library(grid)

# set data path
data_path <- set_data_path()

# create plot folder if doesn't exist
if (!dir.exists("./plot")) {dir.create("./plot")}
```

## Load Data

``` r
comic_bechdel <- read_csv(paste0(data_path, "comic_bechdel.csv"))
xmen_bechdel <- read_csv(paste0(data_path, "xmen_bechdel.csv"))
```

## Manipulate data

``` r
factor_to_string <- function(fctr){
    split <- strsplit(gsub("\\[|\\(|\\]|\\)", "", fctr), ",")[[1]]
    return(paste0(as.character(as.numeric(split[1])+1), "-", split[2]))
}

bechdel_comic <- comic_bechdel %>%
    
    # select relevant columns and dropna
    select(issue, pass_bechdel) %>%
    drop_na(issue, pass_bechdel) %>%
    
    # recode
    mutate(pass_bechdel = recode(pass_bechdel, yes = "Pass", no = "Fail")) %>%
    
    # factorize issue column
    mutate(issue_factor = cut(x = issue, breaks = seq(0, 300, 10))) %>%
    arrange(issue_factor) %>%
    #mutate(issue_factor = sapply(issue_factor, factor_to_string)) %>%
    
    # for each issue factor, calculate how many pass/fail bechdel test
    group_by(issue_factor, pass_bechdel) %>%
    summarize(count=n()) %>%
    ungroup() %>%
    group_by(issue_factor) %>%
    mutate(percent_pass = count/sum(count))


bechdel_xmen <- xmen_bechdel %>%
    
    # select relevant columns and dropna
    select(issue, pass_bechdel) %>%
    drop_na(issue, pass_bechdel) %>%
    
    # recode
    mutate(pass_bechdel = recode(pass_bechdel, yes = "Pass", no = "Fail")) %>%
    
    # factorize issue column
    mutate(issue_factor = cut(x = issue, breaks = seq(0, 550, 20))) %>%
    arrange(issue_factor) %>%
    #mutate(issue_factor = sapply(issue_factor, factor_to_string)) %>%
    
    # for each issue factor, calculate how many pass/fail bechdel test
    group_by(issue_factor, pass_bechdel) %>%
    summarize(count=n()) %>%
    ungroup() %>%
    group_by(issue_factor) %>%
    mutate(percent_pass = count/sum(count))
```

## Plot Data

``` r
p1 <- ggplot(bechdel_comic, aes(fill=pass_bechdel, y=count, x=issue_factor)) + 
    
    # bar chart
    geom_bar(position="fill", stat="identity") + 
    
    # label
    geom_text(aes(label = ifelse(pass_bechdel=="Pass", paste0(round(100*percent_pass),"%"),""),y=percent_pass-0.03),size = 3) +
    
    # relabel x axis
    scale_x_discrete(labels=sapply(levels(bechdel_comic$issue_factor), factor_to_string)) +
    
    # aesthetics
    theme_minimal() +
    theme(
        axis.text.y=element_blank(),
        axis.ticks.y=element_blank(),
        panel.grid.major = element_blank(),
        axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1),
        plot.title = element_text(vjust = -1, size=18)
        ) +
    labs(x="Issue", y="Percentage", fill="", title="Non-X-Men Comic Series")

p2 <- ggplot(bechdel_xmen, aes(fill=pass_bechdel, y=count, x=issue_factor)) + 
    
    # bar chart
    geom_bar(position="fill", stat="identity") + 
    
    # label
    geom_text(aes(label = ifelse(pass_bechdel=="Pass", paste0(round(100*percent_pass),"%"),""),y=percent_pass-0.03),size = 3) +
    
    # relabel x axis
    scale_x_discrete(labels=sapply(levels(bechdel_xmen$issue_factor), factor_to_string)) +
    
    # aesthetics
    theme_minimal() +
    theme(
        axis.text.y=element_blank(),
        axis.ticks.y=element_blank(),
        panel.grid.major = element_blank(),
        axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1),
        plot.title = element_text(vjust = -1, size=18)
        ) +
    labs(x="Issue", y="Percentage", fill="", title="Uncanny X-Men Comic Series")

p <- grid.arrange(p2, p1, nrow=2, top=textGrob("Comic Series Bechdel Test Results", gp=gpar(fontsize=24)))
```

![](README_files/figure-gfm/plot%20data-1.png)<!-- -->

## Save Image

``` r
ggsave("plot/plot_2020-06-30.png", p, width=12, height=8, units="in")
```

## Session Info

``` r
sessionInfo()
```

    ## R version 3.6.3 (2020-02-29)
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
    ## [1] grid      stats     graphics  grDevices utils     datasets  methods   base     
    ## 
    ## other attached packages:
    ##  [1] gridExtra_2.3   forcats_0.5.0   stringr_1.4.0   dplyr_1.0.0     purrr_0.3.4    
    ##  [6] readr_1.3.1     tidyr_1.1.0     tibble_3.0.1    ggplot2_3.3.1   tidyverse_1.3.0
    ## 
    ## loaded via a namespace (and not attached):
    ##  [1] tidyselect_1.1.0 xfun_0.14        haven_2.3.1      lattice_0.20-41  colorspace_1.4-1
    ##  [6] vctrs_0.3.1      generics_0.0.2   htmltools_0.4.0  yaml_2.2.1       blob_1.2.1      
    ## [11] rlang_0.4.6      pillar_1.4.4     withr_2.2.0      glue_1.4.1       DBI_1.1.0       
    ## [16] dbplyr_1.4.4     modelr_0.1.8     readxl_1.3.1     lifecycle_0.2.0  munsell_0.5.0   
    ## [21] gtable_0.3.0     cellranger_1.1.0 rvest_0.3.5      evaluate_0.14    labeling_0.3    
    ## [26] knitr_1.28       parallel_3.6.3   fansi_0.4.1      broom_0.5.6      Rcpp_1.0.4.6    
    ## [31] backports_1.1.7  scales_1.1.1     jsonlite_1.6.1   farver_2.0.3     fs_1.4.1        
    ## [36] hms_0.5.3        packrat_0.5.0    digest_0.6.25    stringi_1.4.6    cli_2.0.2       
    ## [41] tools_3.6.3      magrittr_1.5     crayon_1.3.4     pkgconfig_2.0.3  ellipsis_0.3.1  
    ## [46] xml2_1.3.2       reprex_0.3.0     lubridate_1.7.9  assertthat_0.2.1 rmarkdown_2.2   
    ## [51] httr_1.4.1       rstudioapi_0.11  R6_2.4.1         nlme_3.1-148     compiler_3.6.3
