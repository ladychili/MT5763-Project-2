superlmBoot <- function(formula, data, B) {
# Purpose: paral bootstrapping linear model 
# Inputs: formula - formula for regression
#         data - dataset for regression
#         B - the number of bootstrap iterstions
# Output: A matrix containing coefficients of all iteration
  
  myClust <- parallel::makeCluster(detectCores()-1, type = "PSOCK")
  doParallel::registerDoParallel(myClust)
  
  n <- nrow(data)
  model <- lm(formula,data)
  #
  a <- foreach(i = 1:B) %dopar% {
    resample <- data[sample(n, replace = TRUE),]
    re.model <- lm(formula, resample)
    coef(re.model)
  }
  stopCluster(myClust)
  
  estMat <- matrix(unlist(a), nrow = B, byrow = TRUE)
  return(estMat)
}


set.seed(1)
x <- runif(1000)
y <- 20 + 2*x + rnorm(1000, 0, 1)
inputData <- data.frame(x,y)

# profiling ---------------------------------------------------------------

profvis::profvis({superlmBoot(y~x, inputData, 5000)})

