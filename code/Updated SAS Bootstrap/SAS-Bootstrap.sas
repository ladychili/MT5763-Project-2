  /* Sasfile statement loads data into buffers in the ram = faster processing*/
  sasfile DataSet load; 
  
  proc surveyselect data =DataSet out=outboot;
  
  seed=1111; 
  
  /* set method to Unrestricted Random Sampling/SRS WR*/
  method=urs; 
  
  /* set sample size to 100% (1 = 100%)*/
    samparte=1
    
    /* generate an output record every time it hits a given record, rather than only the first time*/
      outhits 
      
      /* defining the number of bootstrap samples to generate*/
      rep = 1000; 
       
       run;
      
      /* frees up RAM after computer intensive processing complete*/
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
            
            output out=final pctlpts=2.5, 97.5 pctlpre=ci; 
            
            run;
            
