<#
powershell.exe -NoLogo -NoProfile -Command '[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Install-Module -Name PackageManagement -Force -MinimumVersion 1.4.6 -Scope CurrentUser -AllowClobber -Repository PSGallery'
#>
Param (
    [Parameter(Mandatory=$false, Position=0)]
    [string]$sambsHome,
    [Parameter(Mandatory=$false, Position=1)]
    [switch]$ignoreUpdate
)

Process {
    try {
        # Import the PSSambsInstaller module
        [string]$sambsInstallerModulePath = Join-Path -Path $PSScriptRoot -ChildPath '/PSSambsInstaller'
        Import-Module $sambsInstallerModulePath -Force

        #$Global:logger.loggingLevel = 'Debug'
        $logger.info('Sambs Installer starting...')
        
        # Install scoop
        Install-Scoop -sambsHome $sambsHome $ignoreUpdate

        # Install default apps
        Install-DefaultApps $ignoreUpdate

        # Configue the environment
        # Todo: 
        $logger.info('Sambs Installer completed.')
    } catch {
        $logger.error("Sambs Installer Failed: $_")
        throw "Sambs Install Failed: $_"
    }
}