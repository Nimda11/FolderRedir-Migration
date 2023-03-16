@echo off

echo This script will reset all standard user profile folders to their default locations. 
echo Press any key to continue, or Ctrl+C to exit
PAUSE >nul
CLS
GOTO CONFIRM_UAC

:CONFIRM_UAC

echo This script should NOT be run from an elevated command prompt
echo Press any key to continue, or Ctrl+C to exit
PAUSE >nul
CLS
GOTO CONFIRM_FolderRedir

:CONFIRM_FolderRedir
echo This script should be run only after first running the FolderRedirect_Kill Script
echo Press any key to continue, or Ctrl+C to exit
PAUSE >nul
CLS

:RESETFOLDERS
taskkill /f /im explorer.exe >nul

:LOGDIR
set LOGDIR=C:\IT_Admin\SpecialFolders
if not exist "%LOGDIR%" mkdir "%LOGDIR%" >nul

:DATETIME
set CUR_YYYY=%date:~10,4%
set CUR_MM=%date:~4,2%
set CUR_DD=%date:~7,2%
set CUR_HH=%time:~0,2%
if %CUR_HH% lss 10 (set CUR_HH=0%time:~1,1%)
set CUR_NN=%time:~3,2%
set CUR_SS=%time:~6,2%
set TIME_DATE=%CUR_YYYY%-%CUR_MM%-%CUR_DD%_%CUR_HH%-%CUR_NN%-%CUR_SS%

:BACKUPREG
reg export "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" "%LOGDIR%\%TIME_DATE%_%UserName%_ShellFolders.reg" >nul
reg export "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" "%LOGDIR%\%TIME_DATE%_%UserName%_UserShellFolders.reg" >nul
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" /f >nul
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" /f >nul

:APPDATA
SET FOLDER=Appdata\Roaming
SET REGVAL=Appdata
call :SF_DEFAULT_FUNCTION

:PICTURES
SET FOLDER=Pictures
SET REGVAL=My Pictures
call :SF_DEFAULT_FUNCTION

:DESKTOP 
SET FOLDER=Desktop
SET REGVAL=Desktop
call :SF_DEFAULT_FUNCTION

:DOCUMENTS
SET FOLDER=Documents
SET REGVAL=Personal
call :SF_DEFAULT_FUNCTION

:MUSIC
SET FOLDER=Music
SET REGVAL=My Music
call :SF_DEFAULT_FUNCTION

:VIDEOS
SET FOLDER=Videos
SET REGVAL=My Videos
call :SF_DEFAULT_FUNCTION

:FAVORITES
SET FOLDER=Favorites
SET REGVAL=Favorites
call :SF_DEFAULT_FUNCTION

:SAVEDGAMES
SET FOLDER=Saved Games
SET REGVAL={4C5C32FF-BB9D-43B0-B5B4-2D72E54EAAA4}
call :SF_DEFAULT_FUNCTION

:DOWNLOADS
SET FOLDER=Downloads
SET REGVAL={374DE290-123F-4565-9164-39C4925E467B}
call :SF_DEFAULT_FUNCTION

:CONTACTS
SET FOLDER=Contacts
SET REGVAL={56784854-C6CB-462B-8169-88E350ACB882}
call :SF_DEFAULT_FUNCTION

:SEARCHES
SET FOLDER=Searches
SET REGVAL={7D1D3A04-DEBB-4115-95CF-2F29DA2920DA}
call :SF_DEFAULT_FUNCTION

:LINKS
SET FOLDER=Links
SET REGVAL={BFB9D5E0-C6A9-404C-B2B2-AE6DB6AF4968}
call :SF_DEFAULT_FUNCTION

:STARTMENU
SET FOLDER=AppData\Roaming\Microsoft\Windows\Start Menu
SET REGVAL=Start Menu

GOTO ONEDRIVE_KFL_RESET

:SF_DEFAULT_FUNCTION
ECHO Resetting %FOLDER% location to default
if not exist "%USERPROFILE%\%FOLDER%" mkdir "%USERPROFILE%\%FOLDER%" >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" /v "%REGVAL%" /t REG_SZ /d "C:\Users\%USERNAME%\%FOLDER%" /f >nul 
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" /v "%REGVAL%" /t REG_EXPAND_SZ /d %%USERPROFILE%%"\%FOLDER%" /f >nul
attrib +r -s -h "%USERPROFILE%\%FOLDER%" /S /D
ECHO %FOLDER% location reset complete
REM PAUSE
GOTO:EOF

:ONEDRIVE_KFL_RESET

powershell -command "Get-ItemPropertyValue -path HKCU:SOFTWARE\Microsoft\OneDrive\ -name OneDriveTrigger"
reg DELETE HKCU\Software\Microsoft\OneDrive\Accounts\Business1\ /v KfmIsDoneSilentOptIn /F >nul
reg ADD HKCU\Software\Microsoft\OneDrive\Accounts\Business1\ /v KfmIsDoneSilentOptIn /t REG_DWORD /d 0 /F >nul
reg DELETE HKCU\Software\Microsoft\OneDrive\Accounts\Business1\ /v KfmSilentAttemptedFolders /F >nul
reg DELETE HKCU\Software\Microsoft\OneDrive\Accounts\Business1\ /v KfmState /F >nul
reg DELETE HKCU\Software\Microsoft\OneDrive\Accounts\Business1\ /v KfmFoldersProtectedNow /F >nul
reg DELETE HKCU\Software\Microsoft\OneDrive\Accounts\Business1\ /v LastKnownCloudFilesEnabled /F >nul
reg DELETE HKCU\Software\Microsoft\OneDrive\Accounts\Business1\ /v KfmFoldersProtectedOnce /F >nul

START "" explorer.exe >nul

taskkill /f /im onedrive.exe >nul
gpupdate /force >nul
powershell.exe -command "$var = Get-ItemPropertyValue -path HKCU:SOFTWARE\Microsoft\OneDrive\ -name OneDriveTrigger ; Set-Content -Path $env:LOGDIR\ODPath.txt -Value $var" >nul
set /p fODPATH=<%LOGDIR%\ODPath.txt
START "" "%fODPATH%"



ECHO Reset Complete, hit any key to exit
PAUSE >nul