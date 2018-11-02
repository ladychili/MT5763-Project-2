  /*SAS Macro for bootstrapping*/
  /*Function: To generate 95% confidence intervals for the mean, the mean
  estimate for each parameter and plots of the distributions of the bootstrap
  parameters for one covariate*/
  /*Inputs: 																								*/
	/*	- NumberOfLoops: the number of bootstrap iterations
	/*	- NumberOfBoots: the number of bootstrap sample generated
	/*	- Dataset: A SAS dataset containing the response and covariate										*/
	/*	- XVar: The covariate for our regression model (gen. continuous numeric)						*/
	/*	- YVar: The response variable for our regression model (gen. continuous numeric)				*/
  /*Outputs:																								*/
	/*	- 95% CI for the mean */
	/*	- Mean estimate for each parameter */
	/*	- plot of the distribution of the bootstrap parameters */

  %macro RegressionRandTest(NoOfBoots, NoOfLoops, DataSet, Xvar, Yvar);

  /* Set the fullstimer option to write sufficient performance information to the log */
  options fullstimer;
  
  /* Sasfile statement loads data into buffers in the ram = faster processing */
  sasfile &DataSet load; 
  
  proc surveyselect data=&DataSet out=outboot
  
    seed=1111
  
  /* resample with replacement */
    method=urs 
  
  /* each bootstrap sample has N observations */
   sampasize= &NoOfLoops
    
  /* option to suppress the frequency var */
    outhits 
      
  /* defining the number of bootstrap samples to generate */
    rep = &NoOfBoots; 
       
  run;
      
      /* frees up RAM after computer intensive processing complete */
      sasfile &DataSet close;
        
      /* turn off the output to the Output window */
      ods listing close; 
        
      proc univariate data=outboot;
        
         var &Xvar;
         /* use Replicate as the by-variable */
        
         by Replicate; 
        
         output out=outall mean=meanX; 
          
      run;
          
      ods listing; /*  turns off the ODS destination that has our list output */
        
      /* Obtain bootstrapped regression parameter estimates*/
      proc reg data=outboot outest=bootEstimates noprint;
    
         model &Yvar=&Xvar; 
      
         by replicate; 
      
      run;
        
      /*ODS output to an RTF*/
      ods rtf author="El Topo" title="SAS Output Results for Bootstrapping" file="output.rtf";

      proc univariate data=outall;
            
         var meanX;
            
         /* compute 95% bootstrap confidence interval for the mean*/
         output out=final pctlpts=2.5, 97.5 pctlpre=ci; 
            
      run;
        
    /* compute 95% bootstrap confidence interval for mean estimate for each parameter*/
    proc univariate data=bootEstimates;
    
      var &Xvar;
      
      output out=regBootCI pctlpts=2.5, 97.5 pctlpre=CI; 
      
    run;
    
    /*Store the result and rename the var*/
	  data Resultholder;

    	set bootEstimates;

    	keep Intercept &Xvar;

    	rename Intercept=RandomIntercept &Xvar=RandomSlope;

	  run;
    
    /*Print out mean estimate for each parameter to RTF*/
	  proc print data=Resultholder; 
	  run;
    
    /* plots of the distrubtions of the bootstraps parameters*/
    proc gchart data=bootEstimates; 
    
	    note 'Plot of the distribution of the bootstrap parameters';

      vbar &Xvar;
      
    run;
    
    /* Reset log options */
	proc printto;
	run;

ods rtf close;

%mend;

/*Run the marco for Fitness.csv*/
%RegressionRandTest(NoOfBoots = 100 , NoOfLoops = 100, DataSet = Mt5763.Fitness, Xvar = Runtime, Yvar = Oxygen)



            
         
