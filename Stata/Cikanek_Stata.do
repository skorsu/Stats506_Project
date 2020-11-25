*-----------------------------------------------------------------------------*
* Stats 506, Fall 2020 
* Group Project, Regression Splines
* 
* This script is a tutorial for using splines in Stata
* 
*
* Author: Erin Cikanek ecikanek@umich.edu
* Updated: November 25, 2020
*-----------------------------------------------------------------------------*
// 79: ---------------------------------------------------------------------- *


*-------------------------------------- *
* for recoding/naming of variables see 'Data_cleaning.do' file 


*cd ~//GitHub/Stats506_Project/Stata 

log using cikanek_group_proj.log, text replace

* open data* 
use "wage.dta", clear

describe 

*****************************
* linear regression example * ----------------------------------------------- *
*****************************

* simple OLS regression *
reg wage age year edu


* store residuals for plots *
predict r, resid


* kernal density plot * 
kdensity r, normal // plot kernel density with normal density overlay

* qq plot * 
qnorm r, ///
      title(QQ Plot of Residuals)


*add polynomial fit and quadratic fit to scatter plot* 
twoway (scatter wage age) (lfit wage age) (fpfit wage age) (qfit wage age)

******************
*cubic polynomial*
******************
drop r // since residuals were saved this way need to drop

reg wage c.age##c.age##c.age year educ

reg wage c.age##c.age##c.age
predict r

twoway (scatter wage age, sort)(line r age, sort), legend(off)  ///
          title(Cubic Polynomial for Age) xtitle(Age) ytitle(Wage)



*************************
*piecewise step function*
************************* 
* use mksline for easier binning
* 80-18 = 62 / 6 not decimels for age so 5 cuts, 6 bins 
* display histogram just to see binning before starting
hist age, bin(6)

* generate 6 age variables, one for each bin, based on cut points * 
* the age varaible does not have decimels* 

mkspline xage1 28 xage2 39 xage3 49 xage4 59 ///                         
			xage5 70 xage6 = age



* stepwise regression * ----------------------------------------------------- * 

regress wage xage1 xage2 xage3 xage4 xage5 xage6 ///
	year educ 

predict yhat	

* since it is stepwise we need to code the fitted lines this way *
bysort age: egen agefit = mean(yhat)


twoway (scatter wage age, sort) ///
         (line agefit age if age <28.33, sort) ///
		 (line agefit age if age >=28.33 & age < 38.66, sort) ///
		 (line agefit age if age >=38.66 & age < 48.99, sort) ///
		 (line agefit age if age >=48.99 & age<59.33, sort) ///
		 (line agefit age if age >=59.33 & age<69.66, sort) ///
		 (line agefit age if age >=69.66, sort), ///
		 xline(28.33 38.66 48.99 59.33 69.66) title(Piecewise Step Function) ///
		 xtitle(Age) ytitle(Wage)

		 
**************
*basis spline* -------------------------------------------------------------- *
**************
 
*use command bspline
* https://data.princeton.edu/eco572/smoothing2
*create the spline p(3) = cubic spline and gen is the new var
bspline, xvar(age) knots(18 35 50 65 80) p(3) gen(_agespt)


regress wage _agespt* year educ

regress wage _agespt*
predict agespt
*(option xb assumed; fitted values)

* Basis Spline Plot *
twoway (scatter wage age)(line agespt age, sort), legend(off)  ///
           title(Basis Spline for Age) xtitle(Age) ytitle(Wage)



* natural spline * ---------------------------------------------------------- *

* use command mkspline to create a cubic/natural spline 
mkspline age_nc=age, cubic knots(18 35 50 65 80)

regress wage age_nc* educ year


* regress with just age and wage for plot* 
regress wage age_nc*
predict age_ncs


* Figure for Natural spline * 
twoway (scatter wage age, sort)(line age_ncs age, sort), legend(off)  ///
            title(Natural Spline for Age) xtitle(Age) ytitle(Wage)

log close


// 79: ---------------------------------------------------------------------- *
