
$installActions = @(
    ### Require administrator privileges ###
    "RequireAdmin",

    ### Requred package manager for install ###
    "InstallChocolatey",        # UninstallChocolatey

    ### Development tools ###
    "InstallGit",               # UninstallGit
    "InstallBeyondCompare",     # UninstallBeyondCompare
    "InstallVisualStudioCode",  # UninstallVisualStudioCode
    #"InstallVisualStudio",     # UninstallVisualStudio
    "InstallHyperJs",           # UninstallHyperJs
    "InstallDocker",            # UninstallDocker
    "InstallDotNetCore",        # UninstallDotNetCore
    "InstallNodeJs",            # UninstallNodeJs

    ### Utilities ###
    "InstallEverythingSearch",  # UninstallEverythingSearch
    "Install7Zip",              # Uninstall7Zip

    ### Browsers ###
    "InstallFirefox",           # UninstallFirefox
    "InstallChrome",            # UninstallChrome

    ### Social ###
    "InstallSlack",             # UninstallSlack
    "InstallTweeten",           # UninstallTweeten

    ### Media ###
    "InstallSpotify",           # UninstallSpotify
    "InstallVLC",               # UninstallVLC
    #"InstallITunes",            # UninstallITunes

    ### Storage ###
    "InstallDropbox"            # UninstallDropbox
)

Function InstallChocolatey {
    if(Get-CommandAvailable 'choco'){
        Install-Package 'chocolatey' 'Chocolatey'
    } else {
        Write-Host -NoNewline "Installing Chocolatey... "
        # https://chocolatey.org/install
        Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1')) | Out-Null
        Write-Host "done!"
    }
}

Function UninstallChocolatey {
    # https://chocolatey.org/docs/uninstallation
    Remove-Item -Recurse -Force "$env:ChocolateyInstall"
    [System.Text.RegularExpressions.Regex]::Replace([Microsoft.Win32.Registry]::CurrentUser.OpenSubKey('Environment').GetValue('PATH', '', [Microsoft.Win32.RegistryValueOptions]::DoNotExpandEnvironmentNames).ToString(), [System.Text.RegularExpressions.Regex]::Escape("$env:ChocolateyInstall\bin") + '(?>;)?', '', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase) | %{[System.Environment]::SetEnvironmentVariable('PATH', $_, 'User')}
    [System.Text.RegularExpressions.Regex]::Replace([Microsoft.Win32.Registry]::LocalMachine.OpenSubKey('SYSTEM\CurrentControlSet\Control\Session Manager\Environment\').GetValue('PATH', '', [Microsoft.Win32.RegistryValueOptions]::DoNotExpandEnvironmentNames).ToString(),  [System.Text.RegularExpressions.Regex]::Escape("$env:ChocolateyInstall\bin") + '(?>;)?', '', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase) | %{[System.Environment]::SetEnvironmentVariable('PATH', $_, 'Machine')}
}

Function InstallVisualStudioCode {
    Install-Package 'visualstudiocode' 'Visual Studio Code' @(
        '/NoDesktopIcon',
        '/NoQuicklaunchIcon',
        '/NoContextMenuFiles',
        '/NoContextMenuFolders'
    )

    New-Item -Type HardLink -Force -Path $env:APPDATA\Code\User -Name settings.json -Target $PSScriptRoot\config\vscode\settings.json | Out-Null
    New-Item -Type HardLink -Force -Path $env:APPDATA\Code\User -Name keybindings.json -Target $PSScriptRoot\config\vscode\keybindings.json | Out-Null
}

Function UninstallVisualStudioCode {
    Uninstall-Package "visualstudiocode"
}

Function InstallVisualStudio {
    Install-Package 'visualstudio2017enterprise' 'Visual Studio 2017 (Enterprise)'
    Install-Package 'visualstudio2017-workload-netweb' 'Visual Studio ASP.NET and web development'
    Install-Package 'visualstudio2017-workload-netcoretools' 'Visual Studio .NET Core tools'
    Install-Package 'resharper' 'Jetbrain ReSharper'
}

Function UninstallVisualStudio {
    Uninstall-Package 'resharper'
    Uninstall-Package 'visualstudio2017-workload-netcoretools'
    Uninstall-Package 'visualstudio2017-workload-netweb'
    Uninstall-Package 'visualstudio2017enterprise'
}

Function InstallGit {
    Install-Package 'git.install' 'Git' @(
        '/NoShellIntegration', # Disables shell integration ( "Git GUI Here" and "Git Bash Here" entries in context menus).
        '/NoGitLfs' # Disable Git LFS installation.
    )

    if(Test-Path $PSScriptRoot\config\git\gitconfig.local -ne $null)
    {
        Copy-Item -Path $PSScriptRoot\config\git\gitconfig.local -Destination $HOME\.gitconfig.local | Out-null
    }
    New-Item -ItemType HardLink -Force -Path $HOME -Name .gitignore -Value $PSScriptRoot\config\git\gitignore | Out-null
    New-Item -ItemType HardLink -Force -Path $HOME -Name .gitattributes -Value $PSScriptRoot\config\git\gitattributes | Out-null
    New-Item -ItemType HardLink -Force -Path $HOME -Name .gitconfig -Value $PSScriptRoot\config\git\gitconfig | Out-null
    New-Item -ItemType HardLink -Force -Path $HOME -Name .vimrc -Value $PSScriptRoot\config\vim\vimrc | Out-null
}

Function UninstallGit {
    Uninstall-Package "git"
    Remove-Item "$HOME\.gitignore"
    Remove-Item "$HOME\.gitattributes"
    Remove-Item "$HOME\.gitconfig"
}

Function InstallBeyondCompare { Install-Package 'beyondcompare' 'Beyond Compare' }

Function UninstallBeyondCompare { Uninstall-Package 'beyondcompare' 'Beyond Compare' }

Function InstallEverythingSearch {
    Install-Package 'everything' 'Everything (search)', @(
    '/efu-association', # - Install EFU file association.
    '/run-on-system-startup', # - Install "Everything" in the system startup.
    '/service' # - Install and start the "Everything" service.
    )
}

Function InstallEverythingSearch { Uninstall-Package 'everything'}

Function Install7Zip { Install-Package '7zip.install' '7-Zip' }

Function Uninstall7Zip { Uninstall-Package '7zip.install' }

Function InstallHyperJs {
    Install-Package 'hyper' 'Hyper.js'
    New-Item -Type HardLink -Force -Path $HOME -Name .hyper.js -Target $PSScriptRoot\config\hyperjs\hyper.js | Out-Null
}

Function UninstallHyperJs { Uninstall-Package "hyper" }

Function InstallDocker { Install-Package 'docker-for-windows' 'Docker' }

Function UninstallDocker { Uninstall-Package 'docker-for-windows' }

Function InstallDotNetCore {
    Install-Package 'dotnetcore-sdk' '.NET Core SDK'
    # Opt out of telemetry https://docs.microsoft.com/en-us/dotnet/core/tools/telemetry
    [Environment]::SetEnvironmentVariable("DOTNET_CLI_TELEMETRY_OPTOUT", "1", "Machine") | Out-Null
}

Function UninstallDotNetCore {
    Uninstall-Package 'dotnetcore-sdk'
    Remove-Item Env:\DOTNET_CLI_TELEMETRY_OPTOUT -ErrorAction SilentlyContinue
}

Function InstallNodeJs { Install-Package 'nodejs.install' 'Node.js' }

Function UninnstallNodeJs { Uninstall-Package 'nodejs.install' }

Function InstallSlack { Install-Package 'slack' 'Slack'}
Function UninstallSlack { Uninstall-Package 'slack' }

Function InstallTweeten { Install-Package 'tweeten' 'Tweeten' }

Function UninstallTweeten { Uninstall-Package 'tweeten' }

Function InstallSpotify { Install-Package 'spotify' 'Spotify'}

Function UninstallSpotify { Uninstall-Package 'spotify' }

Function InstallVLC { Install-Package 'vlc' 'VLC Media Player' }

Function UninstallVLC { Uninstall-Package 'vlc' }

Function InstallITunes { Install-Package 'itunes' 'iTunes'}

Function UninstallITunes { Uninstall-Package 'itunes' }

Function InstallFirefox { Install-Package 'firefox' 'Firefox' }

Function UninstallFirefox { Uninstall-Package 'firefox' }

Function InstallChrome { Install-Package 'googlechrome', 'Chrome' }

Function InstallChrome { Uninstall-Package 'googlechrome' }

Function InstallDropbox { Install-Package 'dropbox' 'Drop' }

Function UninstallDropbox { Uninstall-Package 'dropbox' 'Drop' }

##########
# Auxiliary Functions
##########

# Relaunch the script with administrator privileges
Function RequireAdmin {
	If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator")) {
		Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`" $PSCommandArgs" -WorkingDirectory $pwd -Verb RunAs
		Exit
	}
}

Function Remove-DesktopShortcuts {
    Get-ChildItem -Path $HOME\Desktop -Filter *.lnk | ForEach-Object { Remove-Item $_ -ErrorAction SilentlyContinue }
}
Function Uninstall-Package([string] $packageName) {
    if(Get-CommandAvailable "choco") {
        Invoke-Expression "choco uninstall $packageName --confirm" -ErrorAction SilentlyContinue | Out-Null
    } else {
        Write-Host "Command 'choco' is not available. Is Chocolatey installed?" -ForegroundColor Red
        Exit
    }
}

Function Install-Package($packageName, $dispayName, $arguments){
    $chocoArgs = "--params='$($arguments -join ' ')'"

    if(Get-CommandAvailable "choco") {
        $operation = if(Test-PackageInstalled $packageName) {"upgrade"} else {"install"}
        Write-Host -NoNewline "Performing $operation of $dispayName..."
        Invoke-Expression "choco $operation $packageName $chocoArgs --confirm" -ErrorAction Stop | Out-Null
        Remove-DesktopShortcuts
        Write-Host "done!" -ForegroundColor Green
    } else {
        Write-Host "Command 'choco' is not available. Is Chocolatey installed?" -ForegroundColor Red
        Exit
    }
}

Function Test-PackageInstalled($packageName) {
    $matchFound = $false
    Invoke-Expression "choco list --local-only" | ForEach-Object {
        $installedName = $_.Split(" ") | Select-Object -First 1;
        if($installedName -eq $packageName) {
            $matchFound = $true
        } 
    }
    return $matchFound
}

function Get-CommandAvailable([string] $cmdName) {
    if (Get-Command $cmdName -errorAction SilentlyContinue)
    {
        return $true;
    }
    return $false;
}

##########
# Parse parameters and apply tweaks
##########

# Normalize path to preset file
$preset = ""
$PSCommandArgs = $args
If ($args -And $args[0].ToLower() -eq "-preset") {
	$preset = Resolve-Path $($args | Select-Object -Skip 1)
	$PSCommandArgs = "-preset `"$preset`""
}

# Load function names from command line arguments or a preset file
If ($args) {
	$installActions = $args
	If ($preset) {
		$installActions = Get-Content $preset -ErrorAction Stop | ForEach { $_.Trim() } | Where { $_ -ne "" -and $_[0] -ne "#" }
	}
}

# Call the desired tweak functions
$installActions | ForEach { Invoke-Expression $_ }
