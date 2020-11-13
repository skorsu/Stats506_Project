# Stats 506 Fall 2020 Midterm Group Project
**Group Member: [Erin Susan Cikanek](https://github.com/ecikanek/Stats506_public), [Suppapat Korsurat](https://github.com/skorsu/Stats506_public), and [Kyle William Schulz](https://github.com/kylewschulz/Stats506_public)**  

This is a folder for the [Stats 506](https://github.com/jbhender/Stats506_F20) Fall 2020 Midterm Group Project.  

## Proposal
The general topic are we have chosen is regression splines. From our initial research, it seems
that splines can be used as a smoothing technique for a predictor variable. We see potential interest
in exploring splines to account for a predictor variable that has a non-linear relationship with our 
response variable that may change over the domain of the predictor variable.  

We will focus on piecewise step function, basis functions, and piecewise polynomial, cubic and natural spline. 

## Statistical Software
In this project, we will use three statistical softwares, Python, Stata and R.
* Kyle will be using Python.
* Erin will be taking over Stata
* Suppapat will be doing R.

## Data
We use the `Wage` data provided in the library `ISLR` in R. This dataset was created by the author of the book named [`An Introduction to Statistical Learning with Applications in R`](http://faculty.marshall.usc.edu/gareth-james/ISL/). 

The dataset can be downloaded R software by using `library(ISLR)`and `Wage` command respectively or download directly from this site. You can found this dataset under the `Dataset` folder.

## Report
Here is the [link](https://raw.githack.com/skorsu/Stats506_Project/main/Group-6.html) to view the latest version of the project. The source code for this file is `Group 6.Rmd`.  

## Group: To-Do List
Since this project is an on-going project, there are some minor issue that we are still working on it. Here is the to-do list.

* Match up language within code between group members how-tos
* Change data read-in to be transferrable across members 
* Summary/Discussion/Reference sections once results are fully known
* Match up plotting style as much as possible
* Organize git repo
* Update readme
* Improve readme style/info

## Personal: To-Do List
* Python
	* Need to add plots that show the splines relationships like seen in quadratic 
	* Need to move the image files of output into the rmd output
	* Need to add text walking user through python steps 
* R
	* Edit the plots, consider which one should include into the final report.
	* The `education` variable: make it to be consistent with the others.
* Stata
    * . Complete descriptions of code in .Rmd
    * Make stata code in the Rmd neater, if possible.
    *  Need a better visual for the polynomial regression
        *    a. Determine best way to visualise results for piecewise 
        *    b. Current visualization for piecewise looks awful - something may be wrong
    * Determine best way to visualise results for basis spline
    * Complete code for natural splines
        *    a. Determine best way to visualise results for natural spline
