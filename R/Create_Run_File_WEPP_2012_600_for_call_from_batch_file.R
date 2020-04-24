## --------------------------------------------------------------------------------------##
##
## Script name: Create_Run_File_WEPP_2012_600.R
##
## Purpose of the script: Creates Run file for the WEPP 2012.600 exe
##
## Author: Chinmay Deval
##
## Created On: 2020-04-14
## 
## 
## --------------------------------------------------------------------------------------##
##  Notes: This file create the run file for running multiple hillslopes
##         and also includes lines in the run file that are needed to run
##         the watershed
##   
##
## --------------------------------------------------------------------------------------##

## --------------------------Get arguments passed in batch file-------------------------------##
args <- commandArgs(trailingOnly = TRUE)
cat(args, sep = "\n")

## ----------------------------------Initialization---------------------------------------##

# dir_location_to_create_run_file = "C:/Users/Chinmay/Desktop/WEPPcloud_test_run_Blackwood/R_Run_file_Creator/"
# Number_of_Hillslopes = 546
# SimYears = 26
dir_location_to_create_run_file = args[1]
Number_of_Hillslopes = args[2]
SimYears = args[3]

## ----------------------------------creat run file---------------------------------------##


pass_suffix = "pass.txt"
loss_suffix = "loss.txt"
wat_suffix = "wat.txt"

sink(paste(dir_location_to_create_run_file,"pwa0.run", sep = ""))
#[e]nglish or [m]etric units
cat("m", sep = "\n")
#Drop out of the model upon invalid input and write over identical output file names?
cat("n",sep = "\n")
# 1- continuouts simulation 2- single storm
cat("1",sep = "\n")
# 1- hillslope version (single hillslopes only), 2- hillslope/watershed version(multiple hillslopes, channels and impoundments), 3- watershed versions ( channels and impoundments)
cat("2",sep = "\n")
# Enter name for master watershed pass file
cat("pass_pw0.txt",sep = "\n")
#enter number of hillslopes
cat(Number_of_Hillslopes, sep = "\n")

for (number in 1:Number_of_Hillslopes) {
#[e]nglish or [m]etric units
cat("m", sep = "\n")
# use existing hillslope file?
cat("n", sep = "\n")
# provide hillslope pass file name
cat(paste0("./output/",number, "_", pass_suffix), sep = "\n")
# soil loss option
cat("1", sep = "\n")
# want initial condition scenario output?
cat("n", sep = "\n")
# name of soil loss output
cat(paste0("./output/",number,"_", loss_suffix), sep = "\n")
# water balance output?
cat("y", sep = "\n")
# water balance file name
cat(paste0("./output/",number,"_", wat_suffix), sep = "\n")
##crop output?
cat("n", sep = "\n")
#soil output?
cat("n", sep = "\n")
#distance and sediment loss output?
cat("n", sep = "\n")
#large graphic output?
cat("n", sep = "\n")
#event by event output?
cat("n", sep = "\n")
#element output?
cat("n", sep = "\n")
#final summary output?
cat("n", sep = "\n")
#daily winter output?
cat("n", sep = "\n")
#plant yield output?
cat("n", sep = "\n")
#management file
cat(paste0("./runs/p",number,"",".man"), sep = "\n")
#slope file
cat(paste0("./runs/p",number,"",".slp"), sep = "\n")
#climate file
cat(paste0("./runs/p",number,"",".cli"), sep = "\n")
# soil file
cat(paste0("./runs/p",number,"",".sol"), sep = "\n")
#irrigation option
cat("0", sep = "\n")
# number of simulation years
cat(SimYears, sep = "\n")
}
#Some random trigger needed (using space for now). I guess a blank will work too. Check with Erin/Anurag/Mariana.
cat("", sep = "\n")
# do you wish to model impoundments
cat("y", sep = "\n")
# initial scenario output
cat("n", sep = "\n")
# wshed soil loss ouput options
cat("1", sep = "\n")
# watershed soil loss name
cat("loss_pw0.txt", sep="\n")
# wbal output?
cat("y", sep = "\n")
# file name for wbal
cat("chnwb_pw0.txt", sep="\n")
# crop output
cat("n", sep = "\n")
# soil output
cat("y", sep = "\n")
# soil output file name
cat("soil_pw0.txt", sep = "\n")
# chan erosion plotting output?
cat("n", sep = "\n")
# wshed large graphics output?
cat("n", sep = "\n")
# evenet by event output?
cat("y", sep = "\n")
# event by event file name
cat("ebe_pw0.txt", sep = "\n")
#final summary output?
cat("n", sep = "\n")
#daily winter output?
cat("n", sep = "\n")
# daily yield output?
cat("n", sep = "\n")
# want impoundment output?
cat("n", sep = "\n")
#watershed Structure file
cat("runs/pw0.str", sep = "\n")
#watershed channel file
cat("runs/pw0.chn", sep = "\n")
#watershed impoundment file
cat("runs/pw0.imp", sep = "\n")
#watershed management file
cat("runs/pw0.man", sep = "\n")
#watershed Slope file
cat("runs/pw0.slp", sep = "\n")
#watershed climate file
cat("runs/pw0.cli", sep = "\n")
#watershed soil file
cat("runs/pw0.sol", sep = "\n")
#irrigation option
cat("0", sep = "\n")
# number of simulation years
cat(SimYears, sep = "\n")
sink()