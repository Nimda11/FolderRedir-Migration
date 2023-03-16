# Summary
This is a series of scripts intended to help decomission a "sticky" folderredirection deployment with the end goal of allowing migration to OneDrive Known Folder Migration (KFM)
The user object should no longer be within the scope of a Folder Redirection policy in active directory prior to running these scripts.

Written in Batch and calls Powershell as needed.

Tested against Windows 10 and 11, onedrive clients that are current as of Q1 of 2023
Not tested against 32bit OS's or Servers.

# LoginScript.bat
Should be run as a login script. Very simple purpose, it logs the current paths for the Pictures, Documents, and Desktop folders every time a user logs in to C:\IT_Admin\SpecialFolders. The main point being that a technician can find these paths later in case we need to "recover" user documents. Can be deployed as a scheduled task, or preferable as a login script via the users AD Account or GPO.

# 1_FolderRedir_Kill.bat
This script removes Folder Redirection related registry entries. This allows known folders paths to be changed, but it does NOT change them (2_Reset_KFL.bat actually changes the paths)

**Because these registry entries are located in the HKLM registry hive, this script must be run with administrative privliges.**

This script should only be run on a system when a single user is logged in, so no active terminal servers, or pc's with mulitple people logged in (hotdesks).

The script looks up the SID of the logged in user, and deletes the following registry key

    HKLM:SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList\<SID>\fdeploy\

# 2_Reset_KFL.bat
This script
1. resets the paths of all possible redirected folders for the logged in user.
    - Deletes both "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" and "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" keys
    - Keys are backed up to C:\\IT_Admin\\SpecialFolders\\%DateTime%\_%UserName%_*\<keyname\>*.reg prior to deletion.
2. deletes several registry entries related to KFL Migration as sometimes automatic enrollment doesn't work.
3. Runs a GPUPDATE
4. Stops and Restarts Explorer and OneDrive