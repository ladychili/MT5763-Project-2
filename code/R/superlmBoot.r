superlmBoot <- function(formula, data, B, alpha = 0.05) {
# Purpose: paral bootstrapping linear model 
  
# Inputs: formula - formula for regression
#         data - dataset for regression
#         B - the number of bootstrap iterstions
#         alpha - alpha-level of confidence interval, default
  
# Output: A list containing
#           estimates - estimates of all itetations
#           CI - Bootstrap confidence intervals, default 0.05
    
  require(parallel)
  require(foreach)
  myClust <- makeCluster(detectCores()-1, type = "PSOCK")
  doParallel::registerDoParallel(myClust)
  
  n <- nrow(data)
  model <- lm(formula,data)
  a <- foreach(i = 1:B) %dopar% {
    resample <- data[sample(n, replace = TRUE),]
    re.model <- lm(formula, resample)
    coef(re.model)
  }
  stopCluster(myClust)
  
  estMat <- matrix(unlist(a), nrow = B, byrow = TRUE)
  colnames(estMat) <- names(a[[1]])
  CI <- apply(estMat, 2, quantile, probs=c(alpha/2, 1-alpha/2))
  return(list(estimates = estMat,
              CI = t(CI)))
}


set.seed(1)
x <- runif(1000)
y <- 20 + 2*x + rnorm(1000, 0, 1)
inputData <- data.frame(x,y)

# profiling ---------------------------------------------------------------

profvis::profvis({superlmBoot(y~x, inputData, 5000)})

