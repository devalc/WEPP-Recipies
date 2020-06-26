## --------------------------------------------------------------------------------------##
##
## Script name: Run_WEPP_WQ_sequential.R
##
## Purpose of the script: Automates WEPP water quality run. 
##                        Takes in the project setup in WEPPcloud (downloaded zip file)
##                        and sets up a local run using the water quality module. Creates
##                        totalwatsed, processes N and P vars to be comparable with the outlet
##                        observed values
##                        
##                        
##                        
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
library(WEPPRecipes)

## --------------------------Get time taken to run the script-------------------------------##

ptm <- proc.time()

## ----------------------------------Load packages---------------------------------------##
source("C:/WEPPDesktopRunAutomationScripts/Create_Individual_hillslope_Run_File_WEPP_2012_600.R")
source("C:/WEPPDesktopRunAutomationScripts/create_channels_watershed_run_file.R")

## ----------------------------------Initialization---------------------------------------##
workDir = "D:\\Chinmay\\storagetemp\\3_hillslopes\\R_3HS_wq_automation"
WEPPOutputdir<- "D:\\Chinmay\\storagetemp\\3_hillslopes\\R_3HS_wq_automation\\WEPPDesktopRun_WQ\\output"
ZipFileName = "out-of-the-way-dodge.zip"
Number_of_Hillslopes = 3
SimYears = 10
pass_path <- "D:\\Chinmay\\storagetemp\\3_hillslopes\\R_3HS_wq_automation\\WEPPDesktopRun_WQ\\output\\pass_pw0.txt"
SimStartDate <- "2001-01-01"
SimEndDate <-"2010-12-31"
loss_path <- "D:\\Chinmay\\storagetemp\\3_hillslopes\\R_3HS_wq_automation\\WEPPDesktopRun_WQ\\output\\loss_pw0.txt"

## --------------------------------------------------------------------------------------##
### Static(No need to change on Chinmay-PC)
weppexe="C:/WEPPDesktopRunAutomationScripts/WEPP_WQ_LilyWang_updated_04_20_2020.exe"
waterqality_hillslope_files_dir = "C:/WEPPDesktopRunAutomationScripts/water_quality_hillslope_files"


## --------------------------------------------------------------------------------------##
setwd(workDir)

## --------------------------------------------------------------------------------------##
unzip(ZipFileName,exdir = "ExtractedFiles")
## --------------------------------------------------------------------------------------##
dir.create("WEPPDesktopRun_WQ", showWarnings = FALSE)

file.copy("ExtractedFiles/wepp/runs/", "WEPPDesktopRun_WQ/", recursive = TRUE)

file.copy(weppexe,"WEPPDesktopRun_WQ/", overwrite =  TRUE )

file.copy(list.files(waterqality_hillslope_files_dir, full.names = TRUE),"WEPPDesktopRun_WQ", recursive = TRUE)
create_individual_hillslop_run_files("WEPPDesktopRun_WQ/", Number_of_Hillslopes, SimYears)
create_channels_watershed_run_file("WEPPDesktopRun_WQ/runs/", Number_of_Hillslopes, SimYears)

## --------------------------------------------------------------------------------------##
setwd("WEPPDesktopRun_WQ/")
file.copy(list.files(paste(getwd(), "runs/", sep = "/"),pattern = ".txt",full.names=T),getwd())
dir.create("output", showWarnings = FALSE)

## -----------------------------------Run WEPP---------------------------------------------------##

for (hillslope in 1:Number_of_Hillslopes) {
  runfile = paste("p", hillslope, sep = "", ".run")
  errfile = paste("p", hillslope, sep = "", ".err")
  cmd = paste0("WEPP_WQ_LilyWang_updated_04_20_2020.exe<", runfile, ">", errfile)
  system("cmd.exe", input = cmd)
  file.rename("balance.out", paste(hillslope, "balance.out", sep = "_"))
  file.rename("chemical.out", paste(hillslope, "chemical.out", sep = "_"))
  file.rename("chemplot.out", paste(hillslope, "chemicalplot.out", sep = "_"))
  file.rename("percolation.txt", paste(hillslope, "percolation.txt", sep = "_"))
  file.rename("chemgraph.txt", paste(hillslope, "chemgraph.txt", sep = "_"))
}

## --------------------------Move water quality outputs to output dir------------------------------------##
file.copy(list.files(getwd(),pattern = ".out",full.names=T), "output/")
file.copy(list.files(getwd(),pattern = c("_perc"),full.names=T), "output/")
file.copy(list.files(getwd(),pattern = c("_chem"),full.names=T), "output/")
file.remove(list.files(getwd(),pattern = ".out",full.names=T))
file.remove(list.files(getwd(),pattern = "_perc",full.names=T))
file.remove(list.files(getwd(),pattern = "_chem",full.names=T))


## --------------------------Run channels/Entire watershed using individual hillslope pass files------------------------------------##

runfile = paste("runs/p0.run")
errfile = paste("runs/p0.err")
cmd = paste0("WEPP_WQ_LilyWang_updated_04_20_2020.exe<", runfile, ">", errfile)
system("cmd.exe", input = cmd)

## -------------------------sim Done------------------------------------##

print("Simulation completed!")

## -------------------------Create totalwatsed file------------------------------------##
file.copy("C:/WEPPDesktopRunAutomationScripts/WEPP_daily_corrected_CD.pl", "output/")
setwd("output/")
Perlrunfile = paste("WEPP_daily_corrected_CD.pl")
cmd = paste("perl", Perlrunfile, sep= " ")
system("cmd.exe", input = cmd)


## --------------------------Read hillslope areas from pass file ------------------------------------##

## grab hillslope values into a df
hillslope_area <-  WEPPRecipes::get_hillslope_area(pass_path, Number_of_Hillslopes)

## ----------------------------------------------------------------------------------------------------------##
#### process individual chemplotfiles to later merged into one as a watershed area weighed N and P loads
## ----------------------------------------------------------------------------------------------------------##

WEPPRecipes::get_N_P_from_chemicalplot(WEPPOutputdir,hillslope_area, Number_of_Hillslopes, SimStartDate, SimEndDate )

## ----------------------------------------------------------------------------------------------------------##
### Move all csvs created using get_N_P_from_chemicalplot to a designated folder
## ----------------------------------------------------------------------------------------------------------##
filesstrings::move_files(list.files(path = WEPPOutputdir ,pattern ='*.csv',full.names=T),
                         paste(WEPPOutputdir,"chemplot_csvs_all_hillslopes", sep = "/"),overwrite = TRUE)


## ----------------------------------------------------------------------------------------------------------##
## Merge all hillslopes and calculate values at watershed outlet
## ----------------------------------------------------------------------------------------------------------##


whsed_area <- WEPPRecipes::get_WatershedArea_m2(file = loss_path)/10000

WEPPRecipes::get_N_P_comparable_at_outlet(WEPPOutputdir,whsed_area)


print(proc.time() - ptm)
