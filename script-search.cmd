@echo off
setlocal enabledelayedexpansion

REM Search for volume with "Scripts" folder
set "scriptdrive="
for %%a in (C D E F G H I J K L M N O P Q R S T U V W X Y Z) do (
    if exist "%%a:\Scripts\" (
        set "scriptdrive=%%a"
        goto found
    )
)

:found
echo Found the "Scripts" folder on drive %scriptdrive%
echo.

REM List scripts and prompt for selection
set scriptcount=0
echo Listing scripts:
for /F "tokens=*" %%F in ('dir /B /A-D "%scriptdrive%:\Scripts\*.cmd" "%scriptdrive%:\Scripts\*.bat" "%scriptdrive%:\Scripts\*.ps1"') do (
    set /A "scriptcount+=1"
    echo !scriptcount!: %%~nxF
    set "script!scriptcount!=%%~nxF"
)

if %scriptcount% equ 0 (
    echo No scripts found in the "Scripts" folder.
    exit /b
)

set /P choice="Enter the number of the script you want to run: "

REM Verify the selected script number
setlocal disabledelayedexpansion
set selectedscript=!script%choice%!
setlocal enabledelayedexpansion
if not "%selectedscript%"=="" (
    echo You selected: %selectedscript%
    pushd "%scriptdrive%:\Scripts\"
    call "%selectedscript%"
    popd
) else (
    echo Invalid script selection!
)

:end
exit /b