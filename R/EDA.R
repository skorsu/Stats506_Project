## Required Libraries
library(tidyverse) ## This library is for data manipulation.
library(ggplot2) ## This library is for data visualization.
library(gridExtra) ## This library is also for data visualization.

## Plot for EDA
### Numerical Variables
nvar_plot <- function(vari, label){
  title_vari <- paste0("Histogram: ", label)
  ggplot(data, aes(x = {{ vari }})) + 
    geom_histogram(color = "black", fill = "darkblue") +
    theme_bw() +
    labs(title = title_vari, x = label, y = "Count")
}

### Categorical Variables
cvar_plot <- function(vari, label){
  data %>% group_by({{ vari }}) %>% 
    summarise(n = n()) %>% 
    mutate(Percent = 100 * n / sum(n)) %>%
    ggplot(aes(x = {{ vari }}, y = Percent)) +
    geom_bar(stat = "identity", size = 0.5, fill = "darkblue") +
    geom_text(aes(label = paste0(round(Percent,2), " %")), vjust = 1.5, 
              color = "white", position = position_dodge(0.9), size = 2) +
    labs(title = label, x = label, y = "Percent") +
    theme_bw()
}
