Param (
    [Parameter(Mandatory=$false, Position=0)]
    #[ValidateSet('help', 'install', 'configure', 'repo')]
    [string]$command = 'help',
    [Parameter(Mandatory=$false, ValueFromRemainingArguments=$true)]
    [Object[]]$arguments
)

Process {
    try {
        # Import the PSSambsInstaller module
        [string]$sambsInstallerModulePath = Join-Path -Path $PSScriptRoot -ChildPath '/PSSambsInstaller'
        Import-Module $sambsInstallerModulePath -Force

        #$Global:logger.loggingLevel = 'Debug'
        $logger.debug("Starting. [$command, $arguments]")
        
        # Invoke the appropriate command
        switch ($command.ToLower()) {
            'help' { Invoke-Expression "Invoke-Help $arguments" }
            'install' { Invoke-Expression "Invoke-Install $arguments" }
            'add' { Invoke-Expression "Invoke-Add $arguments" }
            'configure' { Invoke-Expression "Invoke-Configure $arguments" }
            'login' { Invoke-Expression "Invoke-SsoLogin $arguments" }
            'repo' { Invoke-Expression "Invoke-Repo $arguments" }
            Default {
                # Command is not known
                # Show help
                $logger.error("Unknown command '$command'")
                Invoke-Expression "Invoke-Help"
                throw "Unknown command '$command'"
            }
        }        

        $logger.debug('Completed.')
    } catch {
        $logger.error("Failed: $_")        
        throw "$_"
    }
}