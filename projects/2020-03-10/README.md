College tuition, diversity, and pay
================
Francis Lin | \#TidyTuesday |
2020-03-10

# Introduction

How beneficial is diversity in a college setting? In this analysis, I
drew from several datasets to see if the diversity of a school is
correlated to career success, defined as mid-career pay. I was also
curious to see how my alma mater, UCLA, compared to other schools in
both of these aspects.

# R Program

## Set up

``` r
# source utilities
source("../utilities.R")

# packages
library(tidyverse)
library(readr)
library(ggrepel)

# set data path
data_path <- set_data_path()

# create plot folder if doesn't exist
if (!dir.exists("./plot")) {dir.create("./plot")}
```

## Load Data

``` r
tuition_cost <- read_csv(paste0(data_path, "tuition_cost.csv"))
tuition_income <- read_csv(paste0(data_path, "tuition_income.csv"))
salary_potential <- read_csv(paste0(data_path, "salary_potential.csv"))
historical_tuition <- read_csv(paste0(data_path, "historical_tuition.csv"))
diversity_school <- read_csv(paste0(data_path, "diversity_school.csv"))
```

## Manipulate data

First, I needed a way to quantify diversity. One way was to use the
[diversity
index](https://diversity.missouristate.edu/DiversityIndex.htm), defined
as the probability that two students chosen at random have different
racial or ethnic backgrounds. Using a simple probability calculation,
the diversity index can be calculated using just the `diversity_school`
dataset.

Next, I wanted to find the mid-career pay and the type of school for all
the schools. These variables can be found in the `salary_potential` and
`tuition_cost` datasets, respectively.

Finally, I noticed that the schools weren’t named uniformly across all
the datasets. While I didn’t perform a full fuzzy match, a decent number
of schools were uniform, and I made some manual modifications to ensure
that schools such as UC’s and some Ivy League’s were included.

``` r
# function to calculate diversity index
calc_diversity_index <- function(d) {
    return(1-(
        (d$White/d$total_enrollment)^2 + 
        (d$Black/d$total_enrollment)^2 + 
        (d$`American Indian / Alaska Native`/d$total_enrollment)^2 + 
        ((d$Asian+d$`Native Hawaiian / Pacific Islander`)/d$total_enrollment)^2 + 
        (d$Hispanic/d$total_enrollment)^2 + 
        (d$`Two Or More Races`/d$total_enrollment)^2 + 
        (d$`Non-Resident Foreign`/d$total_enrollment)^2 + 
        (d$Unknown/d$total_enrollment)^2
    ))
}

# rename schools to match when joining across datasets
salary_potential <- salary_potential %>%
    mutate(name=gsub("University of California-", "University of California at ", name),
           name=gsub("University-", "University at ", name))
tuition_cost<- tuition_cost %>%
    mutate(name=gsub("University of California: ", "University of California at ", name),
           name=gsub("University: ", "University at ", name))
tuition_cost$name[tuition_cost$name == "Harvard College"] <- "Harvard University"

# create dataset with diversity index and mid-career pay for schools
school_diversity_and_pay <- diversity_school %>%
    
    # drop na
    drop_na(name, state) %>%
    
    # pivot wider to prepare calculating diversity index
    pivot_wider(names_from=category, values_from=enrollment) %>%
    
    # calculate diversity index
    mutate(di = calc_diversity_index(.)) %>%

    # inner join on salary potential
    inner_join(salary_potential, by = c("name" = "name", "state" = "state_name")) %>%
    
    # inner join on tuition_cost
    inner_join(tuition_cost, by = c("name", "state")) %>%
    
    # select relevant columns
    select(name, state, total_enrollment, di, mid_career_pay, type) %>%
    
    # boolean if school in California
    mutate(isCA = ifelse(state=="California", "In California", "Not in California"))

# rename school names to make them shorter/more aesthetic
school_diversity_and_pay$name[school_diversity_and_pay$name == "University of California at Los Angeles"] <- "UCLA"
school_diversity_and_pay$name[school_diversity_and_pay$name == "University of California at San Diego"] <- "UCSD"
school_diversity_and_pay$name[school_diversity_and_pay$name == "University of California at Berkeley"] <- "Cal"
school_diversity_and_pay$name[school_diversity_and_pay$name == "University of Southern California"] <- "USC"
school_diversity_and_pay$name[school_diversity_and_pay$name == "California Polytechnic State University at San Luis Obispo"] <- "CalPoly SLO"
school_diversity_and_pay$name[school_diversity_and_pay$name == "California Institute of Technology"] <- "CalTech"
school_diversity_and_pay$name[school_diversity_and_pay$name == "Harvey Mudd College"] <- "Harvey Mudd"
school_diversity_and_pay$name[school_diversity_and_pay$name == "Massachusetts Institute of Technology"] <- "MIT"
school_diversity_and_pay$name[school_diversity_and_pay$name == "Stanford University"] <- "Stanford"
school_diversity_and_pay$name[school_diversity_and_pay$name == "Yale University"] <- "Yale"
school_diversity_and_pay$name[school_diversity_and_pay$name == "Harvard University"] <- "Harvard"
```

## Plot Data

``` r
p1 <- ggplot(school_diversity_and_pay, aes(x=di, y=mid_career_pay)) +
    
    # point out a few well-known schools
    geom_text_repel(
        data = . %>% mutate(label = ifelse(name %in% c("UCLA", "UCSD", "Cal", "USC", "CalPoly SLO", "CalTech", "Harvey Mudd","MIT", "Stanford", "Yale", "Harvard", "Colorado School of Mines"), name, "")),
        aes(x=di, y=mid_career_pay, label = label, color=type), 
        box.padding = 0.6,
        show.legend = TRUE) +
    
    # create point for each school 
    geom_point(aes(color=type)) + 
    
    # draw a general line of fit
    geom_smooth(method = 'loess', se=FALSE, linetype="dashed") +
    
    # other aesthetics
    coord_cartesian(xlim = c(0, 1)) +
    labs(x="Diversity Index", y="Estimated Mid-Career Pay (USD)", title="Influence of School Diversity on Estimated Mid-Career Pay in Higher Education", subtitle="Mid-career pay increases as diversity index of school increases", color="School Type")
p1
```

![](README_files/figure-gfm/plot%20data%201-1.png)<!-- -->

From the graph above, it is clear that as the school becomes more
diverse, the mid-career pay also increases, although the relationship is
not strictly linear. This generally makes sense, since the diversity of
a school can expose a student to several different and new perspectives,
thus preparing the student for the “real world” and setting him or her
up for success.

Also notable is the fact that out of the top 20 schools with the highest
mid-career pay, only 2 of them are public: Colorado School of Mines and
UC Berkeley. Since private schools tend to be more expensive, it might
be useful to analyze in another exercise if paying more for school
results in higher pay, and if it is more or less correlated with
mid-career pay than diversity index.

A lot of schools in the upper right hand corner were California schools,
so I became curious to see where California schools stand in comparison
with the rest of the country.

``` r
p2 <- ggplot(school_diversity_and_pay, aes(x=di, y=mid_career_pay)) +

    # create point for each school 
    geom_point(aes(color=isCA)) + 
    
    # other aesthetics
    coord_cartesian(xlim = c(0, 1)) +
    labs(x="Diversity Index", y="Estimated Mid-Career Pay (USD)", title="Higher Education Diversity and Estimated Mid-Career Pay", subtitle="Californian students generally experience more diversity and higher mid-career pay.", color="")
p2
```

![](README_files/figure-gfm/plot%20data%202-1.png)<!-- -->

I’m glad that my state of California is doing so well\!

## Save Image

``` r
ggsave("plot/plot1_2020-03-10.png", p1, width=7, height=5, units="in")
ggsave("plot/plot2_2020-03-10.png", p2, width=7, height=5, units="in")
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
    ##  [1] ggrepel_0.8.1   forcats_0.4.0   stringr_1.4.0   dplyr_0.8.4    
    ##  [5] purrr_0.3.3     readr_1.3.1     tidyr_1.0.2     tibble_2.1.3   
    ##  [9] ggplot2_3.2.1   tidyverse_1.3.0
    ## 
    ## loaded via a namespace (and not attached):
    ##  [1] Rcpp_1.0.3         lubridate_1.7.4    lattice_0.20-38    prettyunits_1.1.1 
    ##  [5] ps_1.3.2           assertthat_0.2.1   packrat_0.5.0      digest_0.6.25     
    ##  [9] R6_2.4.1           cellranger_1.1.0   backports_1.1.5    reprex_0.3.0      
    ## [13] stats4_3.6.1       evaluate_0.14      httr_1.4.1         pillar_1.4.3      
    ## [17] rlang_0.4.5        lazyeval_0.2.2     readxl_1.3.1       rstudioapi_0.11   
    ## [21] callr_3.4.2        rmarkdown_2.1      labeling_0.3       loo_2.2.0         
    ## [25] munsell_0.5.0      broom_0.5.4        compiler_3.6.1     modelr_0.1.6      
    ## [29] xfun_0.12          rstan_2.19.3       pkgconfig_2.0.3    pkgbuild_1.0.6    
    ## [33] htmltools_0.4.0    tidyselect_1.0.0   gridExtra_2.3      matrixStats_0.55.0
    ## [37] fansi_0.4.1        crayon_1.3.4       dbplyr_1.4.2       withr_2.1.2       
    ## [41] grid_3.6.1         nlme_3.1-144       jsonlite_1.6.1     gtable_0.3.0      
    ## [45] lifecycle_0.1.0    DBI_1.1.0          magrittr_1.5       StanHeaders_2.19.0
    ## [49] scales_1.1.0       cli_2.0.2          stringi_1.4.6      farver_2.0.3      
    ## [53] fs_1.3.1           xml2_1.2.2         ellipsis_0.3.0     generics_0.0.2    
    ## [57] vctrs_0.2.3        tools_3.6.1        glue_1.3.1         hms_0.5.3         
    ## [61] yaml_2.2.1         processx_3.4.2     parallel_3.6.1     inline_0.3.15     
    ## [65] colorspace_1.4-1   rvest_0.3.5        knitr_1.28         haven_2.2.0
