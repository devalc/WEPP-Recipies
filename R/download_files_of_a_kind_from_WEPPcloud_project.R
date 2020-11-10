## --------------------------------------------------------------------------------------##
##
## Script name: download_files_of_a_kind_from_WEPPcloud_project.R
##
## Purpose of the script: Downloads files with specific extensions from 
## weppcloud from multiple watersheds and scenarios. In this case soils file are
## downloaded. 
##
## Author: Chinmay Deval
##
## Created On: 2020-11-09
##
## Copyright (c) Chinmay Deval, 2020
## Email: chinmay.deval91@gmail.com
##
## --------------------------------------------------------------------------------------##
##  Notes: Works for LT projects on WEPPcloud. May need some alterations (making sure URLs
##  are pointing to the correct location) for other projects. 
##   
##
## --------------------------------------------------------------------------------------##

## --------------------------clear environment and console-------------------------------##
rm(list = ls())
cat("\014")

## ----------------------------------Load packages---------------------------------------##
library(tidyverse)
library(rvest)
library(stringr)
library(xml2)


## --------------------------------------------------------------------------------------##

watersheds<- c("0_Near_Burton_Creek", "10_Intervening_Area_Agate_Bay", "10_Snow_Creek",
           "11_Griff_Creek", "12_Baldy_Creek" ,"12_Intervening_Area_Griff_to_Baldy",
           "13_East_Stateline_Point", "14_First_Creek", "15_Second_Creek",
           "16_Intervening_Area_Second_to_Wood", "17_Wood_Creek", "18_Third_Creek",
           "19_Incline_Creek", "1_Unnamed_Creek_at_Tahoe_City_State_Park",  "20_Mill_Creek",
           "21_Tunnel_Creek", "22_Unnamed_creek_at_Sand_Harbor", "23_Intervening_Area_Sand_Harbor_1",
           "23_Intervening_Area_Sand_Harbor_2", "23_Intervening_Area_Sand_Harbor_3",
           "23_Intervening_Area_Sand_Harbor_4", "24_Marlette_Creek", 
           "25_Intervening_Area_Marlette_to_Secret_Harbor",
           "25_Secret_Harbor_Creek", "26_Bliss_Creek", "27_Intervening_Area_Deadman_Point",
           "28_Slaughterhouse_Creek","29_Glenbrook_Creek",
           "29_Intervening_Area_Glenbrook_Bay_1", "29_Intervening_Area_Glenbrook_Bay_2",
           "2_Burton_Creek", "30_North_Logan_House_Creek","31_Logan_House_Creek",
           "32_Cave_Rock_Unnamed_Creek_at_Lincoln_Park", "32_Intervening_Area_Logan_Shoals_1",
           "32_Intervening_Area_Logan_Shoals_2", "33_Lincoln_Creek",
           "35_North_Zephyr_Creek" , "37_Zephyr_Creek","38_McFaul_Creek",
           "39_Burke_Creek", "3_Unnamed_Creek_near_Lake_Forest", "40_Edgewood_Creek",
           "41_Intervening_Area_Bijou_Park_1",
           "41_Intervening_Area_Bijou_Park_2","42_Bijou_Creek" , "43_Trout_Creek",
           "44_Upper_Truckee_River_Big_Meadow_Creek", "46_Taylor_Creek","47_Tallac_Creek",
           "48_Cascade_Creek", "49_Eagle_Creek", "4_Unnamed_Creek_at_Lake_Forest", "51_Rubicon_Creek_1",
           "51_Rubicon_Creek_2","52_Paradise_Flat" ,"53_Lonely_Gulch" ,"54_Sierra_Creek",
           "55_Meeks_Creek", "56_General_Creek", "57_McKinney_Creek", "5_Dollar_Creek",
           "62_Blackwood_Creek","63_Intervening_Area_Ward_Creek", "63_Ward_Creek",
           "6_Intervening_Area_Cedar_Flat", "6_Unnamed_Creek_at_Cedar_Flat", "7_Watson_Creek",
           "8_Carnelian_Bay_Creek", "9_Carnelian_Creek", "9_Intervening_Area_Carnelian_Bay_1",
           "9_Intervening_Area_Carnelian_Bay_2")


scenarios<- c("CurCond",
             "HighSev",
             "LowSev",
             "ModSev",
             "PrescFire",
             "SimFire.fccsFuels_obs_cli",
             "SimFire.landisFuels_fut_cli_A2",
             "SimFire.landisFuels_obs_cli",
             "Thinn85",
             "Thinn93",
             "Thinn96")


download_files_with_specific_extentions_from_WEPPcloud <- function(proj_URL, 
                                                                   wshed_Name, 
                                                                   scen_Name,
                                                                   save_loc,
                                                                   ext) {
  for (w in wshed_Name) {
    dir.create(paste0(save_loc,w),showWarnings = FALSE)
    for (s in scen_Name) {
      dir.create(paste0(save_loc,w,"/",s),showWarnings = FALSE)
      
      full_url <- paste0(proj_URL,"_", w,"_",s,
                         "/lt-wepp_bd16b69-snow/browse/wepp/runs/")
      

      dest_fol <- paste0(save_loc,w,"/",s)
      

      pagescrape <- xml2::read_html(full_url)
      
      
      
      soils_list<- pagescrape %>%
        rvest::html_nodes("a") %>%       
        rvest::html_attr("href") %>%     
        stringr::str_subset(paste0("\\",ext)) ### soil files in this case

      
      #download all files (may be lapply instead of for here would be good)
      for ( ifile in soils_list){
        print(paste0(dest_fol,ifile))
        download.file(paste0(full_url,ifile), destfile=paste0(dest_fol,"/",ifile), mode = "wb")
      }
     
    }
    
  }
  
  
}

download_files_with_specific_extentions_from_WEPPcloud("https://wepp1.nkn.uidaho.edu/weppcloud/runs/lt_202010",
                                                       watersheds,
                                                       scenarios,
                                                       "D:/OneDrive - University of Idaho/lt_runs_soils_11_09_2020/",
                                                       ext = ".sol")
