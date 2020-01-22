Spotify Songs
================
Francis Lin | \#TidyTuesday |
2020-01-21

# Introduction

The data this week comes from Spotify and the [spotifyr
package](https://www.rcharlie.com/spotifyr/). In this analysis, I was
curious about whether certain song attributes are correlated with the
popularity of the song and how that correlation changed over time.

# R Program

## Set up

``` r
# source utilities
source("../utilities.R")

# packages
library(tidyverse)
library(lubridate)
library(readr)

# set data path
data_path <- set_data_path()

# create plot folder if doesn't exist
if (!dir.exists("./plot")) {dir.create("./plot")}
```

## Load Data

``` r
# read in data
spotify_songs <- read_csv(paste0(data_path, "spotify_songs.csv"))
```

## Manipulate Data

``` r
# find unique songs, add year
spotify_songs <- spotify_songs %>%
    distinct(track_name, track_artist, .keep_all = TRUE) %>%
    mutate(year=year(ymd(track_album_release_date, truncated=2)))

# find correlation of popularity with song attributes
spotify_corr <- spotify_songs %>%
    distinct(track_name, track_artist, .keep_all = TRUE) %>%
    mutate(year=year(ymd(track_album_release_date, truncated=2))) %>%
    group_by(year) %>%
    filter(n() >= 10) %>%
    summarise("Danceability"=cor(track_popularity, danceability),
              "Energy"=cor(track_popularity, energy),
              "Loudness"=cor(track_popularity, loudness),
              "Speechiness"=cor(track_popularity, speechiness),
              "Acousticness"=cor(track_popularity, acousticness),
              "Instrumentalness"=cor(track_popularity, instrumentalness),
              "Liveness"=cor(track_popularity, liveness),
              "Happiness (valence)"=cor(track_popularity, valence),
              "Tempo"=cor(track_popularity, tempo),
              "Song Length"=cor(track_popularity, duration_ms)) %>%
    pivot_longer(-year, names_to="Parameter", values_to="score")
```

## Plot Data

``` r
p <- ggplot(spotify_corr) + 
    geom_point(aes(x=year, y=score), size=0.5, col="tomato") +
    geom_smooth(aes(x=year, y=score), se=FALSE) +
    geom_hline(yintercept=0, alpha=0.5) +
    facet_wrap(~Parameter, ncol = 5) + 
    labs(title="Correlation between Song Attributes and Popularity over Time (1965-2020)", x="Year", y="Correlation Coefficient")
p
```

![](README_files/figure-gfm/plot%20data-1.png)<!-- -->

From this graph, it seems we can draw a few quick conclusions:

  - The tempo-popularity and liveness-popularity correlation does not
    change much throughout the years.
  - Songs with acousticness are slowly becoming more popular as time
    goes on.
  - Danceability of a track was positively correlated with its
    popularity only before 1980 and after 2010.
  - The energy of a song was only negatively correlated with popularity
    in recent years.
  - The popularity of happy songs are now on the rise.
  - Instrumentalness of a song used to be positively correlated with
    popularity until about 1980.
  - Loud songs are always popular, although less so recently.
  - Longer songs tend to be slightly less popular.
  - Speechiness in songs have recently taken off. This is probably due
    to rise in popularity of rap songs, which tend to have high
    speechiness ratings.

## Save Image

``` r
ggsave("plot/plot_2020-01-21.png", p, width=12, height=6, units="in")
```

## Session Info

``` r
#session info
sessionInfo()
```

    ## R version 3.6.1 (2019-07-05)
    ## Platform: x86_64-pc-linux-gnu (64-bit)
    ## Running under: Ubuntu 16.04.4 LTS
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
    ##  [1] lubridate_1.7.4 forcats_0.4.0   stringr_1.4.0   dplyr_0.8.3     purrr_0.3.3     readr_1.3.1     tidyr_1.0.0    
    ##  [8] tibble_2.1.3    ggplot2_3.2.1   tidyverse_1.3.0
    ## 
    ## loaded via a namespace (and not attached):
    ##  [1] Rcpp_1.0.3         lattice_0.20-38    prettyunits_1.1.0  ps_1.3.0           digest_0.6.23      assertthat_0.2.1  
    ##  [7] zeallot_0.1.0      packrat_0.5.0      R6_2.4.1           cellranger_1.1.0   backports_1.1.5    reprex_0.3.0      
    ## [13] stats4_3.6.1       evaluate_0.14      httr_1.4.1         pillar_1.4.3       rlang_0.4.2        lazyeval_0.2.2    
    ## [19] readxl_1.3.1       rstudioapi_0.10    callr_3.4.0        rmarkdown_2.0      labeling_0.3       loo_2.2.0         
    ## [25] munsell_0.5.0      broom_0.5.3        compiler_3.6.1     modelr_0.1.5       xfun_0.12          rstan_2.19.2      
    ## [31] pkgconfig_2.0.3    pkgbuild_1.0.6     htmltools_0.4.0    tidyselect_0.2.5   gridExtra_2.3      matrixStats_0.55.0
    ## [37] fansi_0.4.1        crayon_1.3.4       dbplyr_1.4.2       withr_2.1.2        grid_3.6.1         nlme_3.1-143      
    ## [43] jsonlite_1.6       gtable_0.3.0       lifecycle_0.1.0    DBI_1.1.0          magrittr_1.5       StanHeaders_2.19.0
    ## [49] scales_1.1.0       cli_2.0.1          stringi_1.4.5      farver_2.0.1       fs_1.3.1           xml2_1.2.2        
    ## [55] generics_0.0.2     vctrs_0.2.1        tools_3.6.1        glue_1.3.1         hms_0.5.3          yaml_2.2.0        
    ## [61] processx_3.4.1     parallel_3.6.1     inline_0.3.15      colorspace_1.4-1   rvest_0.3.5        knitr_1.26        
    ## [67] haven_2.2.0
