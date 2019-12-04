library(tidyverse)
library(lubridate)

data_path <- "../tidytuesday/data/2019/2019-12-03/"

tickets <- read.csv(paste(data_path, "tickets.csv", sep=""))

count_by_weekday <-
    tickets %>%
    select(issue_datetime) %>%
    mutate(weekday = wday(issue_datetime, label=TRUE)) %>%
    count(weekday) %>%
    group_by(weekday) %>%
    summarise(n = mean(n))

count_by_weekday %>%
    ggplot() +
    aes(x = weekday, y = n, color = weekday, fill = weekday) +
    geom_bar(stat = "identity") + 
    labs(x = "Days of week", y = "Number of tickets") + 
    ggtitle("Number of Tickets by Weekday") +
    theme(legend.position = "none")

ggsave("plot_2019-12-03.png", width = 29, height = 21, units = "cm", dpi = "retina")
