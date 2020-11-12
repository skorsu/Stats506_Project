*Group Project*

* open data wage_data.csv * 
use use "/Users/erincikanek/GitHub/Stats506_Project/Stata/wage.dta", clear

* for recoding/naming of variables see 'code support' file 

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



* suggests a cut point for age - what is ours? *

* create age variables* 

* create intercept variables* 


reg wage age year edu
return list






*basis spline






* natural spline
