## Required Libraries
library(tidyverse) ## This library is for data manipulation.
library(ggplot2) ## This library is for data visualization.
library(gridExtra) ## This library is also for data visualization.
library(splines) ## This library is for spline.
library(RCurl) ## This library is required for reading R file from GitHub

## Set a path for saving the result
path <- "/Users/kevin/506FA20/Stats506_Project/"

### Create result_pic folder if it does not exist.
if(! dir.exists(paste0(path, "R/result_pic"))){
  dir.create(file.path(paste0(path, "R/result_pic")))
}

## Load data and user-written functions into R.
main_url <- "https://raw.githubusercontent.com/skorsu/Stats506_Project/main/"

data <- read.csv(paste0(main_url, "Dataset/data.csv")) ## Data
source(paste0(main_url, "R/EDA.R")) ## Function for EDA
source(paste0(main_url, "R/User-written%20functions.R")) ## Read functions.

## Change Education into the numerical variable.
data <- data %>% mutate(edu = as.numeric(substring(data$education, 1, 1)))

## EDA: Save plots
ggsave(paste0(path, "R/result_pic/EDA.png"), 
       grid.arrange(nvar_plot(wage, "Wage"), nvar_plot(age, "Age"),
                    cvar_plot(year, "Year"), cvar_plot(edu, "Education")))

## Linear Regression
model_lr <- lm(wage ~ age + edu + year, data = data)
summary(model_lr)

### QQ Plot and Kernel Density Plot (Residuals from Linear Regression)
set.seed(1) ## For the reproducible plot.

p1 <- data.frame(resi = model_lr$residuals) %>%
  ggplot(aes(sample = resi)) +
  stat_qq(color = "darkblue") +
  stat_qq_line(color = "red", linetype = "dashed") +
  theme_bw() +
  labs(title = "The QQ plot of the residuals", 
       x = "Inverse Normal",
       y = "Residuals")

p2 <- data.frame(resi = model_lr$residuals) %>%
  ggplot(aes(x = resi)) +
  geom_density(color = "darkblue") +
  geom_density(data = data.frame(resi = rnorm(10000,0,sd(model_lr$residuals))),
               color = "red") +
  theme_bw() +
  labs(title = "Kernel Density Estimate",
       x = "Residual",
       y = "Density")

grid.arrange(p1, p2, ncol = 2)

### Scatter Plot
wage_age(line = TRUE)

## Cubic Polynomial Regression
model_poly <- lm(wage ~ poly(age, 3) + edu + year, data = data)
summary(model_poly)

## Step Function
model_cut <- lm(wage ~ cut(age, 6) + edu + year, data = data)
summary(model_cut)
wage_age(TRUE, 1, y ~ cut(x,6)) +
  geom_vline(xintercept = c(28.3, 38.7, 49, 59.3, 69.7), 
             color = "red")

## Prepared the data for performing 5-fold cross validation.
set.seed(1)
data$CV <- sample(rep(1:5, 600))

## Basis Spline
plot_kfold()
model_basis <- lm(wage ~ bs(age, df = 6) + edu + year, data = data)
summary(model_basis)
wage_age(TRUE, 1, y ~ bs(x,df = 6))

## Natural Spline
plot_kfold(bs = FALSE)
model_natural <- lm(wage ~ ns(age, df = 6) + edu + year, data = data)
summary(model_natural)
wage_age(TRUE, 1, y ~ ns(x, df = 6))