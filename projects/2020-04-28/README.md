Broadway Weekly Grosses
================
Francis Lin | \#TidyTuesday |
2020-04-28

# Introduction

I wanted to try my hand at some animated graphs again. This week’s data
comes from [Playbill](https://www.playbill.com/grosses). In this
analysis, I made a racing bar chart using Broadway weekly grosses.

# R Program

## Set up

``` r
# source utilities
source("../utilities.R")

# packages
library(tidyverse)
library(lubridate)
library(gganimate)

# set data path
data_path <- set_data_path()

# create plot folder if doesn't exist
if (!dir.exists("./plot")) {dir.create("./plot")}
```

## Load Data

``` r
grosses <- read_csv(paste0(data_path, "grosses.csv"))
```

    ## Warning: 71078 parsing failures.
    ##  row              col           expected actual                                                 file
    ## 6862 potential_gross  1/0/T/F/TRUE/FALSE 383843 '../../tidytuesday/data/2020/2020-04-28/grosses.csv'
    ## 6862 top_ticket_price 1/0/T/F/TRUE/FALSE 50     '../../tidytuesday/data/2020/2020-04-28/grosses.csv'
    ## 6885 potential_gross  1/0/T/F/TRUE/FALSE 383843 '../../tidytuesday/data/2020/2020-04-28/grosses.csv'
    ## 6885 top_ticket_price 1/0/T/F/TRUE/FALSE 50     '../../tidytuesday/data/2020/2020-04-28/grosses.csv'
    ## 6909 potential_gross  1/0/T/F/TRUE/FALSE 383843 '../../tidytuesday/data/2020/2020-04-28/grosses.csv'
    ## .... ................ .................. ...... ....................................................
    ## See problems(...) for more details.

## Manipulate data

To make a racing bar chart, I needed to interpolate between given
values.

``` r
grosses_df <- grosses %>%
  
  # select relevant columns
  select(week_ending, show, weekly_gross) %>%
    
  # find sum of gross per week per show
  group_by(week_ending, show) %>%
  summarise(weekly_gross=sum(weekly_gross)) %>%
  ungroup() %>%
    
  # sort by week
  mutate(week_ending=ymd(week_ending)) %>%
  arrange(week_ending) %>%
    
  # calculate cumulative sum
  mutate(cumsum=ave(weekly_gross, show, FUN=cumsum))
  
grosses_df_interp <- grosses_df %>%
  # interpolate between shows and find cumulative sum
  group_by(show) %>%
  filter(n()>1) %>%
  complete(week_ending = full_seq(grosses_df$week_ending, 1)) %>%
  mutate(cumsum_smooth = (approx(x = week_ending, y = cumsum, xout = week_ending)$y)/1000000) %>%
  fill(cumsum_smooth) %>%
  
  # rank by week
  select(week_ending, show, cumsum_smooth) %>%
  group_by(week_ending) %>% 
  mutate(rank = min_rank(-cumsum_smooth) * 1) %>%
  
  # choose top 10 per week
  filter(rank <= 10) %>%
  ungroup()
```

## Plot Data

The .gif takes a long time to render.. be
patient\!

``` r
p <- ggplot(grosses_df_interp, aes(x=rank, y=show, label=show, group=show, fill = show)) +
  
  # tile
  geom_tile(aes(y=cumsum_smooth/2, height=cumsum_smooth, width=0.9, fill=show), alpha=0.8) +
  
  # label of show
  geom_text(aes(y = cumsum_smooth, label = show, hjust = ifelse(cumsum_smooth > 800, 1, 0))) +
    
  # flip coordinate
  coord_flip(clip = "off", expand = FALSE) +
    
  # display dollar amounts with commas
  scale_y_continuous(labels = scales::comma) +
    
  # display shows in descending order
  scale_x_reverse() +
    
  # aesthetics
  theme_minimal() +
  theme(plot.title=element_text(face="bold", hjust=0, size=30), axis.ticks.y=element_blank(), axis.text.y=element_blank(), panel.grid.major = element_blank(), legend.position="none") +
  labs(title='{format(as.Date(closest_state), "%Y %b %d")}', x="", y="Total Gross (Millions of Dollars)") +
  
  # animation
  transition_states(week_ending, transition_length=5, state_length=1, wrap = FALSE) +
  ease_aes("cubic-in-out")

animation <- animate(p, nframes=27000, fps=50, end_pause=100, width=546, height=390)
animation
```

![](README_files/figure-gfm/plot%20data-1.gif)<!-- -->

## Save Image

``` r
anim_save("plot/plot_2020-04-28.gif", animation)
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
    ##  [1] gganimate_1.0.5 lubridate_1.7.8 forcats_0.5.0   stringr_1.4.0  
    ##  [5] dplyr_0.8.5     purrr_0.3.3     readr_1.3.1     tidyr_1.0.2    
    ##  [9] tibble_3.0.0    ggplot2_3.3.0   tidyverse_1.3.0
    ## 
    ## loaded via a namespace (and not attached):
    ##  [1] Rcpp_1.0.4.6      lattice_0.20-38   prettyunits_1.1.1 assertthat_0.2.1 
    ##  [5] digest_0.6.25     R6_2.4.1          cellranger_1.1.0  plyr_1.8.6       
    ##  [9] backports_1.1.6   reprex_0.3.0      evaluate_0.14     httr_1.4.1       
    ## [13] pillar_1.4.3      rlang_0.4.5       progress_1.2.2    readxl_1.3.1     
    ## [17] rstudioapi_0.11   gifski_0.8.6      rmarkdown_2.1     labeling_0.3     
    ## [21] munsell_0.5.0     broom_0.5.5       compiler_3.6.1    modelr_0.1.6     
    ## [25] xfun_0.13         pkgconfig_2.0.3   htmltools_0.4.0   tidyselect_1.0.0 
    ## [29] fansi_0.4.1       crayon_1.3.4      dbplyr_1.4.2      withr_2.1.2      
    ## [33] grid_3.6.1        nlme_3.1-147      jsonlite_1.6.1    gtable_0.3.0     
    ## [37] lifecycle_0.2.0   DBI_1.1.0         magrittr_1.5      scales_1.1.0     
    ## [41] cli_2.0.2         stringi_1.4.6     farver_2.0.3      fs_1.4.1         
    ## [45] xml2_1.3.1        ellipsis_0.3.0    generics_0.0.2    vctrs_0.2.4      
    ## [49] tools_3.6.1       glue_1.4.0        tweenr_1.0.1      hms_0.5.3        
    ## [53] parallel_3.6.1    yaml_2.2.1        colorspace_1.4-1  rvest_0.3.5      
    ## [57] knitr_1.28        haven_2.2.0
