Hockey Goals
================
Francis Lin | \#TidyTuesday |
2020-03-23

# Introduction

This week’s \#TidyTuesday was pretty exciting for me\! I learned a new
function from the tidyverse: `separate`, which turns a character column
into multiple columns. Additionally, I learned to place an image
annotation in ggplot. The data for this analysis comes from
[HockeyReference.com](HockeyReference.com), and I made a graph similar
to one in an article by the [Washington
Post](https://www.washingtonpost.com/graphics/2020/sports/capitals/ovechkin-700-goals/?utm_campaign=wp_graphics&utm_medium=social&utm_source=twitter)
celebrating [Alex
Ovechkin](https://en.wikipedia.org/wiki/Alexander_Ovechkin)’s monumental
achievement of 700 career hockey goals.

# R Program

## Set up

``` r
# source utilities
source("../utilities.R")

# packages
library(tidyverse)
library(readr)
library(grid)
library(jpeg)
library(RCurl)

# set data path
data_path <- set_data_path()

# create plot folder if doesn't exist
if (!dir.exists("./plot")) {dir.create("./plot")}
```

## Load Data

``` r
game_goals <- read_csv(paste0(data_path, "game_goals.csv"))
top_250 <- read_csv(paste0(data_path, "top_250.csv"))
season_goals <- read_csv(paste0(data_path, "season_goals.csv"))
```

## Manipulate data

Using the `separate` function, I was able to parse out players’ ages,
which was originally stored in the format “years-days” as a string, and
calculate their ages as a numeric value. I then calculated the
cumulative sum of goals throughout their careers.

``` r
cumsum_goals <- game_goals %>%
    
    # select only relevant columns
    select(player, age, goals) %>%
    
    # get top 10 players in terms of total goals scored in career
    add_count(player, wt=goals, name="temp") %>%
    mutate(temp = dense_rank(desc(temp))) %>%
    filter(temp %in% 1:10) %>%
    select(-temp) %>%

    # calculate age
    separate(age, c("age_years", "age_days"), sep="-") %>%
    mutate(age_years = as.numeric(age_years), age_days = as.numeric(age_days), age = age_years + age_days/365) %>%

    # calculate cumulative sum of goal throughout age
    group_by(player) %>%
    arrange(age) %>%
    mutate(csum_goals = cumsum(goals)) %>%
    
    # select relevant columns
    select(player, age, csum_goals)
```

## Plot Data

Here, I plotted the cumulative total of goals that the top 10 players
scored as a function of their age. In addition, I used
`annotation_custom` to add Alex Ovechkin’s headshot into the ggplot
image. I also highlighted his path to 700 goals.

``` r
# image
image_grob <- grid::rasterGrob(jpeg::readJPEG(RCurl::getURLContent(unique(season_goals %>% filter(player == "Alex Ovechkin") %>% select(headshot))[1])), interpolate=TRUE)

# plot
p <- ggplot(cumsum_goals, aes(x=age, y=csum_goals, group=player)) + 
    
    # plot all players
    geom_line(color = alpha("grey", 0.7)) + 
    
    # plot Alex Ovechkin
    geom_line(data=cumsum_goals %>% filter(player == "Alex Ovechkin"), color=alpha("red", 1)) + 
    
    # horizontal line
    geom_hline(yintercept=700, linetype="dashed", color=alpha("turquoise", 0.5)) + 
    
    # Alex's picture
    annotation_custom(image_grob, xmin = 33.5, xmax = 38.5, ymin = 600, ymax = 800) + 
    
    # labels
    labs(x="Age", y="Number of Career Goals", title="Alex Ovechkin has reached 700 goals in the NHL", subtitle="He is the second youngest NHL player to do so, behind Wayne Gretzky")
p
```

![](README_files/figure-gfm/plot%20data-1.png)<!-- -->

Congratulations to Alex\!

## Save Image

``` r
ggsave("plot/plot_2020-03-23.png", p, width=7, height=5, units="in")
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
    ## [1] grid      stats     graphics  grDevices utils     datasets  methods   base     
    ## 
    ## other attached packages:
    ##  [1] RCurl_1.98-1.1  jpeg_0.1-8.1    forcats_0.4.0   stringr_1.4.0   dplyr_0.8.4     purrr_0.3.3    
    ##  [7] readr_1.3.1     tidyr_1.0.2     tibble_2.1.3    ggplot2_3.2.1   tidyverse_1.3.0
    ## 
    ## loaded via a namespace (and not attached):
    ##  [1] tidyselect_1.0.0 xfun_0.12        haven_2.2.0      lattice_0.20-38  colorspace_1.4-1
    ##  [6] vctrs_0.2.3      generics_0.0.2   htmltools_0.4.0  yaml_2.2.1       rlang_0.4.4     
    ## [11] pillar_1.4.3     glue_1.3.1       withr_2.1.2      DBI_1.1.0        dbplyr_1.4.2    
    ## [16] modelr_0.1.6     readxl_1.3.1     lifecycle_0.1.0  munsell_0.5.0    gtable_0.3.0    
    ## [21] cellranger_1.1.0 rvest_0.3.5      evaluate_0.14    labeling_0.3     knitr_1.28      
    ## [26] parallel_3.6.1   fansi_0.4.1      broom_0.5.4      Rcpp_1.0.3       scales_1.1.0    
    ## [31] backports_1.1.5  jsonlite_1.6.1   farver_2.0.3     fs_1.3.1         digest_0.6.25   
    ## [36] hms_0.5.3        packrat_0.5.0    stringi_1.4.6    cli_2.0.1        tools_3.6.1     
    ## [41] bitops_1.0-6     magrittr_1.5     lazyeval_0.2.2   crayon_1.3.4     pkgconfig_2.0.3 
    ## [46] ellipsis_0.3.0   xml2_1.2.2       reprex_0.3.0     lubridate_1.7.4  rmarkdown_2.1   
    ## [51] assertthat_0.2.1 httr_1.4.1       rstudioapi_0.11  R6_2.4.1         nlme_3.1-144    
    ## [56] compiler_3.6.1
