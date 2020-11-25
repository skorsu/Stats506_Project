*-----------------------------------------------------------------------------*
* Stats 506, Fall 2020 
* Group Project, Regression Splines
* 
* This script is a tutorial for using splines in Stata
* 
*
* Author: Erin Cikanek ecikanek@umich.edu
* Updated: November 23, 2020
*-----------------------------------------------------------------------------*
// 79: ---------------------------------------------------------------------- *

* To - Do List * 
*! 1. Complete descriptions of code in .Rmd
*! 1. Make stata code in the Rmd neater, if possible.
*! 1. Only include qq plot and kernal desnity plot. 
*! 1. Need a better visual for the polynomial regression
*! 1. Complete code for piecewise step function
*! 		a. Determine best way to visualise results for piecewise 
*!		b. Current visualization for piecewise looks awful - 
*!			something may be wrong
*! 1. Determine best way to visualise results for basis spline
*! 1. Determine best way to visualise results for natural spline

// set up: ------------------------------------------------------------------ *
* for recoding/naming of variables see 'Data_cleaning.do' file 


*cd ~//GitHub/Stats506_Project/Stata // comment out before submission 
*version
log using cikanek_group_proj.log, text replace

* open data* 
use "wage.dta", clear

describe 

*****************************
* linear regression example * ----------------------------------------------- *
*****************************

reg wage age year edu

predict r, resid
kdensity r, normal // plot kernel density with normal density overlay




* qq plot INSERT * 
pnorm r // can help show non-normality in the distribution of the residuals

qnorm r // sensitive to non-normality in the tails


* check homoscedasticity of residuals 
rvfplot, yline(0) //line at 0 to better shows middle of iid 


* checking the linearity * 
twoway (scatter wage age) (lfit wage age) //example shows lowess but is there a way to use splines?


*add polynomial fit and quadratic fit to scatter plot* 
twoway (scatter wage age) (lfit wage age) (fpfit wage age) (qfit wage age)


******************
*cubic polynomial*
******************
drop r

reg wage c.age##c.age##c.age year educ





*************************
*piecewise step function*
************************* 
* use mksline function for easier binning
* cut into six bins either by n or by parts of age so 1/6 of age
* 80-18 = 62 / 6 not decimels for age so 5 cuts, 6 bins 
hist age, bin(6)


* generate 6 age variables, one for each bin * 
* the age varaible does not have decimels * 


mkspline xage1 28.33 xage2 38.66 xage3 48.99 xage4 59.33 xage5 69.66 xage6 = age



* stepwise regression * ----------------------------------------------------- * 

regress wage xage1 xage2 xage3 xage4 xage5 xage6 ///
	year educ

predict yhat	

* since it is stepwise we need to code the fitted lines this way *
bysort age: egen agefit = mean(yhat)

* want margins in stata where everything else held at means* 
margins predict(xb) atmeans



twoway (scatter wage age, sort) ///
         (line agefit age if age <28.33, sort) ///
		 (line agefit age if age >=28.33 & age < 38.66, sort) ///
		 (line agefit age if age >=38.66 & age < 48.99, sort) ///
		 (line agefit age if age >=48.99 & age<59.33, sort) ///
		 (line agefit age if age >=59.33 & age<69.66, sort) ///
		 (line agefit age if age >=69.66, sort), xline(28.33 38.66 48.99 59.33 69.66) // this looks awful

		 
**************
*basis spline* -------------------------------------------------------------- *
**************

* cross-validataion * 





 
* currently use command bspline
* https://data.princeton.edu/eco572/smoothing2
*create the spline p(3) = cubic spline and gen is the new var
bspline, xvar(age) knots(18 35 50 65 80) p(3) gen(_agespt)


regress wage _agespt* year educ

regress wage _agespt*
predict agespt
*(option xb assumed; fitted values)

* UPDATE PLOTS and REG OUTPUT *
twoway (scatter wage age)(line agespt age, sort), legend(off)  ///
           title(Basis Spline for Age)



* natural spline * ---------------------------------------------------------- *
*However, a restricted cubic spline may be a better choice than a linear spline when working with a very curved function. When using a restricted cubic spline, one obtains a continuous smooth function that is linear before the first knot, a piecewise cubic polynomial between adjacent knots, and linear again after the last knot




* cross-validataion * 



* use command mkspline to create a cubic/natural spline 

mkspline age_nc=age, cubic knots(18 35 50 65 80)



regress wage age_nc* educ year
margins, predict(xb) atmeans

* This also looks bad - need to figure out * 
twoway (scatter wage age)(line age_nc* age, sort), legend(off)  ///
           title(Natural Spline for Age)



* can also just specify the number of knots rather than the cut points *
mkspline age_nspk=age, cubic nknots(5) 

regress wage age_nspk* educ year


*In the third syntax, mkspline creates variables containing a restricted cubic spline of oldvar.
* This is also known as a natural spline. The location and spacing of the knots is determined by the
* specification of the nknots() and knots() options.



// 79: ---------------------------------------------------------------------- *
