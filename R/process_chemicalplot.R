## --------------------------------------------------------------------------------------##
##
## Script name: process_chemicalplot.R
##
## Purpose of the script: Gets N and P from chemicalplot file for each hillslope and 
##                  adds hillslope ID as well as hillslope area (grabbed from
##                  watershed pass file and exports each processed hillslope files
##                  into its own csv flat for further calculations. 
##
## Author: Chinmay Deval
##
## Created On: 2020-06-24
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

library(readxl)
library(stringr)
library(dplyr)
library(tidyverse)
library(WEPPRecipes)

## ------------------------------------Initialize--------------------------------------------------##
### for getting areas
pass_path <- "D:\\Chinmay\\storagetemp\\3_hillslopes\\R_3HS_wq_automation\\WEPPDesktopRun_WQ\\output\\pass_pw0.txt"
loss_path <- "D:\\Chinmay\\storagetemp\\3_hillslopes\\R_3HS_wq_automation\\WEPPDesktopRun_WQ\\output\\loss_pw0.txt"
Number_of_Hillslopes <- 3

## for processing individual chemicalplot files

#WEPP simulation output folder
wepp_outputs_Dir<- "D:/Chinmay/storagetemp/Blackwood_05_24_2020/test_script_like_totwatsed_but_for_nutrients" 
number_of_hillslopes_simulated <- 3
SimStartDate <- "1990-01-01"
SimEndDate <-"2014-12-31"

## ----------------------------------function to extract hillslope areas(ha) from pass fileto a df---------------------------------------##


get_hillslope_area <- function(pass_file_path, Number_of_Hillslopes_simulated){
  b<- read.table(pass_file_path, skip = 11, nrows = Number_of_Hillslopes_simulated)
  b <- b %>% mutate(Hillslope = paste(V1, V2, sep="")) %>%
    mutate(Area_ha = V9*0.0001,
           Hillslope = tolower(Hillslope)) %>%
    select(Hillslope, Area_ha)
  return(data.frame(b))
}


## grab hillslope values into a df
hillslope_area <- get_hillslope_area(pass_path, Number_of_Hillslopes)


## ----------------------------------------------------------------------------------------------------------##
##Function to Write hillslope no and date to each hillslope, calculate Nitrogen and P variables in kg values and
## export to a csv file 
## ----------------------------------------------------------------------------------------------------------##

get_N_P_from_chemicalplot <- function(output_folder, number_of_hillslopes_simulated, SimStartDate, SimEndDate){
  file.list <- list.files(path = output_folder, pattern='*.out',full.names = F)
  for (i in file.list) {
  hillslpNo <- as.numeric(stringr::str_extract(i, "[[:digit:]]+"))
  print(hillslpNo)
  df <- read.table(paste(output_folder, i, sep = "/"), skip = 2) %>% 
    dplyr::mutate(Hillslope = paste("hillslope", hillslpNo, sep = ""),
                  Date = seq(from = as.Date(SimStartDate), to = as.Date(SimEndDate), by = 1)) %>%
    select(Date, Hillslope, V8, V9, V10, V20, V21) %>%
    rename("Date" = "Date",
           "Hillslope" ="Hillslope",
           "NLeached"=V8, 
           "NSediments"= V9, 
           "NRunoff"=V10, 
           "PSediments"=V20, 
           "PRunoff"=V21)
  
  df <- left_join(df, hillslope_area, by= c("Hillslope")) 
  
  df <- df %>%
     mutate_at(.vars = vars(3:7),~(.*Area_ha))%>%
    rename_at(vars(3:7), ~paste0(.,"_kg"))
  
  readr::write_csv(df,path = paste0(output_folder,"/", i , ".csv" ))
  }}

## ----------------------------------------------------------------------------------------------------------##
#### process individual chemplotfiles to later merged into one as a watershed area weighed N and P loads
## ----------------------------------------------------------------------------------------------------------##
get_N_P_from_chemicalplot(wepp_outputs_Dir,number_of_hillslopes_simulated, SimStartDate, SimEndDate )

## ----------------------------------------------------------------------------------------------------------##
### Move all csvs to a folder
## ----------------------------------------------------------------------------------------------------------##
filesstrings::move_files(list.files(path = wepp_outputs_Dir ,pattern ='*.csv',full.names=T),
          paste(wepp_outputs_Dir,"chemplot_csvs_all_hillslopes", sep = "/"))

## ----------------------------------------------------------------------------------------------------------##
## Merge all hillslopes and calculate values at watershed outlet
## ----------------------------------------------------------------------------------------------------------##

whsed_area_ha <- get_WatershedArea_m2(file = loss_path)/10000

list_csvs <- list.files(path = paste(wepp_outputs_Dir,"chemplot_csvs_all_hillslopes", sep = "/"),
                        pattern='*csv',full.names = TRUE)

csvdf <- purrr::map_df(list_csvs, read.csv) %>% dplyr::select(-Area_ha, -Hillslope)

csvdf_day_sum<- aggregate(. ~Date, csvdf, sum, na.rm=TRUE)

csvdf_day_sum <- csvdf_day_sum %>%
  mutate_at(.vars = vars(2:6),~(./whsed_area_ha))%>%
  rename_at(vars(2:6), ~paste0(.,"_wshed_ha"))
