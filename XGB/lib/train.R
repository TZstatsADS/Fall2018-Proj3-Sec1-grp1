#########################################################
### Train a classification model with training features ###
#########################################################

### Author: Chengliang Tang
### Project 3


train <- function(dat_train, label_train, par=NULL){
  
  ### Train a Gradient Boosting Model (GBM) using processed features from training images
  
  ### Input: 
  ###  -  features from LR images 
  ###  -  responses from HR images
  ### Output: a list for trained models
  
  ### load libraries
  library("gbm")
  library(xgboost)
  
  ### creat model list
  modelList <- list()
  
  ### Train with XGboost
  if(is.null(par)){
    depth <- 3
    nr<- 5
  } else {
    depth <- par$depth
    nr<- par$nr
  }
  
  ### the dimension of response arrat is * x 4 x 3, which requires 12 classifiers
  ### this part can be parallelized
  for (i in 1:12){
    ## calculate column and channel
    c1 <- (i-1) %% 4 + 1
    c2 <- (i-c1) %/% 4 + 1
    featMat <- dat_train[, , c2]
    labMat <- label_train[, c1, c2]
    

      
      dat = xgb.DMatrix(featMat, label =labMat)
      fit_xgboost <- xgboost(data=dat, max_depth=depth, eta=0.5, objective="reg:linear",nrounds=nr)
    
      modelList[[i]] <- list(fit=fit_xgboost)
      
    

  }
  
  return(modelList)
}
