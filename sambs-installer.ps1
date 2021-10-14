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
        
        [string]$argumentsJoined = $null
        forEach($argument in $arguments) {
            if ($argument.StartsWith('-')) {
                $argumentsJoined = "$argumentsJoined $argument"
            } elseif (-not [string]::IsNullOrWhiteSpace($argument)) {
                $argumentsJoined = "$argumentsJoined `"$argument`""
            }
        }

        # Invoke the appropriate command
        switch ($command.ToLower()) {
            'help' { Invoke-Expression "Invoke-Help $argumentsJoined" }
            'install' { Invoke-Expression "Invoke-Install $argumentsJoined" }
            'add' { Invoke-Expression "Invoke-Add $argumentsJoined" }
            'configure' { Invoke-Expression "Invoke-Configure $argumentsJoined" }
            'login' { Invoke-Expression "Invoke-SsoLogin $argumentsJoined" }
            'repo' { Invoke-Expression "Invoke-Repo $argumentsJoined" }
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