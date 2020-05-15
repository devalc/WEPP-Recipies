## --------------------------------------------------------------------------------------##
##
## Script name: Run_WEPP_WQ_sequential.R
##
## Purpose of the script: Automate WEPP water quality run
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
source("C:/WEPPDesktopRunAutomationScripts/Create_Individual_hillslope_Run_File_WEPP_2012_600.R")


## ----------------------------------Initialization---------------------------------------##
workDir = "D:/Chinmay/storagetemp/3_hillslopes/R_3HS_wq_automation"
ZipFileName = "out-of-the-way-dodge.zip"
weppexe="C:/WEPPDesktopRunAutomationScripts/WEPP_WQ_LilyWang_updated_04_20_2020.exe"
waterqality_hillslope_files_dir = "C:/WEPPDesktopRunAutomationScripts/water_quality_hillslope_files"
Number_of_Hillslopes = 3
SimYears = 10

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

