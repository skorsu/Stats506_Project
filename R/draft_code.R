## Library
library(ggplot2)
library(tidyverse)
library(splines)

## Import the data
data <- read.csv("/Users/kevin/506FA20/Stats506_Project/Dataset/data.csv")

## Cheack for missing value for each variable
for(i in 1:dim(data)[2]){
  if(sum(is.na(data[,i])) == 0){
    print("No Missing Value")
  } else {
    print("Contains Missing Value")
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
cvar_plot(maritl, "Marital Status")
cvar_plot(year, "Year")
cvar_plot(race, "Race")
cvar_plot(education, "Education")
cvar_plot(region, "Region")
cvar_plot(jobclass, "Job")
cvar_plot(health, "Health Status")
cvar_plot(health_ins, "Health Insurance")

ggsave("/Users/kevin/506FA20/Stats506_Project/R/region.png", 
       cvar_plot(region, "Region"))

##### Comment
##### (1) Drop `region` out from teh analysis since the value for this variable
#####     is the same for the entire dataset.
##### (2) Consider the histogram of the wage, the response variable. 
#####     - I have eliminated the observations that wage > 200 (99 observationas.)
##### (3) logwage has the same meaning with wage. I decided to drop it.

data <- data %>% filter(!(wage > 200)) %>% dplyr::select(-logwage, -region)

##### Currently, I have 2901 observations with 9 variables.

### Scatter plot
wage_age <- function(line = FALSE, formula_wage_age = y ~ x){
  plot_wage_age <- ggplot(data, aes(x = age, y = wage)) + 
    geom_point(color = "darkblue") +
    theme_bw() +
    labs(title = "Scatter Plot between Wage and Age", x = "Age", y = "Wage")
  
  if(line == TRUE){
    plot_wage_age + 
      geom_smooth(method = "lm", formula = formula_wage_age, color = "yellow")
  } else {
    plot_wage_age
  }
}

ggsave("/Users/kevin/506FA20/Stats506_Project/R/wageage.png", 
       wage_age())

### Want to fit the model between Wage and Age
summary(lm(wage ~ age, data = data))
wage_age(TRUE, y ~ x)

ggsave("/Users/kevin/506FA20/Stats506_Project/R/wageage1.png", 
       wage_age(TRUE, y ~ x))

### Consider using higher degree of polynomial.
summary(lm(wage ~ poly(age, 3), data = data))
wage_age(TRUE, y ~ poly(x,3))

ggsave("/Users/kevin/506FA20/Stats506_Project/R/wageage2.png", 
       wage_age(TRUE, y ~ poly(x,3)))


### Also, I considered the Step function
summary(lm(wage ~ cut(age, 6), data = data))
wage_age(TRUE, y ~ cut(x,6))

ggsave("/Users/kevin/506FA20/Stats506_Project/R/wageage3.png", 
       wage_age(TRUE, y ~ cut(x,6)))

### I considered the Basis Spline
summary(lm(wage ~ bs(age, knots = seq(30,70,10)), data = data))
wage_age(TRUE, y ~ bs(x,knots = seq(30,70,10)))

ggsave("/Users/kevin/506FA20/Stats506_Project/R/wageage4.png", 
       wage_age(TRUE, y ~ bs(x,knots = seq(30,70,10))))

### Natural Spline
summary(lm(wage ~ ns(age, df = 3), data = data))
wage_age(TRUE, y ~ ns(x, df = 3))

ggsave("/Users/kevin/506FA20/Stats506_Project/R/wageage5.png", 
       wage_age(TRUE, y ~ ns(x, df = 3)))






