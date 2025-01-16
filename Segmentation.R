library(lidR)
las_file1<- "C:/Users/garoa/Desktop/Data 4010/F_240717_1_RGBPC_cropped.las"
las_data1<-readLAS(las_file1)

las_file2<- "C:/Users/garoa/Desktop/Data 4010/F_240717_1_MSPC_cropped.las"
las_data2<-readLAS(las_file2)

RGB_cloud_data <- las_data1
MSPC_cloud_data<- las_data2@data

library(dplyr)
#RGB_cloud_data <-  RGB_cloud_data %>% select(-"normal z", -"normal x", -"normal y",-"confidence" )

#MSPC_cloud_data <- MSPC_cloud_data %>% select(-"normal z", -"normal x", -"normal y",-"confidence" )


library(lidR)

dtm<- rasterize_terrain(RGB_cloud_data, res=1, algorithm = knnidw())


RGB_normalized<- normalize_height(RGB_cloud_data, dtm)
RGB_normalized<-add_attribute(RGB_normalized,1,"treeID")
chm <- rasterize_canopy(RGB_normalized, res = 0.5, algorithm = p2r())


tree_segments <- segment_trees(RGB_normalized, watershed(chm))


#segmented_RGB<-LAS(RGB_cloud_data)

#projection(new_RGB) <- 4326

writeLAS(tree_segments, "segmented_RGB.las")