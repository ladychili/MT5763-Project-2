# MT5763 Project 2 - Bootstrap Optimization

![](https://raw.githubusercontent.com/ladychili/MT5763-Project-2/master/r-packages.png?token=AaldBeYwHauQ1p-x4kRfKTNPYLxc-3Q2ks5b2xckwA%3D%3D)

EI Topo Members:

- Qingting Zheng, 180024570

- Man-Ho Suen, 180026297

- Darren O'Reilly, 180029457

- Konstantinos Theodosopoulos, 170026763

- Jonathan Wall, 180007719

- Ying He, 180011028

## R Bootstrapping 

### Improved Function _lmBoot.super()_

The final version _lmBoot.super()_ is able to handle arbitrary numbers and types of explanatory variables, and below is the documentation for it.

Dependency:

- _snow_

Arguments: 

- _nboots_ - the number of bootstrap iterstions, default by 1000

- _inputdata_ - dataset for regression 

- _formula_ - formula for regression 

- _cl_ - sock cluster for paralleling

- _seeds_ - sampling seed
        
Output: a list containing

- _coef_ - coefficient estimates of all itetations

- _CI_ - Bootstrap confidence intervals for each coefficients


### lmBoot.super() vs boot()

Results from *microbenchmark*:(Unit: milliseconds)

5 times tests for 1000 bootstrap. Both using SNOW backend and 2 clusters.

The improved function is significantly faster than the function in library `boot`


| expr  | min    | lq     | mean   | median | uq     | max    | neval | cld |
|-------|--------|--------|--------|--------|--------|--------|-------|-----|
| boot  | 780.73 | 823.52 | 859.51 | 855.55 | 911.43 | 926.31 | 5.00  | b   |
| super | 51.39  | 54.50  | 63.81  | 58.99  | 59.69  | 94.51  | 5.00  | a   |


![boot.benchmark](https://github.com/ladychili/MT5763-Project-2/blob/master/profiling/R.boots.png)
![boot.super](https://github.com/ladychili/MT5763-Project-2/blob/master/profiling/profsuper.png)


## Example

Empirical confidence interval of output of *lmBoot.super()*

![CI](https://github.com/ladychili/MT5763-Project-2/blob/master/code/R/output/CItable.png)

Histogram of coefficent estimates of term RunPulse, and the two dashed lines indicates the location of lower and upper confidence interval.

![coefdist](https://github.com/ladychili/MT5763-Project-2/blob/master/code/R/output/Coefdist.png)

## SAS Bootstrapping

The Bootstrap Functions generated the 95% Confidence Intervals for the mean, the mean estimate for each parameter and the corresponding plots of the distrubtion of the bootstrap parameters.

### Function

It was designed to generate 95% confidence intervals for the mean, the mean estimate for each parameter and plots of the distributions of the bootstrap parameters for one covariate.

### How to use 

The inputs and outputs were described as follows.  

 Inputs: 						
 
	- NumberOfLoops: the number of bootstrap iterations
	
	- NumberOfRep: the number of bootstrap dataset to be stacked
	
	- Dataset: A SAS dataset containing the response and covariate	
	
	- XVar: The covariate for our regression model (gen. continuous numeric)
	
	- YVar: The response variable for our regression model (gen. continuous numeric)	
        
  Outputs:
  
  
	- 95% CI for the mean
	
	- Mean estimate for each parameter
	
	- plot of the distribution of the bootstrap parameters
  
After running the macro, by inputing the following into the Editor in SAS.  
  
  __*%RegressionRandTest(NoOfRep = 100 , NoOfLoops = 100, DataSet = Mt5763.Fitness, Xvar = Runtime, Yvar = Oxygen)*__
  
Fitness.csv was imported under Mt5763 library.  The Randomisation test was undergone with 100 bootstraps dataset and 100 boostrap iteration, modelling Oxygen against Runtime. 

The simple example below could be generated and analysis was in the next session. 

### Plots and interpreteation

![SASbootplot](https://github.com/ladychili/MT5763-Project-2/blob/master/code/SAS/Output/SAS%20plot%20bootstrap.png)
      
From the plot above, it was seen that the shape of the histogram was bell-shaped, in spite of being slightly skewed left, which fitted the normality in general. 

The mean from the graph was close to -3.24.  The mean computed by SAS is -3.2972864. For single covariate analysis, it suggested the linear relationship as follows.

![equation](https://github.com/ladychili/MT5763-Project-2/blob/master/code/SAS/Output/CodeCogsEqn3.gif)

The corresponding 95% Confidence Interval was [-3.63193, -2.96430].

The result implied that Oxygen intake rate had negatively linear relationship with the RunTime.  In other words, the Oxygen intake rate decreased if the RunTime increased.  It could be interpreted as one can run faster with a higher oxygen intake rate.  The result was reasonable as a higher oxygen intake rate usually indicated one with stronger physical ability.  

### Dataset

Fitness.csv can be accessed at the link below.
(https://github.com/ladychili/MT5763-Project-2/tree/master/data)

### Figure indicating speed increase attributable to each major changes

From the fullstimers log,
(for detailed log files, please access (https://github.com/ladychili/MT5763-Project-2/tree/master/code/SAS/Fullstimer%20Log))
The Step Count was reduced from 1246 to 9.  The time lapse was dropped from 12 seconds to 3 seconds.  It could be seen that the improvement was significant. 

### RTF Output

It could be found here (https://github.com/ladychili/MT5763-Project-2/blob/master/code/SAS/output.rtf). 

## Work attribution

Statement of Original Work: We confirm that this repository is the work of our team, except where clearly indicated in the text.

- Qingting Zheng __ Modified lmBoot.super(), R profiling, example analysis

- Man-Ho Suen __ SAS bootstrapping macro and RTF output and example analysis 

- Darren O'Reilly __

- Konstantinos Theodosopoulos __ Contribution on SAS bootstrapping macro

- Jonathan Wall __

- Ying He __ Optimized bootstrap algorithm

## Reference List

C. Donovan (2018). MT5763 Project 2 - code collaboration and computer intensive inference. Available at <https://moody.st-andrews.ac.uk/moodle/pluginfile.php/705037/mod_resource/content/1/MT5763_project%202%20description.nb.html> (Accessed at 29 Oct 2018) 

Rawlings, J.O., Pantula, S.G., Dickey, D.A.(1998) Applied Regression Analysis: A Research Tool 2nd Edition

R Core Team (2018). R: A language and environment for statistical computing. R Foundation for Statistical Computing,
  Vienna, Austria. URL <https://www.R-project.org/>.
  
RStudio Team (2018). RStudio: Integrated Development for R. RStudio, Inc., Boston, MA URL <http://www.rstudio.com/>.

SAS (2018). Version 9.4. Cary, NC: SAS Institute Inc

SASnrd (2018). Track Performance in SAS with the LOGPARSE Macro. Available at <http://sasnrd.com/sas-logparse-macro/> (Accessed at 2 Nov 2018)



