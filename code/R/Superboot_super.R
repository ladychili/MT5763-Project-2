
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



##########################Super robust and super fast###########
lmBoot.v2 <- function(nboots,x,y){
     clusterExport(cl,list('x','y','nboots'),envir =.GlobalEnv)
     #using qr.rank to get rid of correlated variables
     x <- x[,qr(x)$pivot[1:qr(x)$rank]]
     i=1:nboots
    allcoefs <- parLapply(cl,i,fun = function(i){
          set.seed(i)
          indexs <- sample(1:nrow(y),nrow(y),replace = TRUE)
          #qr.solve()may be faster
          ixx <- crossprod(x[indexs,],x[indexs,])
          list(solve(ixx)%*%crossprod(x[indexs,],y[indexs,]))
          })
}

