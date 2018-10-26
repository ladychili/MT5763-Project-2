sasfile DataSet load; /* Sasfile statement loads data into buffers in the ram = faster processing */
  proc surveyselect data =DataSet out=outboot;
  seed=1111; 
  method=urs; /*bootstrap requires simple random sampling with replacment (also known as Unrestricted Random Sampling)*/
    samparte=1 /* need the same sample size (this options enables choice of sampel size)(1 = 100%)*/
      outhits /* OUTHITS makes sure that the procedure generates an output record every time it hits a given record, rather than only the first time*/
      rep = 1000; /* specifying the number of bootstrap samples we want generated, also produces a by-variable*/
        run;
      safile DataSet close; /* frees up RAM after major processing completed */
        
        ods listing close; /* turn off the output to the Output window */
        proc univariate data=outboot;
        var x;
        by Replicate; /* use Replicate as the by-variable */
          output out=outall kurtosis=curt; 
          run;
          ods listing; /*  turns off the ODS destination that has our list output */
            
            proc univariate data=outall;
            var curt;
            output out=final pctlpts=2.5, 97.5 pctlpre=ci;
            run;
            