library(lidR)
las_file1<- "C:/Users/garoa/Desktop/Data 4010/F_240717_1_RGBPC_cropped.las"
RGB_cloud_data <-readLAS(las_file1)


RGB_cloud_data <- las_data1

library(dplyr)
library(lidR)

dtm<- rasterize_terrain(RGB_cloud_data, res=1, algorithm = knnidw())


RGB_normalized<- normalize_height(RGB_cloud_data, dtm)

### try and compare p2r vs. dsmtin or pitfree 
chm_1 <- rasterize_canopy(RGB_normalized, res = 0.5, algorithm = p2r())
chm_2 <- rasterize_canopy(RGB_normalized, res = 0.5, pitfree(c(0,2,5,10,15), c(0, 1.5)))
chm_3 <- rasterize_canopy(las, res = 0.5, dsmtin())

tree_segments_1 <- segment_trees(RGB_normalized, watershed(chm_1))
tree_segments_2 <- segment_trees(RGB_normalized, watershed(chm_2))
tree_segments_3 <- segment_trees(RGB_normalized, watershed(chm_3))

## p2r and pitfree give almost the same result. dsmtin gives worse looking segmentation. So I will use only p2r going forward.

## (Lu comment) try segment_shapes(), segment_snags() 

writeLAS(tree_segments_1, "segmented_RGB.las")

tree_only<- filter_poi(tree_segments, !is.na(treeID) & treeID > 0)
writeLAS(tree_only, "trees_RGB.las") # Visualize thia one in cloudcompare

#Experimentation below

IDs <- unique(tree_only@data$treeID)

for (i in 1:length(IDs)) {
  
  
  tree <- filter_poi(tree_segments, !is.na(treeID) & treeID == IDs[i])
  writeLAS(tree, paste0("C:\\Users\\garoa\\Documents\\trees_nursery\\tree_", toString(i))) 
  
}


plot(tree, color="normal z")
