# R

This folder contained the `.R` file which is the draft version of the R part in the final report.

## code.R
This is the main file for audience to reproduce the work. The main objective of this file is to create models. Below is the list of models created.
	
* Linear Regression  
* Linear Regression with Step Function on Age  
* Polynomial Regression Degree 3 on Age  
* Basis Spline  
	* Using K-fold Cross Validation to choose the number of knots/degree of freedom.  
* Natural Spline  
	* Using K-fold Cross Validation to choose the number of knots/degree of freedom.  

In order to run this file, you will need two additional files listed which are `EDA.R` and `User-written function.R`.  

## EDA.R
This file contains the code for creating Histogram and Bar plot.

## User-written function.R
This file contains the code of the functions used in this tutorial. There are two user-defined functions which are `wage_age` and `plot_kfold`.  

### wage_age
This function is for creating the scatter plot of `Wage` and `Age`. In addition, it includes the regression line in to plot.  

### plot_kfold
This function will perform 5-fold cross validation in order to determine the degree of freedom/number of knots for basis spline and natural spline. This function will create a plot along with calculate the MSE for each knots/degree of freedom under the k-fold cross validation process.