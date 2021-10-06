function Invoke-Install {
    Param (
        [Parameter(Mandatory=$false, Position=0)]
        [string[]]$packages = 'help',
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
    sambs-installer install sambs
    sambs-installer install -packages sambs, sbsa'
        }
    }

    Process {
        try {
            $logger.debug("Started. [$packages, $arguments]")

            # Show help
            if ($packages -ieq 'help') {
                $logger.showHelp($help)
                return
            }

            # Todo: Update Scoop
            

            # Loop through all the packages
            foreach($package in $packages) {
                [string]$packageFilePath = Join-Path -Path $env:sambsHome "/scoop/persist/sambs-installer/package/$package.json"
                Install-Package -packageFilePath $packageFilePath 
            }

            $logger.debug('Completed.')
        } catch {
            $logger.error("Failed: $_")
            throw "$_"
        }
    }
}