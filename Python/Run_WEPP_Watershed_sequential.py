###############################################################################
### This program runs WEPP watershed downloaded directly from WEPPCloud   ##### 
### on desktop.                                                           #####
### @author: Anurag Srivastava											  #####
### Requirements:                                                         #####
###            - Copy this python script into the runs folder.            #####
###            - Copy wepp executable to the runs folder.                 #####
###            - Change working directory to \runs in script              #####
###            - Change wepp.executable name in this script.              #####
###            - Run this python script.                                  #####
###############################################################################

#### Import libraries
import os
import sys
import subprocess
import math
import time

wdir = r'D:\Chinmay\storagetemp\3_hillslopes\out-of-the-way-dodge\wepp\runs'
os.chdir(wdir)

def main():
    # wdir = r'C:\Blackwood_Anurag\wepp\runs'
    # os.chdir(wdir)
    files = os.listdir(wdir)
    
#### Get wepp hillslope inputs

    run_list = []
    for line in files:
        try:
            if(line.endswith("run")):
                if line.startswith("pw0"):
                    pass
                else:
                    run_list.append((line))
        except:
            pass

#### Write all command in a list

    params = []
    for run in run_list:
        err = run.split(".")
        cmd = wdir + "\\WEPP2014.exe" + " < " + run + " > "  + err[0] + ".err"
        #print(cmd)
        params.append(cmd)

    start = time.time()        
## RUN HILLSLOPES SEQUENTIALLY
    for r in params:
        subprocess.call(r, shell=True)

#### End runs with channels

    parms = wdir + "\\WEPP2014.exe < pw0.run > pw0.err"
    #print(parms)
    subprocess.call(parms, shell=True)
    
    end = time.time()
    print("Execution took: ", (end-start)/60, " minutes")

if __name__ == '__main__':
    main()