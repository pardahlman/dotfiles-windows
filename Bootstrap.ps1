#Requires -RunAsAdministrator
Set-ExecutionPolicy Bypass -Scope Process -Force;

$GITHUB_USER = "pardahlman"
$REPO_NAME = "dotfiles-windows"
$REPO_URL = "https://github.com/$GITHUB_USER/$REPO_NAME.git"
$FALLBACK_URL = "https://github.com/$GITHUB_USER/$REPO_NAME/archive/master.zip"
$TARGET_DIR = "$HOME\dotfiles"

if(Test-Path $TARGET_DIR)
{
    Write-Host "Directory '$HOME\dotfiles' already exists."
    Exit
}

New-Item -ItemType Directory $TARGET_DIR | Out-Null

if(Get-Command git -errorAction SilentlyContinue)
{
    Write-Host "Cloning repo to $TARGET_DIR"
    Invoke-Expression "git clone $REPO_URL $TARGET_DIR"
} else {
    Write-Host "Downloading dotfiles archive"
    $WorkingDirectory = "$env:TEMP\$(New-Guid)";
    New-Item -ItemType Directory $WorkingDirectory | Out-Null
    (New-Object System.Net.WebClient).DownloadFile($FALLBACK_URL, "$WorkingDirectory\dotfiles.zip");
    Expand-Archive "$WorkingDirectory\dotfiles.zip" -DestinationPath $WorkingDirectory
    $ExtractedDirectory = Get-ChildItem -Path $WorkingDirectory -Directory | Select-Object -First 1;
    Move-Item -Path "$($ExtractedDirectory.FullName)\*"  -Destination $TARGET_DIR
    Remove-Item -Path $WorkingDirectory -Force -Recurse
}

Invoke-Expression "$TARGET_DIR\InstallApplications.ps1"
Invoke-Expression "$TARGET_DIR\SetupWindows10.ps1"
