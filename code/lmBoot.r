lmBoot <- function(inputData, nBoot){
  
  for(i in 1:nBoot){
    
    # resample our data with replacement
    bootData <- inputData[sample(1:nrow(inputData), nrow(inputData), replace = T),]
    
    # fit the model under this alternative reality
    bootLM <- lm(y ~ x, data = bootData)
    
    # store the coefs
    if(i == 1){
      
      bootResults <- matrix(coef(bootLM), ncol = 2)

      } else {
      
      bootResults<- rbind(bootResults, matrix(coef(bootLM), ncol = 2))

    }
    

  } # end of i loop
  
  bootResults
  
}

# test efficiency of original function

# Test 1 - 50 obs. 5000 iteration
test1 <- data.frame(x = mtcars$hp, y = mtcars$mpg)
time1 <- system.time(lmBoot(test1, 5000))

# Test 2 - 84 obs. 5000 iteration
test2 <- data.frame(x = CO2$conc, y = CO2$uptake)
time2 <- system.time(lmBoot(test2, 5000))


