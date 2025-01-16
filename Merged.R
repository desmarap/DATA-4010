library(lidR)
las_file1<- "C:/Users/garoa/Desktop/Data 4010/F_240717_1_RGBPC_cropped.las"
las_data1<-readLAS(las_file1)

las_file2<- "C:/Users/garoa/Desktop/Data 4010/F_240717_1_MSPC_cropped.las"
las_data2<-readLAS(las_file2)

RGB_cloud_data <- las_data1@data
MSPC_cloud_data<- las_data2@data

library(dplyr)
RGB_cloud_data <-  RGB_cloud_data %>% select(-"normal z", -"normal x", -"normal y",-"confidence" )

MSPC_cloud_data <- MSPC_cloud_data %>% select(-"normal z", -"normal x", -"normal y",-"confidence" )


rgb_coords <- as.matrix(RGB_cloud_data[, c("X", "Y", "Z")])
ms_coords <- as.matrix(MSPC_cloud_data[, c("X", "Y", "Z")])

library(FNN)

nn_result <- get.knnx(rgb_coords, ms_coords, k = 1)
nn_indices <- nn_result$nn.index
nn_distances <- nn_result$nn.dist
dist_threshold <- 1

RGB_cloud_data$R_MS <- 0
RGB_cloud_data$G_MS <- 0
RGB_cloud_data$B_MS <- 0
RGB_cloud_data$NIR <- 0



matched <- nn_distances <= dist_threshold
RGB_cloud_data$R_MS[matched] <- MSPC_cloud_data$R[nn_indices[matched]]
RGB_cloud_data$G_MS[matched] <- MSPC_cloud_data$G[nn_indices[matched]]
RGB_cloud_data$B_MS[matched] <- MSPC_cloud_data$B[nn_indices[matched]]
RGB_cloud_data$NIR[matched] <- MSPC_cloud_data$NIR[nn_indices[matched]]

merged_data<-RGB_cloud_data


merged_data[is.na(merged_data)] <- 0

merged_data$NIR<-as.integer(merged_data$NIR)
merged_data$R<-as.integer(merged_data$R)
merged_data$G<-as.integer(merged_data$G)
merged_data$B<-as.integer(merged_data$B)


library(lidR)

new_las<-LAS(merged_data)

projection(new_las) <- 4326

writeLAS(new_las, "merged_rgb_cloud.las")










#las <- las_data



#dtm <- rasterize_terrain(las, algorithm = tin())
#ttops <- locate_trees(las, lmf(ws = 5))

#plot_dtm3d(dtm)

#x <- plot(las)
#add_dtm3d(x, dtm)
#add_treetops3d(x, ttops)

#plot(las) #|> add_dtm3d(dtm) |> add_treetops3d(ttops)

