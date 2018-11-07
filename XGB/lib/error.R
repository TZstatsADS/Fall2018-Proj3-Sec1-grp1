

error<- functino(b, e, model, LR_dir, HR_dir){
  library("EBImage")
  n<- 1:1500
  n_v<- n[-c(b:e)]
  for (i in n_v){
    imgLR <- readImage(paste0(LR_dir,  "img_", sprintf("%04d", i), ".jpg"))
    imgHR <- readImage(paste0(HR_dir,  "img_", sprintf("%04d", i), ".jpg"))
  }
  
}
