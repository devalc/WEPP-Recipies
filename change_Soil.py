# script to change rill erodibility in all soil files for a given run

#To use this script make a new file called "Soil_Conversion" and then within
# that file make two more files called "inSoils" and "outSoils"

# When running WEPP in batch more you can take all the soil files from your "runs" file
# and put them into the inSoils file. Then, once run, paste the new files from outSoils back into "runs"
# after deleting the old soil files. 

import os
import sys
import pandas as pd
import numpy as np
import re

#change the directory paths in the code below to match where the files are on your machine.
#make sure to keep the double backslashes
workingDirectory="D:\\WEPP\\Soil Conversion_md" 
inputDirectory="D:\\WEPP\Soil Conversion_md\\inSoils"           
outputDirectory="D:\\WEPP\\Soil Conversion_md\\outSoils"            


for root,dirs,inData in os.walk(inputDirectory):
    os.chdir(inputDirectory)
    
    #read in files in your "inSoils" folder
    for file in inData:                                                
        InputFile=open(os.path.join(inputDirectory, file), "r")    
        data_list = InputFile.readlines()
        
        # grab the "comments" section of the file 
        # the for loop counts each line in the file that starts with a "#" 
        n = 0
        for i, line in enumerate(data_list):
            if data_list[i][0] == "#":
               n += 1  
            if data_list[i][0] != "#":
                break
        # sets comments equal to all the lines that it counted as starting with "#"
        comments = data_list[0:n]
        
        # sets main file equal to the rest of the file from the number of lines counted as having a "#" to the end
        main_file = data_list[n:]
        # grabs the lines above the line we want to change
        head = main_file[0:3]
        # grabs the line we want to change
        chgLine= main_file[3]
        #split the line based on blank space from the right
        chgLineSpt = chgLine.rsplit()
        #rejoins the first part of the line and replaces the spaces
        first = " ".join(chgLineSpt[0:-3])
        #calculates the new erodibility ( CHANGE THE LAST NUMBER IN THIS LINE TO GET YOUR DESIRED EROD)
        erod = str(float(chgLineSpt[-3]) * 100)
        #splits out the end of the line 
        last = chgLineSpt[-2] + " " + chgLineSpt[-1]
        # grabs the rest of the lines in the file after the one we changed
        tail = main_file[4:]
		
        #puts the file back together and writes it to the output file
        OutputFile=open(os.path.join(outputDirectory, file), 'w')
        OutputFile.writelines(comments)
        OutputFile.writelines(head)
        OutputFile.writelines(first)
        OutputFile.writelines(" ")
        OutputFile.writelines(erod)
        OutputFile.writelines(" ")
        OutputFile.writelines(last)
        OutputFile.writelines("\n")
        OutputFile.writelines(tail)
                
        OutputFile.close()                                            
    InputFile.close()                                                