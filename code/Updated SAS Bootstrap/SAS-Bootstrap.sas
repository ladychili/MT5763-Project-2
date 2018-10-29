  /* Sasfile statement loads data into buffers in the ram = faster processing */
  sasfile DataSet load; 
  
  proc surveyselect data =DataSet out=outboot;
  
  seed=1111; 
  
  /* resample with replacement */
  method=urs; 
  
  /* each bootstrap sample has N observations */
    samparte=1
    
    /* option to suppress the frequency var */
      outhits 
      
      /* defining the number of bootstrap samples to generate */
      rep = 1000; 
       
       run;
      
      /* frees up RAM after computer intensive processing complete */
      safile DataSet close;
        
       /* turn off the output to the Output window */
        ods listing close; 
        
        proc univariate data=outboot;
        
        var x;
        /* use Replicate as the by-variable */
        
        by Replicate; 
        
          output out=outall kurtosis=curt; 
          
          run;
          
          ods listing; /*  turns off the ODS destination that has our list output */
            
            proc univariate data=outall;
            
            var curt;
            
            /* compute 95% bootstrap confidence interval */
            output out=final pctlpts=2.5, 97.5 pctlpre=ci; 
            
            run;
            
