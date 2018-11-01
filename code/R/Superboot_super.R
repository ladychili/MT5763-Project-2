
######################## The final version ##############################


##########################Super robust and super fast###########

mycl <- makeSOCKcluster(c('localhost','localhost'))

lmBoot.super <- function(nboots=1000,inputdata,formula,cl,seeds){
  # 
  # data.frame only
  # convert all categorical 
  # variable into appropriate class first
  # formula must be in the form of y..~x+....
  # 
  # nboots: number of bootstrap,default to 1000
  # inputdata: dataframe with all the variables necessary in formula
  # CL: The cluster
  # 
  # step.1 
  # 
  # transfrom data.frame into matrixs
  # all variables with class of factors will
  # be converted to dummy variables and
  # intercepts are automactically included
  # 
  x <- model.matrix(formula,data=inputdata)
  y <- as.character(formula)[2]
  y <- as.matrix(inputdata[y])
  #
  #Step 2: 
  # using qr.rank to get rid of correlated variables
  # To ensure that t(X)*X is invertible
  # Detail explanation:
  # https://en.wikipedia.org/wiki/Invertible_matrix
  # Correlated variables are omitted
  # 
  x <- x[,qr(x)$pivot[1:qr(x)$rank]]
  #
  #Step 3:
  #
  #Parlappy to perform parallel computation
  #two sets of seeds(
  #
  set.seed(seeds)
  i <- sample(1:nboots,nboots,replace = FALSE)
  allcoefs <-parLapply(
    cl,i,fun=function(i=i){
    set.seed(i)
    #
    # sample index instead of the whole matrix
    # is faster
    #
    indexs <- 
      sample(1:nrow(y),nrow(y),replace = TRUE)
    #
    #calculating t(X)X
    #
    ixx <- crossprod(x[indexs,],x[indexs,])
    #
    # Solving the linear equation system
    # Using QR decomposition
    # See for proofs and details:
    # https://en.wikipedia.org/wiki/Linear_least_squares
    # In fact, this is excatly what lm() is doing inside.
    # except that lm() do a lot more than just computating
    # coefficients
    #
    list(solve(ixx)%*%crossprod(x[indexs,],y[indexs,]))
  })
}



tests <- lmBoot.super(nboots=1000,inputdata=babiesDf,formula=as.formula(wt~dwt+number),cl=mycl,seeds=1)



#######  Previous Version #####
#  darwbacks: 1. only accept matrix 
#             2. singularity problems
#             3. can only get coefficients
#### faster than boot though ~~~~~


lmBoot.v1 <- function(nboots,x,y){
     cl <- makePSOCKcluster(c("localhost","localhost"))
     clusterExport(cl,list =list('x','y','nboots'),envir =.GlobalEnv)
  
    index <- matrix(sample(
      1:nrow(y),nrow(y)*nboots,replace = TRUE
      ),nrow=nboots,ncol=nrow(y),byrow = TRUE)
    
    allcoefs <- parRapply(cl,index,fun = function(indexs){
          ixx <- crossprod(x[indexs,],x[indexs,])
          if(det(ixx)!=0){list(
            solve(ixx)%*%crossprod(x[indexs,],y[indexs,]))
          }
        })
      }
