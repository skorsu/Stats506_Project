*-----------------------------------------------------------------------------*
* Stats 506, Fall 2020 
* Group Project, Data Cleaning
* 
* This script cleans and saves the .dta dataset 
* for the splines tutorial in Stata
* 
*
* Author: Erin Cikanek ecikanek@umich.edu
* Updated: November 12, 2020
*-----------------------------------------------------------------------------*
// 79: ---------------------------------------------------------------------- *

// set up: ------------------------------------------------------------------ *
*cd ~/path/to/your/files // comment out before submission 
*version
log using psX_template.log, text replace



* Data Cleaning for Spline Example *
import delimited "/Users/erincikanek/GitHub/Stats506_Project/Stata/wage_data.csv"

keep id year age education jobclass wage

* data set * 
* males from the Atlantic region of the US. 
* 

* education *

encode education, generate(educ)
label variable educ "Level of Education"
label define education 1 "< HS" 2 "HS Graduate" 3 "Some College" 4 "College Grad" 5 "Advanced Degree"
label values educ education

* year * 
tab year // only from 2003 - 2009; this was during the crash 
label variable year year

* age * 
sum age
hist age
label variable age age

* wage  (in tousands of dollars)* 
sum wage // mean = 111.7036
label variable wage "Annual Wage"


* jobclass * 
encode jobclass, generate(jobtype)
label variable jobtype "Type of Job"
label define job 1 "Industrial" 2 "Information" 
label values jobtype job

keep id year age wage educ jobtype 
save "/Users/erincikanek/GitHub/Stats506_Project/Stata/wage.dta"
