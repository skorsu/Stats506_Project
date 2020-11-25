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
Here is the [link](https://raw.githack.com/skorsu/Stats506_Project/main/Group_6.html) to view the latest version of the project. The source code for this file is `Group 6.Rmd`.  

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
	* ~~The `education` variable: make it to be consistent with the others.~~
* Stata
    * Complete descriptions of code in .Rmd
    * Make stata code in the Rmd neater, if possible.
    *  Need a better visual for the polynomial regression
        *    a. Determine best way to visualise results for piecewise 
        *    b. Current visualization for piecewise looks awful - something may be wrong
    * Determine best way to visualise results for basis spline
    * Complete code for natural splines
        *    a. Determine best way to visualise results for natural spline
     
## Comment from Peer-Review Activity
* It would be more helpful to add some more explanation functions and maybe things to consider when using these packages and functions.  
* How can you identify overfitting when using splines?  
* It might be helpful to add more explanation to the principal of step function/natural spline/cubic .  
* Some lines of code exceed 80 characters. 

## Comment from Peer-Review Activity (kyle)
* Great formatting and structure for your first draft. 
* Introduction section looks good. Concepts are clearly stated. 
* For data section, it would be a good idea to provide some basic statistics and visualization about the data. Also the last sentence is kind of vague. Maybe directly state which variables are dependent variables and which is the response variable. 
* For the method section, maybe you can provide more elaborated description about the different spline-like techniques you mentioned. 
* For the python part in the core analysis part, you may want to be consistent with the style in other parts. It would be better to write your steps and explanations in .rmd text instead of including it in code chunk. Also, this would help you clearly presenting the plots.

## Comment from Peer-Review Activity (kyle) 
* The code works and does what it is supposed to do as is described in the written part.
* The code generally follows the style guideline, except that it is better to include header and comment
parts in each chuck of the code.
* The code is cleared structured with different level of titles
* The code is efficient.
* It is better to include introduction of key packages/commands prior to using them.
* The parallel structure between examples can be easily identified.
* The examples are accurate.
* The main content of the tutorial is described in the “Proposal” part. It would be better to organize using
introduction and outline parts.
* The source of the data used in examples is clear and adequately described.
* The writing style is clear and concise.
* There is README describing the project and the relation between files. Source files are also
documented.
* All source files are present and organized in a helpful way.
* There is evidence of multiple commits per member. There is an open issue that is not answered yet.
* The tutorial as a whole is easy to follow and navigate.
* The tutorial have a professional appearance.
* It would be better to include header and comment parts to help reader understand the code.
