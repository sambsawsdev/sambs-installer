function Invoke-Install {
    Param (
        [Parameter(Mandatory=$false, Position=0)]
        [string[]]$packages,
        [Parameter(Mandatory=$false, ValueFromRemainingArguments=$true)]
        [Object[]]$arguments    
    )

    Begin {
        $help = [PSCustomObject]@{
            summary = 'Installs the items defined in the package'
            usage = 'Usage: sambs-installer install [-packages] <packages>

Where:
    packages    The name(s) of the package(s)'
            example = 'Example: 
    sambs-installer install "sambs"
    sambs-installer install -packages "sambs, sbsa"'
        }
    }

    Process {
        try {
            $logger.debug("Starting. [$packages, $arguments]")

            # Show help
            if ([string]::IsNullOrWhiteSpace($packages) -or $packages -ieq 'help') {
                $logger.showHelp($help)
                return
            }

            # Ensure scoop is installed
            if ( -not (Test-ScoopInstalled) ) {
                throw "Scoop is required to install packages."
            }
            
            # Update scoop
            $logger.info("Update scoop starting...`n")
            # Add bucket
            Invoke-Expression "scoop update"
            $logger.info("Update scoop completed.")                
        

            # Loop through all the packages
            foreach($package in $packages) {
                [string]$packageFilePath = Join-Path -Path $env:SAMBS_HOME "/scoop/apps/sambs-installer/current/package/$package.json"
                Install-Package -packageFilePath $packageFilePath 
            }

            $logger.debug('Completed.')
        } catch {
            $logger.error("Failed: $_")
            throw "$_"
        }
    }
}