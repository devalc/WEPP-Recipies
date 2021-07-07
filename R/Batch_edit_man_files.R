## --------------------------------------------------------------------------------------##
##
## Script name: batch edit management file parameters ( Biomass energy ratio and 
##              decomposition constants)
## 
## Purpose of the script: Batch_edit_man_files.R
##
## Author: Chinmay Deval
##
## Created On: 2020-05-14
##
## Copyright (c) Chinmay Deval, 2020
## Email: chinmay.deval91@gmail.com
##
## --------------------------------------------------------------------------------------##
##  Notes:
##   
##
## --------------------------------------------------------------------------------------##

## --------------------------clear environment and console-------------------------------##
rm(list = ls())
cat("\014")


## ----------------------------------Load packages---------------------------------------##
library(tidyverse)
library(stringr)


## --------------------------------------------------------------------------------------##

dir_with_man_files<-"C:/Chinmay/wepp_qw/Blackwood_creek/Blackwood_24_06_2021/WEPPDesktopRun_WQ/runs/"
dir_to_write_new_man_files<- "C:/Chinmay/wepp_qw/Blackwood_creek/Blackwood_24_06_2021/WEPPDesktopRun_WQ/runs/man_files_with_updated_veg_par"

dir.create(dir_to_write_new_man_files,showWarnings = FALSE)

## --------------------------------------------------------------------------------------##

lst <- list.files(path = dir_with_man_files,
                  pattern = "\\.man$",full.names =  TRUE)
# a <- readLines("C:/Chinmay/wepp_qw/Blackwood_creek/Blackwood_24_06_2021/WEPPDesktopRun_WQ/runs/p1.man")

for (i in lst) {
    fname <- stringr::str_split(i,pattern = "/")[[1]][8]
    a <- readLines(i)
    # print(a[15])
    # print(a[18])
    a[15]<- stringr::str_replace(a[15],pattern = "0.00000",replacement = "15.00000")
    a[18] <- stringr::str_replace(a[18],pattern = "0.00000",replacement = "0.006") %>% stringr::str_replace(pattern = "0.00000",replacement = "0.006")
    a[72] <- stringr::str_replace(a[72],pattern = "   0",replacement = "   300")
    # print(a[15])
    # print(a[18])
    writeLines(a, paste0(dir_to_write_new_man_files,"/", fname))
}
