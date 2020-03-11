set_data_path <- function() {
    tidytuesday_dir <- "../../tidytuesday/data/"
    date_string <- stringr::str_extract(getwd(), "\\d{4}-\\d{2}-\\d{2}")
    year_string <- stringr::str_extract(date_string, "\\d{4}")
    return(paste("../../tidytuesday/data/", year_string, "/", date_string, "/", sep=""))
}

convert_to_readme <- function (filename="analysis.Rmd") {
    rmarkdown::render(input=filename, output_format="github_document", output_file="README.md")
}

# google maps api key stored at google_maps_key.txt
read_key <- function(key_name) {
    switch(key_name,
           "google" = return(trimws(readr::read_file("../google_maps_key.txt"))))
}

# create analysis.Rmd template
new_analysis <- function(date) {
    template <- readLines("../analysis_template.Rmd")
    template <- gsub(pattern = "@DATE", replace = date, x = template)
    writeLines(template, con="analysis.Rmd")
}
