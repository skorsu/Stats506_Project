# R

This folder contained the `.R` file which is the draft version of the R part in the final report.

## draft_code.R

This file contained the code related to the below activities.
* Checking the missing value, `NA`, for every variables.
* Performing an `EDA`, Exploratory Data Analysis.
	* For the categorical variables, I have created bar plots. (Function: `cvar_plot`)  
	* For the numerical variables, I have created histograms. (Function: `nvar_plot`)  
* Building Models
	* Linear Regression  
	* Linear Regression with Step Function on Age  
	* Polynomial Regression Degree 3 on Age
	* Basis Spline
		* Using K-fold Cross Validation to choose the number of knots/degree of freedom.
	* Natural Spline
		* Using K-fold Cross Validation to choose the number of knots/degree of freedom.
		