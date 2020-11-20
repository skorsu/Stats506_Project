## Required Libraries
library(tidyverse) ## This library is for data manipulation.
library(ggplot2) ## This library is for data visualization.
library(gridExtra) ## This library is also for data visualization.
library(splines) ## This library is for spline.

## Load data and user-written functions into R.
path <- "/Users/kevin/506FA20/Stats506_Project/" ## Change to your path
data <- read.csv(paste0(path, "dataset/data.csv"))
source(paste0(path, "R/User-written functions.R")) ## Read functions.
source(paste0(path, "R/EDA.R")) ## Function for EDA

## Change Education into the numerical variable.
data <- data %>% mutate(edu = ifelse(education == "1. < HS Grad", 1, 
                                     ifelse(education == "2. HS Grad", 2, 
                                            ifelse(education == "3. Some College", 3,
                                                   ifelse(education == "4. College Grad", 4, 5)))))

## EDA: Save plots
ggsave(paste0(path, "R/EDA.png"), 
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
model_cut <- lm(wage ~ cut(age, 4) + edu + year, data = data)
summary(model_cut)
wage_age(TRUE, 1, y ~ cut(x,4)) +
  geom_vline(xintercept = c(33.5, 49, 64.5), color = "red")



