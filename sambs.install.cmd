:: sambs.install.cmd
:: A simple script to run the powershell script sambs.install.ps1
@echo off

:: Check for help in last 4 characters of first parameter
::   --help -help help
set fParam=%1
set helpCheck=%fParam:~-4%
if /I [help]==[%helpCheck%] goto :Show_Help

:Start_Powershell
echo Starting powershell script: sambs.install.ps1 %fParam% %2
powershell -NoProfile -InputFormat None -ExecutionPolicy Bypass -File %~dp0\sambs.install.ps1 %fParam% %2
set sambsInstallErrorCode = %errorLevel%

:Done
exit /B %sambsInstallErrorCode%

:Show_Help
echo Usage: sambs.install [-help] [sambsHome] [-ignoreUpdate]
echo.
echo Where:
echo    sambsHome       is the path to sambsHome. Default is $env:sambsHome or $home/.sambs.
echo    -help           Show help for the installer
echo    -ignoreUpdate   Don't update sambs installation if already installed
echo.
echo Example:
echo    sambs.install "C:\User\Public\.sambs"
echo    sambs.install -help
echo    sambs.install -ignoreUpdate
