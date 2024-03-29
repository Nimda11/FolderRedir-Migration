@echo off
REM [Remove Folder Redirection Policies Section - Start]
REM This section removes the registry enteries related to folder redirection policies. This allows folder redriected folder paths to be changes, but does not actually change these paths.

echo This script must be run elevated, close or hit Ctrl+C to stop.
echo This script will wipe out folder redirection registry entries. 
echo KB Article is https://docs.formatech-it.biz/shared_article/nrYbTmtquNQDDXeoSM3obPCJ
echo hit any key to continue, hit Ctrl+C to stop
PAUSE

set LOGDIR=c:\IT_Admin\SpecialFolders
if not exist "%LOGDIR%" mkdir "%LOGDIR%" >nul

REM Backup Registry Keys related to folder redirection for currently logged in user
powershell.exe -command "$vUsername = Get-WMIObject -class Win32_ComputerSystem | select -ExpandProperty username ; $vSID = ([System.Security.Principal.NTAccount]("$vUsername")).Translate([System.Security.Principal.SecurityIdentifier]).Value ; reg.exe EXPORT \"HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList\$vSID\fdeploy\" %LOGDIR%\fd_backup.reg"
REM Delete Registry Keys related to folder redirection for currently logged in user
powershell.exe -command "$vUsername = Get-WMIObject -class Win32_ComputerSystem | select -ExpandProperty username ; $vSID = ([System.Security.Principal.NTAccount]("$vUsername")).Translate([System.Security.Principal.SecurityIdentifier]).Value ; Remove-Item -Path \"HKLM:SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList\$vSID\fdeploy\" -Force -Recurse"

REM [Remove Folder Redirection Policies Section - End]



REM Disable Offline Files
reg ADD "HKLM\SYSTEM\CurrentControlSet\Services\CSC" /v "Start" /t REG_DWORD /d 4 /f >nul
reg ADD "HKLM\SYSTEM\CurrentControlSet\Services\CscService" /v "Start" /t REG_DWORD /d 4 /f >nul

echo Script Complete, hit any key to quit
PAUSE