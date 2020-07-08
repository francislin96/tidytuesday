Coffee Ratings
================
Francis Lin | \#TidyTuesday |
2020-07-07

# Introduction

Did you know that [nearly a third of adult
Americans](https://myfriendscoffee.com/usa-coffee-statistics/) drink
coffee on a daily basis? That’s just an insane statistic for me, since I
don’t drink coffee regularly. This week’s data comes from the [Coffee
Quality Database](https://github.com/jldbc/coffee-quality-database).
Using this dataset, I was wondering which countries would have the best
coffee beans. This TidyTuesday was my first attempt at creating a [radar
chart](https://en.wikipedia.org/wiki/Radar_chart) as well as making
different charts of different sizes fit using `grid.arrange` from the
`gridExtra` package.

# R Program

## Set up

``` r
# source utilities
source("../utilities.R")

# packages
library(tidyverse)
library(gridExtra)

# set data path
data_path <- set_data_path()

# create plot folder if doesn't exist
if (!dir.exists("./plot")) {dir.create("./plot")}
```

## Load Data

``` r
coffee_ratings <- read_csv(paste0(data_path, "coffee_ratings.csv"))
```

## Manipulate data

``` r
# make attributes variable names more reader friendly
simpleCap <- function(x) {
  s <- strsplit(x, " |_")[[1]]
  paste(toupper(substring(s, 1,1)), substring(s, 2),
      sep="", collapse=" ")
}

ratings <- coffee_ratings %>%
  # choose Arabica coffee only
  filter(species == "Arabica") %>%
  
  # find median value for each country
  group_by(country_of_origin) %>%
  summarize(aroma = median(aroma),
            flavor = median(flavor),
            aftertaste = median(aftertaste),
            acidity = median(acidity),
            body = median(body),
            balance = median(balance),
            uniformity = median(uniformity),
            clean_cup = median(clean_cup),
            sweetness = median(sweetness),
            cupper_points = median(cupper_points),
            count = n()) %>%
  
  # keep only countries with high number of coffee types
  filter(count > 10) %>%
  ungroup() %>%
  mutate(country_of_origin=replace(country_of_origin, country_of_origin=="United States (Hawaii)", "U.S. Hawaii"))
  
# additional proccessing for making plot
plot.ratings <- ratings %>%
  
  # pivot longer
  pivot_longer(aroma:cupper_points, names_to="attribute", values_to="score") %>%
  
  # prevent plot from ordering alphabetically
  mutate(attribute = factor(attribute, levels=unique(attribute))) %>%
  
  # duplicate rows at the end to close coord_radar
  #arrange(attribute) %>%
  rbind(subset(., attribute == .$attribute[1]))

# add label for first 10 rows
plot.ratings$label=""
plot.ratings[1:10, ]$label = sapply(as.character(plot.ratings[1:10, ]$attribute), simpleCap)
```

## Plot Data

``` r
# create radar coord
coord_radar <- function(theta='x', start=0, direction=1) {
  # input parameter sanity check
  match.arg(theta, c('x','y'))

  ggproto(
    NULL, CoordPolar, 
    theta=theta, r=ifelse(theta=='x','y','x'),
    start=start, direction=sign(direction),
    is_linear=function() TRUE)
}

# make bar chart of top countries for certain attribute
make_plot <- function(df, attribute) {
  p_flavor <- ggplot(df, aes(x=reorder(country_of_origin, .data[[attribute]]), y=.data[[attribute]])) +
  geom_bar(stat="identity") +
  geom_text(aes(label = .data[[attribute]]), position = position_dodge(width = 1), vjust = 0.5, hjust=-0.1, size = 5) + 
  ylim(0,10) +
  coord_flip() + 
  labs(x="", y="Score", title=paste("Top", simpleCap(attribute), "Scores")) + 
  theme(axis.text.x = element_text(size=12), axis.text.y = element_text(size=12), plot.title = element_text(hjust = 0.5, size=18))
p_flavor
}

# radar plot
p_countries <- ggplot(plot.ratings, aes(x=attribute, y=score, group=country_of_origin)) + 
  geom_path(size=0.3) +
  geom_text(aes(y=13, label=label), size=6) +
  expand_limits(y=c(0,10)) +
  coord_radar() + 
  labs(x="", y="", title="Coffee Profile of Different Countries", subtitle="Each ring represents one country. Coffee profiles are quite similar across countries.") +
  theme(axis.text.x=element_blank(), axis.text.y=element_blank(), axis.ticks.y=element_blank(), plot.title = element_text(hjust = 0.5, size=24), plot.subtitle=element_text(size=16)) +
  scale_x_discrete(labels=sapply(levels(plot.ratings$attribute), simpleCap))

# bar plot for each attribute
p_aroma <- make_plot(ratings %>% top_n(5, aroma), "aroma")
p_flavor <- make_plot(ratings %>% top_n(5, flavor), "flavor")
p_aftertaste <- make_plot(ratings %>% top_n(5, aftertaste), "aftertaste")
p_acidity <- make_plot(ratings %>% top_n(5, acidity), "acidity")
p_body <- make_plot(ratings %>% top_n(5, body), "body")
p_balance <- make_plot(ratings %>% top_n(5, balance), "balance")
p_cupper <- make_plot(ratings %>% top_n(5, cupper_points), "cupper_points")

p <- grid.arrange(p_countries, 
             p_aroma, 
             p_flavor, 
             p_aftertaste, 
             p_acidity, 
             p_body, 
             p_balance, 
             p_cupper,
             ggplot()+geom_blank(aes(1,1))+cowplot::theme_nothing(), nrow = 2, 
             layout_matrix = rbind(c(1,1,1,1,2,2,3,3,4,4,5,5), c(1,1,1,1,6,6,7,7,8,8,9,9)))
```

![](README_files/figure-gfm/plot%20data-1.png)<!-- -->

``` r
p
```

    ## TableGrob (2 x 12) "arrange": 9 grobs
    ##   z         cells    name           grob
    ## 1 1 ( 1- 2, 1- 4) arrange gtable[layout]
    ## 2 2 ( 1- 1, 5- 6) arrange gtable[layout]
    ## 3 3 ( 1- 1, 7- 8) arrange gtable[layout]
    ## 4 4 ( 1- 1, 9-10) arrange gtable[layout]
    ## 5 5 ( 1- 1,11-12) arrange gtable[layout]
    ## 6 6 ( 2- 2, 5- 6) arrange gtable[layout]
    ## 7 7 ( 2- 2, 7- 8) arrange gtable[layout]
    ## 8 8 ( 2- 2, 9-10) arrange gtable[layout]
    ## 9 9 ( 2- 2,11-12) arrange gtable[layout]

Ethiopia, Kenya, and Uganda often receive the best scores for the
different attributes of coffee.

## Save Image

``` r
ggsave("plot/plot_2020-07-07.png", p, width=7, height=5, units="in")
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
    ## [1] stats     graphics  grDevices utils     datasets  methods   base     
    ## 
    ## other attached packages:
    ##  [1] gridExtra_2.3   forcats_0.5.0   stringr_1.4.0   dplyr_1.0.0     purrr_0.3.4     readr_1.3.1    
    ##  [7] tidyr_1.1.0     tibble_3.0.1    ggplot2_3.3.1   tidyverse_1.3.0
    ## 
    ## loaded via a namespace (and not attached):
    ##  [1] Rcpp_1.0.4.6       lubridate_1.7.9    lattice_0.20-41    prettyunits_1.1.1  ps_1.3.3          
    ##  [6] assertthat_0.2.1   digest_0.6.25      packrat_0.5.0      R6_2.4.1           cellranger_1.1.0  
    ## [11] backports_1.1.7    reprex_0.3.0       stats4_3.6.3       evaluate_0.14      httr_1.4.1        
    ## [16] pillar_1.4.4       rlang_0.4.6        readxl_1.3.1       rstudioapi_0.11    callr_3.4.3       
    ## [21] blob_1.2.1         rmarkdown_2.2      labeling_0.3       loo_2.2.0          munsell_0.5.0     
    ## [26] broom_0.5.6        compiler_3.6.3     modelr_0.1.8       xfun_0.14          rstan_2.19.3      
    ## [31] pkgconfig_2.0.3    pkgbuild_1.0.8     htmltools_0.4.0    tidyselect_1.1.0   matrixStats_0.56.0
    ## [36] fansi_0.4.1        crayon_1.3.4       dbplyr_1.4.4       withr_2.2.0        grid_3.6.3        
    ## [41] nlme_3.1-148       jsonlite_1.6.1     gtable_0.3.0       lifecycle_0.2.0    DBI_1.1.0         
    ## [46] magrittr_1.5       StanHeaders_2.19.0 scales_1.1.1       cli_2.0.2          stringi_1.4.6     
    ## [51] farver_2.0.3       fs_1.4.1           xml2_1.3.2         ellipsis_0.3.1     generics_0.0.2    
    ## [56] vctrs_0.3.1        cowplot_1.0.0      tools_3.6.3        glue_1.4.1         hms_0.5.3         
    ## [61] processx_3.4.2     parallel_3.6.3     yaml_2.2.1         inline_0.3.15      colorspace_1.4-1  
    ## [66] rvest_0.3.5        knitr_1.28         haven_2.3.1
