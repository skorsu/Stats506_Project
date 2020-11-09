*Group Project*

* open data wage_data.csv * 


* for recoding/naming of variables see 'code support' file 

describe 

* linear regression example

reg wage age year edu

predict r, resid
kdensity r, normal // plot kernel density with normal density overlay

pnorm r // can help show non-normality in the distribution of the residuals

qnorm r // sensitive to non-normality in the tails


* check homoscedasticity of residuals 

rvfplot, yline(0) //line at 0 to better shows middle of iid 



* checking the linearity * 

twoway (scatter wage age) (lfit wage age) //example shows lowess but is there a way to use splines?


* plot residuals* 
predict r, resid 

scatter r age // plots the residuals against the age variable 

scatter r edu //plots residuals against the education variable 

scatter r year //plots residuals against the year variable

*piecewise step function*, 



*basis functions, and 






*piecewise polynomial, cubic and natural spline.
