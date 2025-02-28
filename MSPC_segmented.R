library(lidR)
library(dplyr)

las_file2<- "C:/Users/garoa/Desktop/Data 4010/F_240717_1_MSPC_cropped.las"
MSPC_cloud_data<-readLAS(las_file2)


NDVI_values<-(MSPC_cloud_data$NIR - MSPC_cloud_data$R)/(MSPC_cloud_data$NIR+MSPC_cloud_data$R)

MSPC_cloud_data<- add_attribute(MSPC_cloud_data, NDVI_values, "NDVI")

veg_only<-filter_poi(MSPC_cloud_data, NDVI > 0.4)

#plot(veg_only, color="NDVI")


dtm<- rasterize_terrain(MSPC_cloud_data, res=1, algorithm = knnidw())


RGB_normalized<- normalize_height(veg_only, dtm)


chm <- rasterize_canopy(veg_only, res = 0.5, algorithm = p2r())


tree_segments <- segment_trees(veg_only, watershed(chm))
