## --------------------------------------------------------------------------------------##
##
## Script name: download_wepp_prep_details_zip.R
##
## Purpose of the script: Downloads the wepp prep zip folder
##
## Author: Chinmay Deval
##
## Created On: 2020-11-02
##
## Copyright (c) Chinmay Deval, 2020
## Email: chinmay.deval91@gmail.com
##
## --------------------------------------------------------------------------------------##
##  Notes: Before running:
##         1. Update the location where files should be downloaded on line 30
##         2. Add/update projects in the proj_urls list starting at line 33. 
##   
##
## --------------------------------------------------------------------------------------##

## --------------------------clear environment and console-------------------------------##
rm(list = ls())
cat("\014")

## ----------------------------------Load packages---------------------------------------##

library(tidyverse)
library(stringr)

## ------------------------------------Urls and save directory--------------------------------------------------##
save_loc <- "C:/Users/Chinmay/Desktop/"

proj_urls <- c("https://wepp1.nkn.uidaho.edu/weppcloud/runs/dogmatic-clevis/baer/export/prep_details/",
                "https://wepp1.nkn.uidaho.edu/weppcloud/runs/entrepreneurial-sociobiology/baer/export/prep_details/",
                "https://wepp1.nkn.uidaho.edu/weppcloud/runs/untied-armament/baer/export/prep_details/",
                "https://wepp1.nkn.uidaho.edu/weppcloud/runs/unreal-episcopacy/baer/export/prep_details/",
                "https://wepp1.nkn.uidaho.edu/weppcloud/runs/knock-kneed-prosthetics/baer/export/prep_details/")

## ------------------------------------func defintion--------------------------------------------------##

get_wepp_prep_zip <- function(url, saveLoc){
  
  name<- str_split(url, "/")[[1]][6]
  
  download.file(url, destfile = paste0(saveLoc, str_split(url, "/")[[1]][6], ".zip"), mode = "wb")
}

## --------------------------------------download------------------------------------------------##

lapply(proj_urls, get_wepp_prep_zip, saveLoc = save_loc)
