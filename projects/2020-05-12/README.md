Volcano Eruptions
================
Francis Lin | \#TidyTuesday |
2020-05-12

# Introduction

Today, I played around with the `rnaturalearth` package by plotting out
the locations of volcanos\! The data was supplied by [The Smithsonian
Institute](https://volcano.si.edu/).

# R Program

## Set up

``` r
# source utilities
source("../utilities.R")

# packages
library(tidyverse)
library(rnaturalearth)
library(lubridate)

# set data path
data_path <- set_data_path()

# create plot folder if doesn't exist
if (!dir.exists("./plot")) {dir.create("./plot")}
```

## Load Data

``` r
volcano <- read_csv(paste0(data_path, "volcano.csv"))
```

## Manipulate data

Here I calculated the number of years elapsed since the last eruption of
each volcano.

``` r
volcanos <- volcano %>%
    select(last_eruption_year, longitude, latitude) %>%
    mutate(years_since_eruption = year(Sys.Date())-as.numeric(last_eruption_year))
```

    ## Warning: NAs introduced by coercion

## Plot Data

``` r
# get country polygons
world <- ne_countries(scale = "medium", returnclass = "sf")

# plot
p <- ggplot(volcanos) +
    
    # world polygons
    geom_sf(data=world, fill = "black", colour = "grey10") +
    
    # volcano points
    geom_point(aes(x=longitude, y=latitude, color=years_since_eruption), size=1, alpha=0.9) + 
    
    # color volcano points
    scale_colour_gradient(low="red", high="yellow", na.value="white") +
    
    # aesthetics
    theme(
        panel.background = element_rect(fill = "darkslategray3"),
        plot.background = element_rect(fill = "darkslategray3"),
        legend.background = element_rect(fill = "darkslategray3"),
        panel.grid.major = element_blank(),
        plot.subtitle=element_text(size=8)
    ) +
    
    # labels
    labs(title="Years from Last Volcano Eruption", color="Years", subtitle="Points in white are unknown", x="", y="")
    
p
```

![](README_files/figure-gfm/plot%20data-1.png)<!-- -->

This was my first time using the `rnaturalearth` package. Although I
thought it would be much more intimidating, the task ended up being
easier than I thought. That’s an extra tool in my toolkit now: graphing
geographical locations on the world map.

## Save Image

``` r
ggsave("plot/plot_2020-05-12.png", p, width=8, height=4, units="in")
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
    ##  [1] lubridate_1.7.4     rnaturalearth_0.1.0 forcats_0.5.0       stringr_1.4.0      
    ##  [5] dplyr_0.8.5         purrr_0.3.3         readr_1.3.1         tidyr_1.0.2        
    ##  [9] tibble_3.0.0        ggplot2_3.3.0       tidyverse_1.3.0    
    ## 
    ## loaded via a namespace (and not attached):
    ##  [1] Rcpp_1.0.4.6            lattice_0.20-38         class_7.3-15           
    ##  [4] assertthat_0.2.1        packrat_0.5.0           digest_0.6.25          
    ##  [7] R6_2.4.1                cellranger_1.1.0        backports_1.1.6        
    ## [10] reprex_0.3.0            evaluate_0.14           rnaturalearthdata_0.1.0
    ## [13] e1071_1.7-3             httr_1.4.1              pillar_1.4.3           
    ## [16] rlang_0.4.5             readxl_1.3.1            rstudioapi_0.11        
    ## [19] rmarkdown_2.1           labeling_0.3            munsell_0.5.0          
    ## [22] broom_0.5.5             compiler_3.6.1          modelr_0.1.6           
    ## [25] xfun_0.12               pkgconfig_2.0.3         htmltools_0.4.0        
    ## [28] rgeos_0.5-2             tidyselect_1.0.0        fansi_0.4.1            
    ## [31] crayon_1.3.4            dbplyr_1.4.2            withr_2.1.2            
    ## [34] sf_0.9-0                grid_3.6.1              nlme_3.1-145           
    ## [37] jsonlite_1.6.1          gtable_0.3.0            lifecycle_0.2.0        
    ## [40] DBI_1.1.0               magrittr_1.5            units_0.6-6            
    ## [43] scales_1.1.0            KernSmooth_2.23-15      cli_2.0.2              
    ## [46] stringi_1.4.6           farver_2.0.3            fs_1.4.0               
    ## [49] sp_1.4-1                xml2_1.3.1              ellipsis_0.3.0         
    ## [52] generics_0.0.2          vctrs_0.2.4             tools_3.6.1            
    ## [55] glue_1.4.0              hms_0.5.3               yaml_2.2.1             
    ## [58] parallel_3.6.1          colorspace_1.4-1        classInt_0.4-2         
    ## [61] rvest_0.3.5             knitr_1.28              haven_2.2.0
