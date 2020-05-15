## --------------------------------------------------------------------------------------##
##
## Script name: Create_Individual_Hillslope_Run_File_WEPP_2012_600_for_calling_from_batch_File.exe.R
##
## Author: Chinmay Deval
##
## Created On: 2020-05-14
## 
## 
## --------------------------------------------------------------------------------------##
##  Notes: This function create run file for running standalone hillslopes
##         and DOES NOT create a pwa0.run (watershed run file) that include lines 
##         in the run file that are needed to run the entire watershed
##   
##
## --------------------------------------------------------------------------------------##


## ----------------------------------creat run file---------------------------------------##


create_individual_hillslop_run_files <- function(dir_location_to_create_run_file,Number_of_Hillslopes,SimYears){

pass_suffix = "pass.txt"
loss_suffix = "loss.txt"
wat_suffix = "wat.txt"
soil_suffix = "soil.txt"
plot_suffix = "plot.txt"
ebe_suffix = "ebe.txt"
element_suffix = "element.txt"


for (number in 1:Number_of_Hillslopes) {
  sink(paste(dir_location_to_create_run_file,"p", sep = "", number, ".run"))
  #[e]nglish or [m]etric units
  cat("m", sep = "\n")
  # use existing hillslope file?
  cat("y", sep = "\n")
  # Continuous or single event option (1 - continuous simulation, 2 - single storm)
  cat("1", sep = "\n")
  #Model version option (1 - hillslope version (single hillslope only),2 - hillslope/watershed version(multiple hillslopes, channels, and impoundments),3 - watershed version (channels and impoundments)
  cat("1", sep = "\n")
  # Do you want hillslope pass file output (Y/N)? [N] -->
  cat("y", sep = "\n")
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
  cat("y", sep = "\n")
  # name of soil output
  cat(paste0("./output/",number,"_", soil_suffix), sep = "\n")
  #distance and sediment loss output?
  cat("n", sep = "\n")
  #large graphic output?
  cat("n", sep = "\n")
  #event by event output?
  cat("y", sep = "\n")
  # name of ebe output
  cat(paste0("./output/",number,"_", ebe_suffix), sep = "\n")
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
  #bypass erosion calc for very small events
  cat("0", sep = "\n")
  sink()
}
}