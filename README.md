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

### Example Analysis

_TBA_


## SAS Bootstrapping

This section is to elucidate how the two functions work and to be implemented and illustrated with an analysis of a simple example with plots and interpretation.  The corresponding data set was uploaded in the repository. 

The Bootstrap Functions generated the 95% Confidence Intervals for the mean, the mean estimate for each parameter and the corresponding plots of the distrubtion of the bootstrap parameters.

- plots, interpreteation,

SAS

![SASbootplot](https://github.com/ladychili/MT5763-Project-2/blob/master/code/SAS/Output/SAS%20plot%20bootstrap.png)
      
From the plot above, it was seen that the shape of the histogram was bell-shaped, in spite of being slightly skewed left, which fitted the normality in general. 

The mean was close to -3.24.  For single covariate analysis, it suggested the linear relationship as follows.

![equation](https://github.com/ladychili/MT5763-Project-2/blob/master/code/SAS/Output/CodeCogsEqn2.gif)


- dataset to be uploaded

SAS

Fitness.csv can be accessed at the link below.
(https://github.com/ladychili/MT5763-Project-2/tree/master/data)

- Figure indicating speed increase attributable to each major changes

SAS

From the fullstimers log,
(For detailed log file, please access (https://github.com/ladychili/MT5763-Project-2/tree/master/code/SAS/Fullstimer%20Log))
The Step Count was reduced from 1246 to 9.  The time lapse was dropped from 12 seconds to 3 second.


## Work attribution

Statement of Original Work: We confirm that this repository is the work of our team, except where clearly indicated in the text.

- Qingting Zheng __ Modified lmBoot.super(), R profiling, example analysis

- Man-Ho Suen __ SAS bootstrapping macro and RTF output and example analysis 

- Darren O'Reilly __

- Konstantinos Theodosopoulos __

- Jonathan Wall __

- Ying He __ Optimized bootstrap algorithm

## Reference List

C. Donovan (2018). MT5763 Project 2 - code collaboration and computer intensive inference. Available at <https://moody.st-andrews.ac.uk/moodle/pluginfile.php/705037/mod_resource/content/1/MT5763_project%202%20description.nb.html> (Accessed at 29 Oct 2018) 

Rawlings, J.O., Pantula, S.G., Dickey, D.A.(1998) Applied Regression Analysis: A Research Tool 2nd Edition

RStudio Team (2018). RStudio: Integrated Development for R. RStudio, Inc., Boston, MA URL <http://www.rstudio.com/>.

SASnrd (2018). Track Performance in SAS with the LOGPARSE Macro. Available at <http://sasnrd.com/sas-logparse-macro/> (Accessed at 2 Nov 2018)



