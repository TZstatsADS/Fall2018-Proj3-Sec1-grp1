#############################################################
### Construct features and responses for training images###
#############################################################

### Authors: Chengliang Tang/Tian Zheng
### Project 3

feature <- function(LR_dir, HR_dir, n_points=1000){
  
  ### Construct process features for training images (LR/HR pairs)
  
  ### Input: a path for low-resolution images + a path for high-resolution images 
  ###        + number of points sampled from each LR image
  ### Output: an .RData file contains processed features and responses for the images
  
  ### load libraries
  library("EBImage")
  n_files <- length(list.files(LR_dir))
  
  ### store feature and responses
  featMat <- array(NA, c(n_files * n_points, 8, 3))
  labMat <- array(NA, c(n_files * n_points, 4, 3))
  
  ### read LR/HR image pairs
  for(i in 1:n_files){
    imgLR <- readImage(paste0(LR_dir,  "img_", sprintf("%04d", i), ".jpg"))
    imgHR <- readImage(paste0(HR_dir,  "img_", sprintf("%04d", i), ".jpg"))

    ### step 1. sample n_points from imgLR

        ### step 2. for each sampled point in imgLR,
    
        ### step 2.1. save (the neighbor 8 pixels - central pixel) in featMat
        ###           tips: padding zeros for boundary points
    
        ### step 2.2. save the corresponding 4 sub-pixels of imgHR in labMat
    
    ### step 3. repeat above for three channels
    n_row <- dim(imgLR)[1]
    n_col <- dim(imgLR)[2]
    imgLR_padding <- array(0, dim(imgLR) + c(2,2,0))
    imgLR_padding[1:n_row + 1, 1:n_col + 1, ] <- imgLR
    
    n_row_padding <- n_row + 2
    n_col_padding <- n_col + 2
    ind_row_padding <- c(rep(1, n_col_padding), rep(2:(n_row_padding-1), each=2), rep(n_row_padding, n_col_padding))
    ind_col_padding <- c(1:n_col_padding, rep(c(1, n_col_padding), n_row), 1:n_col_padding)
    ind_padding <- ind_row_padding + (ind_col_padding - 1) * n_row_padding
    
    ind_all <- 1:(n_row_padding * n_col_padding)
    ind_origin <- setdiff(ind_all, ind_padding)
    
    for(channel in 1:3){

      samp_ind <- sample(ind_origin, n_points)
      
      ## X3  X2  x1
      ## x4  ct  x8
      ## x5  x6  x7
      x1_ind <- samp_ind - 1 + n_row_padding
      x2_ind <- samp_ind - 1
      x3_ind <- samp_ind - 1 - n_row_padding
      x4_ind <- samp_ind - n_row_padding
      x5_ind <- samp_ind + 1 - n_row_padding
      x6_ind <- samp_ind + 1
      x7_ind <- samp_ind + 1 + n_row_padding
      x8_ind <- samp_ind + n_row_padding
      samplesLR <- imgLR_padding[,, channel][c(samp_ind, x1_ind, x2_ind, x3_ind, x4_ind, x5_ind, x6_ind, x7_ind, x8_ind)]
      samplesLR.mat <- matrix(samplesLR, nrow=n_points)
      X <- samplesLR.mat[,-1] - samplesLR.mat[,1]
      
      ## y2  y1
      ## y3  y4
      samp_ind_LR <- convertInd2RowCol(samp_ind, n_row_padding, n_col_padding) - 1
      samp_ind_HR <- 2*samp_ind_LR
      y1_ind_row <- samp_ind_HR[,1] - 1
      y1_ind_col <- samp_ind_HR[,2]
      y1_ind <- convertRowCol2Ind(y1_ind_row, y1_ind_col, 2*n_row, 2*n_col)
      y2_ind_row <- samp_ind_HR[,1] - 1
      y2_ind_col <- samp_ind_HR[,2] - 1
      y2_ind <- convertRowCol2Ind(y2_ind_row, y2_ind_col, 2*n_row, 2*n_col)
      y3_ind_row <- samp_ind_HR[,1] 
      y3_ind_col <- samp_ind_HR[,2] - 1
      y3_ind <- convertRowCol2Ind(y3_ind_row, y3_ind_col, 2*n_row, 2*n_col)
      y4_ind_row <- samp_ind_HR[,1] 
      y4_ind_col <- samp_ind_HR[,2]
      y4_ind <- convertRowCol2Ind(y4_ind_row, y4_ind_col, 2*n_row, 2*n_col)
      samplesHR <- imgHR[,, channel][c(y1_ind, y2_ind, y3_ind, y4_ind)]
      samplesHR.mat <- matrix(samplesHR, nrow=n_points)
      Y <- samplesHR.mat - samplesLR.mat[,1]
      
      # for(j in 1:n_points){ ## slow loop
      #   samp_ind_row <- ifelse(samp_ind[j] %% n_row ==0, n_row, samp_ind[j] %% n_row)
      #   samp_ind_col <- ifelse(samp_ind[j] %% n_row ==0, samp_ind[j] %/% n_row, samp_ind[j] %/% n_row + 1)
      #   feat <- imgLR_padding[0:2 + samp_ind_row, 0:2 + samp_ind_col, channel]
      #   lab <- imgHR[2*samp_ind_row + c(-1,0), 2*samp_ind_col + c(-1,0), channel]
      #   
      #   featMat[(i-1)*n_points + j, , channel] <- as.vector(feat - feat[2,2])[-5]
      #   labMat[(i-1)*n_points + j, , channel] <- as.vector(lab - feat[2,2])
      #   
      # }
      
      ## X3  X2  x1
      ## x4  ct  x8
      ## x5  x6  x7
      # samp_ind_row <- ifelse(samp_ind %% n_row ==0, n_row, samp_ind %% n_row)
      # samp_ind_col <- ifelse(samp_ind %% n_row ==0, samp_ind %/% n_row, samp_ind %/% n_row + 1)
      # x1_ind_row <- x2_ind_row <- x3_ind_row <- samp_ind_row - 1
      # x5_ind_row <- x6_ind_row <- x7_ind_row <- samp_ind_row + 1
      # x4_ind_row <- x8_ind_row <- samp_ind_row 
      # x1_ind_col <- x8_ind_col <- x7_ind_col <- samp_ind_col + 1
      # x3_ind_col <- x4_ind_col <- x5_ind_col <- samp_ind_col - 1
      # x2_ind_col <- x6_ind_col <- samp_ind_col 
      # 
      # x1 <- apply(cbind(x1_ind_row, x1_ind_col), 1, function(ind) imgLR_padding[ind[1]+1, ind[2]+1, channel] )
      # x2 <- apply(cbind(x2_ind_row, x2_ind_col), 1, function(ind) imgLR_padding[ind[1]+1, ind[2]+1, channel] )
      # x3 <- apply(cbind(x3_ind_row, x3_ind_col), 1, function(ind) imgLR_padding[ind[1]+1, ind[2]+1, channel] )
      # x4 <- apply(cbind(x4_ind_row, x4_ind_col), 1, function(ind) imgLR_padding[ind[1]+1, ind[2]+1, channel] )
      # x5 <- apply(cbind(x5_ind_row, x5_ind_col), 1, function(ind) imgLR_padding[ind[1]+1, ind[2]+1, channel] )
      # x6 <- apply(cbind(x6_ind_row, x6_ind_col), 1, function(ind) imgLR_padding[ind[1]+1, ind[2]+1, channel] )
      # x7 <- apply(cbind(x7_ind_row, x7_ind_col), 1, function(ind) imgLR_padding[ind[1]+1, ind[2]+1, channel] )
      # x8 <- apply(cbind(x8_ind_row, x8_ind_col), 1, function(ind) imgLR_padding[ind[1]+1, ind[2]+1, channel] )
      # xct <- apply(cbind(samp_ind_row, samp_ind_col), 1, function(ind) imgLR_padding[ind[1]+1, ind[2]+1, channel] )
      # ## y2  y1
      # ## y3  y4
      # y1_ind_row <- y2_ind_row <- 2*samp_ind_row - 1
      # y3_ind_row <- y4_ind_row <- 2*samp_ind_row 
      # y1_ind_col <- y4_ind_col <- 2*samp_ind_col 
      # y2_ind_col <- y3_ind_col <- 2*samp_ind_col - 1
      # y1 <- apply(cbind(y1_ind_row, y1_ind_col), 1, function(ind) imgHR[ind[1], ind[2], channel] )
      # y2 <- apply(cbind(y2_ind_row, y2_ind_col), 1, function(ind) imgHR[ind[1], ind[2], channel] )
      # y3 <- apply(cbind(y3_ind_row, y3_ind_col), 1, function(ind) imgHR[ind[1], ind[2], channel] )
      # y4 <- apply(cbind(y4_ind_row, y4_ind_col), 1, function(ind) imgHR[ind[1], ind[2], channel] )
      # 
      
      featMat[(i-1)*n_points + 1:n_points, , channel] <- X
      labMat[(i-1)*n_points + 1:n_points, , channel] <- Y
    }
    
    
    
  }
  return(list(feature = featMat, label = labMat))
}

getArrayElement <- Vectorize(
  function(array, x,y,z){
    array[x,y,z]
  }, vectorize.args = c("x", "y"))

convertRowCol2Ind <- function(ind_row, ind_col, nrow, ncol){
  ind <- ind_row + (ind_col -1) * nrow
  return(ind)
}

convertInd2RowCol <- function(ind, nrow, ncol){
  ind_row <- ifelse(ind %% nrow ==0, nrow, ind %% nrow)
  ind_col <- ifelse(ind %% nrow ==0, ind %/% nrow, ind %/% nrow + 1)
  return(cbind(ind_row, ind_col))
  
}
