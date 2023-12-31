@echo off                                                          
echo  #     # ### #     #                                         
echo  #  #  #  #  ##   ##                                         
echo  #  #  #  #  # # # #                                         
echo  #  #  #  #  #  #  #                                         
echo  #  #  #  #  #     #                                         
echo  #  #  #  #  #     #                                         
echo   ## ##  ### #     #                                         
echo  -                                                           
echo  #     #    #    #     #    #     #####  ####### ######      
echo  ##   ##   # #   ##    #   # #   #     # #       #     #     
echo  # # # #  #   #  # #   #  #   #  #       #       #     #     
echo  #  #  # #     # #  #  # #     # #  #### #####   ######      
echo  #     # ####### #   # # ####### #     # #       #   #       
echo  #     # #     # #    ## #     # #     # #       #    #      
echo  #     # #     # #     # #     #  #####  ####### #     #     
echo.

setlocal enableextensions enabledelayedexpansion

:main
call :find_images_drive
if "%imagesdrive%"=="" (
    echo ERROR: No volume with "Images" folder was found.
    exit /b 1
)

call :capture_image
if /i "%endCapture%"=="N" (
    goto end
)

call :format_drive
call :find_images_drive
if "%imagesdrive%"=="" (
    echo ERROR: No volume with "Images" folder was found after formatting the drive.
    exit /b 1
)

call :apply_wim
goto end

:find_images_drive
echo Searching for a volume with "Images" folder...
set "imagesdrive="
for %%a in (C D E F G H I J K L M N O P Q R S T U V W X Y Z) do (
    if exist "%%a:\Images\" (
        set "imagesdrive=%%a"
        echo Found Images folder on %%a:\
        goto :eof
    )
)
goto :eof

:capture_image
set /p capture=Do you want to capture an image? (Y/N):
if /i "%capture%"=="Y" (
    echo Capturing an image to the Image folder on your USB...
    dism /capture-image /imagefile:"%imagesdrive%:\Images\captured.wim" /capturedir:C:\ /name:Captured /compress:max
    echo Image captured successfully!
) else (
    echo Skipping image capture.
)
set /p endCapture=Do you want to apply an image? (Y/N):
goto :eof

:format_drive
set /p format=Do you want to format the drive with Windows UEFI scheme? (Y/N): 
if /i "%format%"=="Y" (
    echo Formatting drive for Windows UEFI...
    diskpart /s diskpart_script.txt
    echo Drive formatted successfully!
)
goto :eof

:apply_wim
call :list_wim_files
set /p wim=Enter the number of the WIM file you want to apply: 

set "wimcount=0"
for %%F in ("%imagesdrive%:\Images\*.wim") do (
    set /A "wimcount+=1"
    if !wim! equ !wimcount! (
        set "wimfile=%%F"
        set "wimdescription=%%~nF"
        goto apply_wim_file
    )
)
echo ERROR: Invalid WIM file selection!
exit /b 1

:apply_wim_file
echo Applying WIM file %wimdescription% from volume %imagesdrive%...
dism /apply-image /imagefile:"%wimfile%" /index:1 /applydir:C:\

:end

set /p createboot=Do you want to create a boot record? (Y/N): 
if /i "%createboot%"=="Y" (
    echo Creating boot record...
    bcdboot C:\Windows /s S:
) else (
    echo Skipping boot record creation.
)

set /p runsearch=Do you want to run another script and get a list of options from the scripts folder? (Y/N): 
if /i "%runsearch%"=="Y" (
    echo Running script-search.cmd...
    if exist "%~dp0\script-search.cmd" (
        call "%~dp0\script-search.cmd"
    ) else (
        echo ERROR: script-search.cmd not found in the same folder as this script.
    )
) else (
    echo Skipping script-search.cmd.
)

set /p restart=Do you want to restart the computer? (Y/N): 
if /i "%restart%"=="Y" (
    echo Restarting the computer...
    wpeutil reboot
) else (
    echo You can keep using the command prompt.
    pause
)

:list_wim_files
echo Available WIM files:
set "wimcount=0"
for /R "%imagesdrive%:\Images" %%F in (*.wim) do (
    set /A "wimcount+=1"
    set "wimfilename=%%~nxF"
    echo - [!wimcount!] !wimfilename!
)
goto :eof

exit /b 0
