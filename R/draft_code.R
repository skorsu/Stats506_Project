## Library
library(ggplot2)
library(gridExtra)
library(tidyverse)
library(splines)

## Import the data
data <- read.csv("/Users/kevin/506FA20/Stats506_Project/Dataset/data.csv")

## We decided to use only four variables.
## - wage (as a response variable)
## - age, education, year (as predictors)
## Also, decide to treat the year as a numerical variable.

data <- data %>% dplyr::select(wage, age, education, year)

## Cheack for missing value for each variable
for(i in 1:dim(data)[2]){
  if(sum(is.na(data[,i])) == 0){
    print(paste0(colnames(data)[i], ": No Missing Value"))
  } else {
    print(paste0(colnames(data)[i], ": Contains Missing Value"))
  }
}

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
    geom_text(aes(label = paste0(round(Percent,2), " %")), vjust = -0.5, 
              color = "black", position = position_dodge(0.9), size = 3.5) +
    labs(title = label, x = label, y = "Percent") +
    theme_bw()
}

## Response Variable
nvar_plot(wage, "Wage")
ggsave("/Users/kevin/506FA20/Stats506_Project/R/wage.png", 
       nvar_plot(wage, "Wage"))

## Predictor
nvar_plot(age, "Age")
cvar_plot(year, "Year")
cvar_plot(education, "Education")

dim(data)

### Scatter plot
wage_age <- function(line = FALSE, poly = 1, formula_wage_age = y ~ x){
  plot_title <- "Scatter Plot between Wage and Age"
  
  if(poly != 1){
    plot_title <- paste0(plot_title, ": Polynomial degree ", poly)
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

## Fit the linear regression
summary(lm(wage ~ age + education + year, data = data))
## The R-Squared is 0.2619, which is pretty low.

## Consider the Step function, applying on the age variable.
## This is the data from yesr 2003 to 2009, 6 cuts should be enough
summary(lm(wage ~ age + education + cut(data$year, 6), data = data))

## The R-Squared is 0.2626, which improved a little. Consider the scatter plot
## between the age and wage.

wage_age(TRUE)

## The relationship between wage and age is not a linear, consider using the 
## polynomial for age term.

poly_r2 <- c()
poly_plot <- c()

for(i in 2:5){
  poly_r2 <- c(poly_r2,
               summary(lm(wage ~ poly(age, i) + education + year, data = data))$r.squared)
  poly_plot[[i-1]] <- wage_age(TRUE, i, y ~ poly(x,i))
}

do.call(grid.arrange, poly_plot)
grid.arrange(poly_plot[[2]], poly_plot[[3]])

data.frame(degree = 2:5, R2 = poly_r2)

## Try using Spline, starting with basis/natural spline.
## Start with Basis spline
## The degree of freedom is  1 (intercept) + degree + # of knots.
## I will use polynomial degree 3, try different number of knot by 5-fold cross validate

set.seed(1)
data$CV <- sample(rep(1:5, 600))
basis_MSE <- c()

## For loop for the number of knots
for(knots in 1:10){
  MSE <- c()
  
  ## 5-Fold Cross Validation
  for(i in 1:5){
    train_data <- data %>% filter(CV != i)
    validate_data <- data %>% filter(CV == i)
    
    ## Train a model
    model <- lm(wage ~ bs(age, df = 4 + knots) + education + year, data = train_data)
    
    ## Compute the MSE
    MSE <- c(MSE, mean((predict(model, validate_data) - validate_data$wage)^2))
  }
  
  basis_MSE <- c(basis_MSE, mean(MSE))
}

dumm <- data.frame(x = as.factor(4 + 1:10), y = basis_MSE)
ggplot(dumm, aes(x = x, y = y, group = 1)) +
  geom_line() +
  geom_point() +
  labs(title = "5-fold cross-validate MSE: Basis Spline",
       x = "Degree of Freedom", y = "MSE") +
  theme_bw()

## When df = 6, the MSE is the lowest.
summary(lm(wage ~ bs(age, df = 6) + education + year, data = data))
wage_age(TRUE, formula_wage_age = y ~ bs(x,knots = 2))
## R-squared = 0.2923

## Natural spline
## The degree of freedom is  1 (intercept) + degree + # of knots - 2 (at the end).
## I will use polynomial degree 3, try different number of knot by 5-fold cross validate

natural_MSE <- c()
## For loop for the number of knots
for(knots in 1:10){
  MSE <- c()
  
  ## 5-Fold Cross Validation
  for(i in 1:5){
    train_data <- data %>% filter(CV != i)
    validate_data <- data %>% filter(CV == i)
    
    ## Train a model
    model <- lm(wage ~ ns(age, df = 2 + knots) + education + year, data = train_data)
    
    ## Compute the MSE
    MSE <- c(MSE, mean((predict(model, validate_data) - validate_data$wage)^2))
  }
  
  natural_MSE <- c(natural_MSE, mean(MSE))
}

dumm <- data.frame(x = as.factor(2 + 1:10), y = natural_MSE)
ggplot(dumm, aes(x = x, y = y, group = 1)) +
  geom_line() +
  geom_point() +
  labs(title = "5-fold cross-validate MSE: Natural Spline",
       x = "Degree of Freedom", y = "MSE") +
  theme_bw()

## When df = 6, the MSE is the lowest.
summary(lm(wage ~ ns(age, df = 6) + education + year, data = data))
wage_age(TRUE, formula_wage_age = y ~ bs(x,knots = 2))
## R-squared = 0.2927
