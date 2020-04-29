REM # Created on: 04/23/2020
REM # Purpose: Script to automate desktop run of WEPP using the WEPPcloud project
REM # NOTES: Use this if you want to setup desktop run to execute both channels and hillslope together.
REM # NOTES:  
REM @author: Chinmay Deval 
@cls
@ECHO OFF
ECHO Start Measure %Time% >> timer.txt
echo Everything I create will be nested under: "%~dp0" 
pause
REM ########## Provide correct path to each variable on between line 10 and 17 ###############
SET "weppexe=C:\WEPPDesktopRunAutomationScripts\WEPP_WQ_LilyWang_updated_04_20_2020.exe" 
SET "Rpath=C:\Program Files\R\R-3.4.3\bin\R"
SET "WEPPcloudZip=D:\Chinmay\storagetemp\seventy-two-bottomland.zip"
SET "RunFileCreator=C:\WEPPDesktopRunAutomationScripts\Create_Run_File_WEPP_2012_600_for_call_from_batch_file.R"
SET "CreateRunFileHere=%~dp0\WEPPDesktopRun\"
SET "NumberOfHillslopes=683"
SET "NumberofSimulationYears=25"
SET "PerlScriptToCreateTotalWatSed=C:\WEPPDesktopRunAutomationScripts\WEPP_daily_corrected_CD.pl"
REM #########################################################################################
for %%F in ("%weppexe%") do (SET weppexefilename=%%~nxF)
for %%F in ("%PerlScriptToCreateTotalWatSed%") do (SET PerlScriptfilename=%%~nxF)
echo %weppexefilename%
ECHO Extracting "%WEPPcloudZip%" in "%~dp0\ExtractedFiles%" folder
powershell  -command "& {Expand-Archive "%WEPPcloudZip%" "%~dp0\ExtractedFiles"}"  
REM unzip -o "%WEPPcloudZip%" -d "%~dp0\ExtractedFiles" ## not a native function. Causes errors in other pcs. Replaced by annoyingly slow powershell alternative
echo Done extracting
echo Let's start setting up WEPPDesktopRun Folder
PAUSE
mkdir WEPPDesktopRun
mkdir WEPPDesktopRun\runs
mkdir WEPPDesktopRun\output
xcopy "%~dp0\ExtractedFiles\wepp\runs" "WEPPDesktopRun\runs\"
echo Delete unnecessary files extracted earlier from the archive
pause
rmdir /S /Q "ExtractedFiles\"
move "WEPPDesktopRun\runs\chan.inp" "WEPPDesktopRun\"
xcopy "%weppexe%" "WEPPDesktopRun\"
echo Let's create pw0.run file
PAUSE
"%Rpath%" --slave --no-restore --file="%RunFileCreator%" --args %CreateRunFileHere% %NumberOfHillslopes% %NumberofSimulationYears%
echo Done setting up file structure for the WEPP desktop run 
echo proceed to execute WEPP or close command prompt to stop here.
PAUSE
cd "%~dp0\WEPPDesktopRun\"
del /S /Q "%~dp0\output\"
del /S /Q "%~dp0\pwa0.err"
del /S /Q "%~dp0\chan.out"
del /S /Q "%~dp0\chanwb.out"
del /S /Q "%~dp0\chnwb.txt"
del /S /Q "%~dp0\ebe_pw0.txt"
del /S /Q "%~dp0\loss_pw0.txt"
del /S /Q "%~dp0\runout"
del /S /Q "%~dp0\chntyp.txt"
del /S /Q "%~dp0\pass_pw0.txt"
%weppexefilename%< pwa0.run > pwa0.err
echo Done running model. Continue to create totalwatsed:
pause
xcopy "%PerlScriptToCreateTotalWatSed%" "output\"
cd "output\"
call perl %PerlScriptfilename%
echo TotalWatSed created in the output folder
ECHO Stop Measure %Time% >> timer.txt
echo Phew!, done.