@echo off
REM Start SpecialFolderAudit Section
REM SpecialFolderAudit section queries the system as the logged in user as to what the Desktop, Documents, and Pictures folders paths are.
REM These paths are logged to a text file located at C:\IT_Admin\SpecialFolders, each user gets their own file.

REM Set Variables such as where to store the file, the file name, current date
set LOGDIR=C:\IT_Admin\SpecialFolders
set LOGFILE=%LOGDIR%\%username%_sf_audit.txt
set datestr=%date:~10,4%-%date:~7,2%-%date:~4,2%
if not exist "%LOGDIR%" mkdir %LOGDIR%

REM these next lines are just to assist with debugging this script
REM echo "LogDir = %LOGDIR%"
REM echo "LogFile = %LOGFILE%"
REM echo "datestr" = %datestr%
REM powershell -command Write-Host "Powershell thinks LOGFILE = "$env:LOGFILE

REM Actual Special Folder Query
echo ## Start Audit >> %LOGFILE%
echo On %datestr% the special folders for %username% on %computername% were >> %LOGFILE%
powershell -command "$Pictures = [Environment]::GetFolderPath([System.Environment+SpecialFolder]::'MyPictures') ; Add-Content -Path $env:LOGFILE -Value \"Pictures, $Pictures\" -Encoding UTF8"
powershell -command "$Documents = [Environment]::GetFolderPath([System.Environment+SpecialFolder]::'MyDocuments') ; Add-Content -Path $env:LOGFILE -Value \"Documents, $Documents\" -Encoding UTF8"
powershell -command "$Desktop = [Environment]::GetFolderPath([System.Environment+SpecialFolder]::'Desktop') ; Add-Content -Path $env:LOGFILE -Value \"Desktop, $Desktop\" -Encoding UTF8"
echo ## End Audit >> %LOGFILE%

REM End SpecialFolderAudit Section