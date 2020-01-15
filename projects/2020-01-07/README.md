Australian Fires
================
Francis Lin | \#TidyTuesday |
2020-01-07

# Introduction

As of the time I am writing this analysis, Australians are being
devastated by one of the [worst wildfires in Australian
history](https://en.wikipedia.org/wiki/2019%E2%80%9320_Australian_bushfire_season).
More than 20 people have lost their lives, and by [one
estimate](https://sydney.edu.au/news-opinion/news/2020/01/03/a-statement-about-the-480-million-animals-killed-in-nsw-bushfire.html),
roughly half a billion animals have already perished as millions and
millions of acres burn. Here are some of the heartbreaking photos taken
of the
tragedy:

![](https://static.boredpanda.com/blog/wp-content/uploads/2020/01/5e12de5196b2b_0z50n8fbir841__700.jpg)

![](https://media3.s-nbcnews.com/j/newscms/2020_02/3172851/200106-australia-wildfire-se-1115a_b1ff1a8528b60b2404e60607fc74a0dd.fit-2000w.jpg)

![](https://cdn.theatlantic.com/assets/media/img/photo/2020/01/australia-fires-tk/a23_RTS2XBRD/main_900.jpg)

![](https://cdn.theatlantic.com/assets/media/img/photo/2020/01/australia-fires-tk/a01_RTS2X3HZ/main_900.jpg)

Please consider donating to the [Australian Red
Cross](https://www.redcross.org.au/news-and-media/news/your-donations-in-action)
to help support the firefighters, volunteers, and climate refugees.

This week’s dataset, from the [Australian Bureau of Meterology
(BoM)](http://www.bom.gov.au/?ref=logo), will focus on this catastrophe.
The data includes the maximum and minimum temperatures recorded at
various locations in Australia from 1910 to 2019. Using inspiration from
this [NYT
article](https://www.nytimes.com/interactive/2020/01/02/climate/australia-fires-map.html),
I will aim to visualize why this season’s fires have been so bad.

# R Program

## Set up

``` r
# source utilities
source("../utilities.R")

# packages
library(tidyverse)
library(readr)

# set data path
data_path <- set_data_path()

# create plot folder if doesn't exist
if (!dir.exists("./plot")) {dir.create("./plot")}
```

## Load Data

``` r
# read in data
temperature <- read_csv(paste0(data_path, "temperature.csv"), col_types=cols(date = col_date(format="%Y-%m-%d")))
```

## Manipulate Data

First, I found the average temperature recorded on each day across the
different locations in Australia. I then took those measurements and
grouped by year to find the average annual temperature.

``` r
# find average temperature for each day
max_temp_date <- temperature %>%
    filter(temp_type == "max") %>%
    group_by(date) %>% 
    summarise(daily_temp = mean(temperature, na.rm=TRUE))

# find average temperature for each year
max_temp_annual <- max_temp_date %>%
    mutate(year=format(date, "%Y")) %>%
    group_by(year) %>%
    summarise(annual_temp = mean(daily_temp, na.rm=TRUE))

# find difference of each year from average
max_temp_annual$annual_temp_diff <- max_temp_annual$annual_temp - mean(max_temp_annual[which(max_temp_annual$year %in% c(1960, 1961)),]$annual_temp)
```

## Plot

Using annotations, I was able to highlight and draw attention to the
year 2019.

``` r
# plot
p <- ggplot(data=max_temp_annual, aes(x=year, y=annual_temp_diff, fill=factor(ifelse(year==2019,"Highlighted","Normal")))) +
    
    # bar graph
    geom_bar(stat="identity", width=0.8) +
    
    # axes and colors
    scale_fill_manual(name="date", values=c("red","grey"))+
    theme(text = element_text(size=12), panel.background = element_blank(), panel.grid.major = element_blank(), axis.title.y=element_blank(), axis.text.x=element_blank(), axis.ticks.x=element_blank(), axis.ticks.y=element_blank(), legend.position="none") +
    xlab("Year") + 
    scale_y_continuous(breaks=seq(floor(min(max_temp_annual$annual_temp_diff)), ceiling(max(max_temp_annual$annual_temp_diff)), by=1), labels=function(x) {ifelse(x>=0, paste0("+", x, "°C"), paste0(x, "°C"))}) + 
    ggtitle("Australia's Average Max Temperature by Year") +
    
    # annotation arrow
    annotate("segment", x=100, xend=108, y=4.4, yend=4.4, colour="red", size=0.5, alpha=1, arrow=arrow(length=unit(0.1, "inches"))) + 
    
    # annotation text
    annotate("text", x=5, y=3, hjust=0, label="Annual temperature above or below\nthe 1960-1961 average", color="dimgrey") + 
    annotate("text", x=96, y=4.4, label="2019", color="dimgrey") + 
    annotate("text", x=8, y=-1.8, label="1917", color="dimgrey") + 
    
    # horizontal lines
    geom_hline(yintercept=c(-1.5, -1, -0.5, 0.5, 1, 1.5, 2, 2.5, 3, 3.5, 4), color="white", size=0.5) + 
    geom_hline(yintercept=0, color="black", size=0.5)

p
```

![](README_files/figure-gfm/plot-1.png)<!-- -->

It’s clear that 2019 has been the hottest year on record. No wonder the
fires have been so bad.

One thing that I did notice is that the axes on graphic in the NYT
article is not as drastic as mine. If anybody knows how our
methodologies differed, please let me know\!

## Save Image

``` r
# save image
ggsave("plot/plot_2020-01-07.png", width=29, height=21, units="cm", dpi="retina")
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
    ##  [1] LC_CTYPE=en_US.UTF-8       LC_NUMERIC=C               LC_TIME=en_US.UTF-8       
    ##  [4] LC_COLLATE=en_US.UTF-8     LC_MONETARY=en_US.UTF-8    LC_MESSAGES=en_US.UTF-8   
    ##  [7] LC_PAPER=en_US.UTF-8       LC_NAME=C                  LC_ADDRESS=C              
    ## [10] LC_TELEPHONE=C             LC_MEASUREMENT=en_US.UTF-8 LC_IDENTIFICATION=C       
    ## 
    ## attached base packages:
    ## [1] stats     graphics  grDevices utils     datasets  methods   base     
    ## 
    ## other attached packages:
    ## [1] forcats_0.4.0   stringr_1.4.0   dplyr_0.8.3     purrr_0.3.3     readr_1.3.1     tidyr_1.0.0    
    ## [7] tibble_2.1.3    ggplot2_3.2.1   tidyverse_1.3.0
    ## 
    ## loaded via a namespace (and not attached):
    ##  [1] Rcpp_1.0.3         lubridate_1.7.4    lattice_0.20-38    prettyunits_1.0.2  ps_1.3.0          
    ##  [6] digest_0.6.23      assertthat_0.2.1   zeallot_0.1.0      packrat_0.5.0      R6_2.4.1          
    ## [11] cellranger_1.1.0   backports_1.1.5    reprex_0.3.0       stats4_3.6.1       evaluate_0.14     
    ## [16] httr_1.4.1         pillar_1.4.3       rlang_0.4.2        lazyeval_0.2.2     readxl_1.3.1      
    ## [21] rstudioapi_0.10    callr_3.4.0        rmarkdown_2.0      loo_2.2.0          munsell_0.5.0     
    ## [26] broom_0.5.3        compiler_3.6.1     modelr_0.1.5       xfun_0.11          rstan_2.19.2      
    ## [31] pkgconfig_2.0.3    pkgbuild_1.0.6     htmltools_0.4.0    tidyselect_0.2.5   gridExtra_2.3     
    ## [36] matrixStats_0.55.0 fansi_0.4.0        crayon_1.3.4       dbplyr_1.4.2       withr_2.1.2       
    ## [41] grid_3.6.1         nlme_3.1-143       jsonlite_1.6       gtable_0.3.0       lifecycle_0.1.0   
    ## [46] DBI_1.1.0          magrittr_1.5       StanHeaders_2.19.0 scales_1.1.0       cli_2.0.0         
    ## [51] stringi_1.4.3      farver_2.0.1       fs_1.3.1           xml2_1.2.2         generics_0.0.2    
    ## [56] vctrs_0.2.1        tools_3.6.1        glue_1.3.1         hms_0.5.2          yaml_2.2.0        
    ## [61] processx_3.4.1     parallel_3.6.1     inline_0.3.15      colorspace_1.4-1   rvest_0.3.5       
    ## [66] knitr_1.26         haven_2.2.0
