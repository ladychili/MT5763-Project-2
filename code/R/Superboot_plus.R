
#######A super fast version#####
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

