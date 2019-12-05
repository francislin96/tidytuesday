set_data_path <- function() {
    tidytuesday_dir <- "../../tidytuesday/data/"
    date_string <- stringr::str_extract(getwd(), "\\d{4}-\\d{2}-\\d{2}")
    year_string <- stringr::str_extract(date_string, "\\d{4}")
    return(paste("../../tidytuesday/data/", year_string, "/", date_string, "/", sep=""))
}
