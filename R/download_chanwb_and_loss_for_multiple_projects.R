## --------------------------------------------------------------------------------------##
##
## Script name: download_chanwb_and_loss_for_multiple_projects.R
##
## Purpose of the script: Downloads the loss_pw0.txt and chanwb.out file for all
##  given weppcloud projects. Customised to joh projs
##
## Author: Chinmay Deval
##
## Created On: 2021-05-19
##
## Copyright (c) Chinmay Deval, 2021
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
library(stringr)

## ------------------------------------Urls and save directory--------------------------------------------------##

save_dir <- "D:/Chinmay/storagetemp/JOH_MD_onedrive/Data/WEPPResults/test/"

dir.create(paste0(save_dir, "BullRun"),showWarnings = FALSE)
dir.create(paste0(save_dir, "LakeTahoe"),showWarnings = FALSE)
dir.create(paste0(save_dir, "MicaCreek"),showWarnings = FALSE)
dir.create(paste0(save_dir, "Seattle"),showWarnings = FALSE)

lt_out_dir<- paste0(save_dir, "LakeTahoe")
bull_out_dir<- paste0(save_dir, "BullRun")
mcew_out_dir<- paste0(save_dir, "MicaCreek")
seattle_out_dir<- paste0(save_dir, "Seattle")

## --------------------------------------------------------------------------------------##

lt_proj_url <- c("https://wepp.cloud/weppcloud/runs/lt_202012_40_Edgewood_Creek_CurCond/",
               "https://wepp.cloud/weppcloud/runs/lt_202012_43_Trout_Creek_CurCond/",
               "https://wepp.cloud/weppcloud/runs/lt_202012_43_Trout_Creek_TC2_CurCond/",
               "https://wepp.cloud/weppcloud/runs/lt_202012_43_Trout_Creek_TC3_CurCond/",
               "https://wepp.cloud/weppcloud/runs/lt_202012_44_Upper_Truckee_River_Big_Meadow_Creek_CurCond/",
               "https://wepp.cloud/weppcloud/runs/lt_202012_44_Upper_Truckee_River_UT3_CurCond/",
               "https://wepp.cloud/weppcloud/runs/lt_202012_44_Upper_Truckee_River_UT5_CurCond/",
               "https://wepp.cloud/weppcloud/runs/lt_202012_56_General_Creek_CurCond/",
               "https://wepp.cloud/weppcloud/runs/lt_202012_62_Blackwood_Creek_CurCond/",
               "https://wepp.cloud/weppcloud/runs/lt_202012_63_Ward_Creek_CurCond/",
               "https://wepp.cloud/weppcloud/runs/lt_202012_63_Ward_Creek_WC3A_CurCond/",
               "https://wepp.cloud/weppcloud/runs/lt_202012_63_Ward_Creek_WC7A_CurCond/",
               "https://wepp.cloud/weppcloud/runs/lt_202012_18_Third_Creek_CurCond/",
               "https://wepp.cloud/weppcloud/runs/lt_202012_19_Incline_Creek_CurCond/",
               "https://wepp.cloud/weppcloud/runs/lt_202012_19_Incline_Creek_IN2_CurCond/",
               "https://wepp.cloud/weppcloud/runs/lt_202012_19_Incline_Creek_IN3_CurCond/",
               "https://wepp.cloud/weppcloud/runs/lt_202012_29_Glenbrook_Creek_CurCond/",
               "https://wepp.cloud/weppcloud/runs/lt_202012_31_Logan_House_Creek_CurCond/"
               )
  
  
lt_ext <- "lt-wepp_bd16b69-snow/browse/wepp/output/"

## --------------------------------------------------------------------------------------##

# bull_proj_urls <- c("https://wepp.cloud/weppcloud/runs/portland_CedarCreek_CurCond.202009.cl532_gridmet.chn_cs150/",
#                     "https://wepp.cloud/weppcloud/runs/portland_FirCreek_CurCond.202009.cl532_gridmet.chn_cs150/",
#                     "https://wepp.cloud/weppcloud/runs/portland_LittleSandy_CurCond.202009.cl532_gridmet.chn_cs110/",
#                     "https://wepp.cloud/weppcloud/runs/portland_NorthFork_CurCond.202009.cl532_gridmet.chn_cs140/",
#                     "https://wepp.cloud/weppcloud/runs/portland_SouthFork_CurCond.202009.cl532_gridmet.chn_cs160/",
#                     "https://wepp.cloud/weppcloud/runs/portland_BlazedAlder_CurCond.202009.cl532_gridmet.chn_cs50/",
#                     "https://wepp.cloud/weppcloud/runs/portland_BRnearMultnoma_CurCond.202009.cl532_gridmet.chn_cs200/")

# bull_ext <- ""

## --------------------------------------------------------------------------------------##
seattle_proj_url <- c("https://wepp.cloud/weppcloud/runs/seattle_k_Cedar_River_CurCond.202009.cl532_gridmet.chn_cs200/",
                      "https://wepp.cloud/weppcloud/runs/seattle_k_Taylor_Creek_CurCond.202009.cl532_gridmet.chn_cs100/")


seattle_ext <- "seattle-snow/browse/wepp/output/"

## --------------------------------------------------------------------------------------##

mcew_proj_url <- c("https://wepp.cloud/weppcloud/runs/occluded-bankroll/13/",
                   "https://wepp.cloud/weppcloud/runs/srivas42-legged-make-believe/0/")



mcew_ext <- "browse/wepp/output/"

## ------------------------------------func defintion--------------------------------------------------##


get_loss_and_chanwb <- function(url, url_second_half, out_dir){
  
  wshed_name <- stringr::str_split(url, "/")[[1]][6]
  
  dir.create(paste0(out_dir, "/", wshed_name, "/", "interface"),showWarnings = FALSE, recursive = TRUE)
  
  chanwb_dwld_path <- paste0(url, url_second_half, "chanwb.out")
  loss_dwld_path <- paste0(url, url_second_half, "loss_pw0.txt")
  
  # print(dwld_path)
  download.file(chanwb_dwld_path, destfile = paste0(out_dir, "/", wshed_name, "/", "interface", "/", "chanwb.out") , mode = "wb")
  download.file(loss_dwld_path, destfile = paste0(out_dir, "/", wshed_name, "/", "interface", "/", "loss_pw0.txt") , mode = "wb")
  download.file(loss_dwld_path, destfile = paste0(out_dir, "/", wshed_name, "/", "interface", "/", "ebe_pw0.txt") , mode = "wb")
}


## --------------------------------------download------------------------------------------------##

lapply(lt_proj_url, get_loss_and_chanwb, url_second_half = lt_ext, out_dir = lt_out_dir )
# lapply(bull_proj_urls, get_loss_and_chanwb, url_second_half = bull_ext, out_dir = bull_out_dir )
lapply(mcew_proj_url, get_loss_and_chanwb, url_second_half = mcew_ext, out_dir = mcew_out_dir )
lapply(seattle_proj_url, get_loss_and_chanwb, url_second_half = seattle_ext, out_dir = seattle_out_dir )
