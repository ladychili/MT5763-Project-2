  /*Inaugurate Fullstimer option to collect performance*/
  options fullstimer;
  
  /* Sasfile statement loads data into buffers in the ram = faster processing */
  sasfile DataSet load; 
  
  proc surveyselect data =DataSet out=outboot
  
    seed=1111
  
  /* resample with replacement */
    method=urs 
  
  /* each bootstrap sample has N observations */
  sampasize=1
    
  /* option to suppress the frequency var */
    outhits 
      
  /* defining the number of bootstrap samples to generate */
    rep = 1000; 
       
  run;
      
      /* frees up RAM after computer intensive processing complete */
      sasfile DataSet close;
        
       /* turn off the output to the Output window */
        ods listing close; 
        
        proc univariate data=outboot;
        
          var x;
          /* use Replicate as the by-variable */
        
          by Replicate; 
        
          output out=outall mean=meanX; 
          
        run;
          
        ods listing; /*  turns off the ODS destination that has our list output */
            
        proc univariate data=outall noprint;
            
           var meanX;
            
           /* compute 95% bootstrap confidence interval for the mean*/
           output out=final pctlpts=2.5, 97.5 pctlpre=ci; 
            
        run;
    
    /* Obtain bootstrapped regression parameter estimates*/
    proc reg data=outboot outest=bootEstimates noprint;
    
      model Y=X; 
      
      by replicate; 
      
    run;
    /* compute 95% bootstrap confidence interval for mean estimate for each parameter*/
    proc univariate data=bootEstimates;
    
      var X;
      
      output out=regBootCI pctlpts=2.5, 97.5 pctlpre=CI; 
      
    run;
    
    /* plots of the distrubtions of the bootstraps */
    proc gchart data=bootEstimates; 
    
      vbar X;
      
    run;
            
         
