*-----------------------------------------------------------------------------*
* Stats 506, Fall 2020 
* Group Project, Question X
* 
* This script is a tutorial for using splines in Stata
* 
*
* Author: Erin Cikanek ecikanek@umich.edu
* Updated: November 12, 2020
*-----------------------------------------------------------------------------*
// 79: ---------------------------------------------------------------------- *

* To - Do List * 
*! 1. Complete descriptions of code in .Rmd
*! 1. Export Results for cubic polynomial
*! 1. Complete code for piecewise step function
*! 		a. Determine best way to visualise results for piecewise 
*!		b. Current visualization for piecewise looks awful - 
*!			something may be wrong
*! 1. Complete code for basis splines
*! 		a. Determine best way to visualise results for basis spline
*! 1. Complete code for natural splines
*! 		a. Determine best way to visualise results for natural spline

// set up: ------------------------------------------------------------------ *
* for recoding/naming of variables see 'Data_cleaning.do' file 


*cd ~//Users/erincikanek/GitHub/Stats506_Project/Stata // comment out before submission 
*version
log using cikanek_group_proj.log, text replace

* open data* 
use "wage.dta", clear



describe 

* linear regression example

reg wage age year edu
return list


putexcel set reg_groupporj

putexcel B2=matrix(r(table)')

putexcel A1="Variable"
putexcel A2 = "Age"
putexcel A3 = "Year"
putexcel A4 = "Education"
putexcel A5 = "Constant"

putexcel B1 ="Coefficient"
putexcel C1 ="Std. Error"
putexcel D1 ="t"
putexcel E1 ="P-Value"
putexcel F1 ="lower 95%"
putexcel G1 ="upper 95%"



predict r, resid
kdensity r, normal // plot kernel density with normal density overlay

pnorm r // can help show non-normality in the distribution of the residuals

qnorm r // sensitive to non-normality in the tails


* check homoscedasticity of residuals 
rvfplot, yline(0) //line at 0 to better shows middle of iid 


* checking the linearity * 
twoway (scatter wage age) (lfit wage age) //example shows lowess but is there a way to use splines?


* plot residuals against variables* 
drop r 
reg wage age
predict r, resid
scatter r age, yline(0) // plots the residuals against the age variable 



******************
*cubic polynomial*
******************

twoway (scatter wage age) (lfit wage age)

*add polynomial fit and quadratic fit to scatter plot* 
twoway (scatter wage age) (lfit wage age) (fpfit wage age) (qfit wage age)



reg wage c.age##c.age##c.age year educ

predict r, resid
rvfplot,  //line at 0 to better shows middle of iid 




*************************
*piecewise step function*
************************* 

* try to cut into six bins either by n or by parts of age so 1/6 of age
* 80-18 = 62 / 6 not decimels for age so 5 cuts, 6 bins 
hist age, bin(6)


* generate 6 age variables, one for each bin * 
* the age varaible does not have decimels * 

generate age1 = (age - 28.33)
replace age1 = 0 if (age >= 28.33)
generate age2 = (age-38.66)
replace age2 = 0 if age <28.33 | age > 38.66
generate age3 = (age- 48.99)
replace age3 = 0 if age <38.66 | age >=48.99
generate age4 = (age - 59.33)
replace age4 = 0 if age <48.99 | age >= 59.33 
generate age5 = (age - 69.66)
replace age5= 0 if age < 59.33 | age>=69.66
generate age6 = (age-80)
replace age6 = 0 if age <69.66

* create intercept variables* 


generate int1 = 1
replace int1 = 0 if age >= 28.33
generate int2 = 1
replace int2 = 0 if age <28.33 | age > 38.66
generate int3 = 1
replace int3 = 0 if age <38.66 | age >=48.99
generate int4 = 1
replace int4 = 0 if age <48.99 | age >= 59.33 
generate int5 = 1
replace int5= 0 if age < 59.33 | age>=69.66
generate int6 = 1
replace int6 = 0 if age <69.66



* stepwise regression * 

regress wage int1 int2 int3 int4 int5 int6 age1 age2 age3 age4 age5 age6 ///
	year educ, hascons


*use yhat predictions to graph results * 
predict yhat

twoway (scatter wage age) ///
         (line yhat age if age <28.33, sort) ///
		 (line yhat age if age >=28.33 & age < 38.66, sort) ///
		 (line yhat age if age >=38.66 & age < 48.99, sort) ///
		 (line yhat age if age >=48.99 & age<59.33, sort) ///
		 (line yhat age if age >=59.33 & age<69.66, sort) ///
		 (line yhat age if age >=69.66, sort), xline(28.33 38.66 48.99 59.33 69.66) // this looks awful



*basis spline* 
* currently use command bspline
* https://data.princeton.edu/eco572/smoothing2
*create the spline p(3) = cubic spline and gen is the new var
bspline, xvar(age) knots(18 35 50 65 80) p(3) gen(_agespt)


quietly regress wage _agespt*, noconstant

predict agespt
*(option xb assumed; fitted values)


twoway (scatter wage age)(line agespt age, sort), legend(off)  ///
           note(knots 35 50 65) title(A Basis Spline)










* natural spline
