
# This script is to proﬁle the original lmBoot(), and ﬁnal version lmBoot.super()
# Profile file can be file in folder "profiling" under root directory of the repository


# Source both functions ---------------------------------------------------

source("Superboot_super.R")
source("lmBoot.r")


# Generate test dataset ---------------------------------------------------

x <- runif(1000)
y <- 20 + 2*x + rnorm(1000, 0, 1)
inputData <- data.frame(x,y)


# 5000-iteration Bootstrapping  -------------------------------------------

profvis::profvis({
  test <- lmBoot(inputData, 5000)
  test.super <- lmBoot.super(5000, inputData, y~x, cl = mycl, seeds = 5763)
  })
