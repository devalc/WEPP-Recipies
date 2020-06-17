## --------------------------------------------------------------------------------------##
##
## Script name: merge_shps
##
## Purpose of the script: Merge all (files downloaded from WEPPcloud) subcatchment shapefiles into one and all channel shps into
##                        one. Also splits column named watershed in the original files
##                        column watershed into watershed and scenarios for easy handling on
##                        viz-WEPPcloud
##
## Author: Chinmay Deval
##
## Created On: 2020-04-17
##
## Copyright (c) Chinmay Deval, 2020
## Email: chinmay.deval91@gmail.com
##
## --------------------------------------------------------------------------------------##
##    Notes:
##   
##
## --------------------------------------------------------------------------------------##

## --------------------------clear environment and console-------------------------------##
rm(list = ls())
cat("\014")

## ----------------------------------Load packages---------------------------------------##

library(sf)
library(tidyverse)

path = "C:/Users/Chinmay/Downloads/data_shps_04_27_2020/lt2020_6_shps/"

file_list <- list.files(path, pattern = "*_subcatchments.shp", full.names = TRUE)

shapefile_list <- lapply(file_list, st_read)

Allshps_strsplt<- do.call(rbind, shapefile_list) %>%st_as_sf() %>%
  st_transform(4326) 


Allshps_strsplt$Str1 = sapply(strsplit(as.character(Allshps_strsplt$watershed), "_"), `[`, 1)
Allshps_strsplt$Str2 = sapply(strsplit(as.character(Allshps_strsplt$watershed), "_"), `[`, 2)
Allshps_strsplt$Str3 = sapply(strsplit(as.character(Allshps_strsplt$watershed), "_"), `[`, 3)
Allshps_strsplt$Str4 = sapply(strsplit(as.character(Allshps_strsplt$watershed), "_"), `[`, 4)
Allshps_strsplt$Str5 = sapply(strsplit(as.character(Allshps_strsplt$watershed), "_"), `[`, 5)
Allshps_strsplt<- Allshps_strsplt %>% dplyr::select(-watershed)
Allshps_strsplt$watershed <- with(Allshps_strsplt, paste(Str1,"_", Str2,"_",Str3))
Allshps_strsplt$Watershed <- with(Allshps_strsplt, if_else(nchar(Str4)<15, paste(watershed,"_",Str4), watershed))
Allshps_strsplt$Scenario <-  with(Allshps_strsplt, if_else(nchar(Str4)>15,Str4,Str5))

Allshps_strsplt <- Allshps_strsplt %>% dplyr::select(-watershed,-Str1,-Str2,-Str3,-Str4,-Str5)

write_sf(Allshps_strsplt, "C:/Users/Chinmay/Downloads/data_shps_04_27_2020/lt2020_6_shps/lt2020_6_subcatchments_wgs84_split_wshed_and_scen.shp")
write_rds(Allshps_strsplt, "C:/Users/Chinmay/Downloads/data_shps_04_27_2020/lt2020_6_shps/lt2020_6_subcatchments_wgs84_split_wshed_and_scen.rds")

################ Channel files

file_list_chn <- list.files(path, pattern = "*_channels.shp", full.names = TRUE)

chan_shapefile_list <- lapply(file_list_chn, st_read)

chan_Allshps_strsplt<- do.call(rbind, chan_shapefile_list) %>%st_as_sf() %>%
  st_transform(4326) 

chan_Allshps_strsplt$Str1 = sapply(strsplit(as.character(chan_Allshps_strsplt$watershed), "_"), `[`, 1)
chan_Allshps_strsplt$Str2 = sapply(strsplit(as.character(chan_Allshps_strsplt$watershed), "_"), `[`, 2)
chan_Allshps_strsplt$Str3 = sapply(strsplit(as.character(chan_Allshps_strsplt$watershed), "_"), `[`, 3)
chan_Allshps_strsplt$Str4 = sapply(strsplit(as.character(chan_Allshps_strsplt$watershed), "_"), `[`, 4)
chan_Allshps_strsplt$Str5 = sapply(strsplit(as.character(chan_Allshps_strsplt$watershed), "_"), `[`, 5)
chan_Allshps_strsplt<- chan_Allshps_strsplt %>% dplyr::select(-watershed)
chan_Allshps_strsplt$watershed <- with(chan_Allshps_strsplt, paste(Str1,"_", Str2,"_",Str3))
chan_Allshps_strsplt$Watershed <- with(chan_Allshps_strsplt, if_else(nchar(Str4)<15, paste(watershed,"_",Str4), watershed))
chan_Allshps_strsplt$Scenario <-  with(chan_Allshps_strsplt, if_else(nchar(Str4)>15,Str4,Str5))


chan_Allshps_strsplt <- chan_Allshps_strsplt %>% dplyr::select(-watershed,-Str1,-Str2,-Str3,-Str4,-Str5)

write_sf(Allshps_strsplt, "C:/Users/Chinmay/Downloads/data_shps_04_27_2020/lt2020_6_shps/lt2020_6_channels_wgs84_split_wshed_and_scen.shp")
write_rds(Allshps_strsplt, "C:/Users/Chinmay/Downloads/data_shps_04_27_2020/lt2020_6_shps/lt2020_6_channels_wgs84_split_wshed_and_scen.rds")

