doBoot <- function(index, formula, regData){
  n <- nrow(regData)
  resample <- regData[sample(n, replace = TRUE),]
  re.model <- lm(formula, resample)
  coef(re.model)
}

ultralmBoot <- function(formula, data, B, alpha = 0.05){
  # Purpose: Bootstrapping on linear regression model, the
  #         numbers and types of covariates can be arbitrary
  
  # Inputs: formula - formula for regression
  #         data - dataset for regression
  #         B - the number of bootstrap iterations
  #         alpha - alpha-level of confidence interval, default 0.05
  
  # Output: A list containing
  #           estimates - estimates of all iterations
  #           CI - Bootstrap confidence intervals
  
  require(parallel)
  myClust <- makeCluster(detectCores()-1, type = "PSOCK")
  doParallel::registerDoParallel(myClust)
  a <- parLapply(myClust, 1:B, doBoot, formula = formula, regData = data)
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

system.time(test.ultra <- ultraLmBoot(y~x, inputData, 5000))

# profile -----------------------------------------------------------------

profvis::profvis({test.ultra <- ultraLmBoot(y~x, inputData, 5000)})
