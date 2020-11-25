## Required Libraries
library(tidyverse)
library(ggplot2)

### First Function: Scatter Plot between Wage and Age
### with a regression line.
wage_age <- function(line = FALSE, poly = 1, formula_wage_age = y ~ x){
  plot_title <- "Scatter Plot between Wage and Age"
  
  if(poly != 1){
    plot_title <- paste0("Polynomial degree ", poly)
  }
  
  plot_wage_age <- ggplot(data, aes(x = age, y = wage)) + 
    geom_point(color = "darkblue") +
    theme_bw() +
    labs(title = plot_title, x = "Age", y = "Wage")
  
  if(line == TRUE){
    plot_wage_age + 
      geom_smooth(method = "lm", formula = formula_wage_age, color = "yellow")
  } else {
    plot_wage_age
  }
}

## Second Function: Function for performing k-fold cross validation.
plot_kfold <- function(df = 1:10, bs = TRUE){
  store_MSE <- c()
  title_plot <- "5-fold cross-validate MSE"
  
  if(bs == TRUE){
    title_plot <- paste0(title_plot, ": Basis Spline")
    df <- df + 4
  } else  {
    title_plot <- paste0(title_plot, ": Natural Spline")
    df <- df + 2
  }
  
  for(i in df){
    
    MSE <- c()
    
    for(j in 1:5){
      
      ## Split the data
      train_data <- data %>% filter(CV != j)
      validate_data <- data %>% filter(CV == j)
      
      ## Train the model
      if(bs == TRUE){
        model <- lm(wage ~ bs(age, df = i) + edu + year, 
                    data = train_data)
      } else {
        model <- lm(wage ~ ns(age, df = i) + edu + year, 
                    data = train_data)
      }
      
      ## Store the MSE for each validation set
      MSE <- c(MSE, 
               mean((predict(model, validate_data) - validate_data$wage)^2))
      
    }
    
    ## Store the MSE for each knots
    store_MSE <- c(store_MSE, mean(MSE))
  }

  ## Create a plot
  dummy_result <- data.frame(df = as.factor(df), store_MSE)
  p <- ggplot(dummy_result, aes(x = df, y = store_MSE, group = 1)) +
    geom_line() +
    geom_point() +
    labs(title = title_plot, x = "Degree of Freedom", y = "MSE") +
    geom_text(aes(label = round(store_MSE,2)), vjust = -1) +
    ylim(min(store_MSE) - 3, max(store_MSE) + 3) +
    theme_bw()
  print(p)
}