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
if /i "%endCapture%"=="stop" (
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
set /p capture=Do you want to capture an image? (yes/no):
if /i "%capture%"=="yes" (
    echo Capturing an image to the Image folder on your USB...
    dism /capture-image /imagefile:"%imagesdrive%:\Images\captured.wim" /capturedir:C:\ /name:Captured /compress:max
    echo Image captured successfully!
) else (
    echo Skipping image capture.
)
set /p endCapture=Do you want to stop the script now or continue to apply an image? (stop/continue):
goto :eof

:format_drive
set /p format=Do you want to format the drive with Windows UEFI scheme? (yes/no): 
if /i "%format%"=="yes" (
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
echo Creating boot record...
bcdboot C:\Windows /s S:

set /p restart=Do you want to restart the computer? (yes/no): 
if /i "%restart%"=="yes" (
    echo Restarting the computer...
    wpeutil reboot
) else (
    echo You can keep using the command prompt.
    pause
)
exit /b 0

:list_wim_files
echo Available WIM files:
set "wimcount=0"
for /R "%imagesdrive%:\Images" %%F in (*.wim) do (
    set /A "wimcount+=1"
    set "wimfilename=%%~nxF"
    echo - [!wimcount!] !wimfilename!
)
goto :eof
