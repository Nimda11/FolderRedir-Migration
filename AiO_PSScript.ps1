# Check for administrative privileges
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "Please run this script as an Administrator."
    Exit
}

function Select-UserProfile {
    $profiles = Get-CimInstance -ClassName Win32_UserProfile | Where-Object { -not $_.Special }
    $i = 1

    foreach ($profile in $profiles) {
        Write-Host "$i. $($profile.LocalPath.split('\')[-1])"
        $i++
    }

    Write-Host "Q. Quit"
    $selectedNumber = Read-Host "Enter the number of the profile to modify or Q to quit"

    if ($selectedNumber -ieq 'Q') {
        Exit
    }

    return $profiles[$selectedNumber - 1]
}

function Process-UserProfile($selectedProfile) {
    $username = $selectedProfile.LocalPath.split('\')[-1]
    $userProfilePath = $selectedProfile.LocalPath
    $userLogDir = "C:\IT_Admin\$username"
    $dateTime = Get-Date -Format "yyyyMMddHHmmss"
    $userPrefix = "${username}_"
    $dateTimeSuffix = "_${dateTime}"

    # Ensure the user log directory exists
    if (-not (Test-Path $userLogDir)) {
        New-Item -ItemType Directory -Path $userLogDir | Out-Null
    }

    Write-Output "Processing user: $username"
    Write-Output "Log directory: $userLogDir"
    Write-Host "User Profile Path: $($selectedProfile.LocalPath)"

    Reset-FoldersAndConfigureOneDrive $username, $userProfilePath, $userLogDir, $userPrefix, $dateTimeSuffix

    Write-Output "Operations for $username completed. See log in $userLogDir"
}

function Reset-FoldersAndConfigureOneDrive($username, $userProfilePath, $userLogDir, $userPrefix, $dateTimeSuffix) {
    # Check if $userProfilePath is not null or empty
    if (-not [string]::IsNullOrWhiteSpace($userProfilePath)) {
        $foldersToReset = @(
            # Your folders to reset
        )

        foreach ($folderInfo in $foldersToReset) {
            $folderPath = Join-Path -Path $userProfilePath -ChildPath $folderInfo.Folder
            Write-Host "Resetting $($folderInfo.Folder) location to default"
            
            if (-not (Test-Path $folderPath)) {
                New-Item -ItemType Directory -Path $folderPath | Out-Null
            }

            # The reset logic continues...
        }
    }
    else {
        Write-Warning "User profile path is null or empty."
    }
}


$selectedProfile = Select-UserProfile
if ($selectedProfile) {
    Process-UserProfile $selectedProfile
}

# Prompt to log off the user
Write-Host "Press any key to log off the user and apply changes. Make sure to save any open work before proceeding."
$selectedProfile = Select-UserProfile
if ($selectedProfile) {
    Process-UserProfile $selectedProfile
}

# Prompt to log off the user
Write-Host "Press any key to log off the user and apply changes. Make sure to save any open work before proceeding."
$null = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

# Log off the user to apply changes
shutdown.exe /l /f

