function Invoke-Add {
    Param (
        [Parameter(Mandatory=$false, Position=0)]
        [string[]]$packages,
        [Parameter(Mandatory=$false, ValueFromRemainingArguments=$true)]
        [Object[]]$arguments    
    )

    Begin {
        $help = [PSCustomObject]@{
            summary = 'Adds the package definition'
            usage = 'Usage: sambs-installer add [-packages] <packages>

Where:
    packages    The Uri(s) to the json definition of the package(s)'
            example = 'Example: 
    sambs-installer add https://github.com/sambsawsdev/sambs-installer/blob/main/package/sambs.json
    sambs-installer add C:\Users\sambs\.sambs\scoop\apps\sambs-installer\current\package\sambs.json
    sambs-installer add -packages ./sambs.json, ./sbsa.json'
        }
    }

    Process {
        try {
            $logger.debug("Starting. [$packages, $arguments]")

            # Show help
            if ([string]::IsNullOrWhiteSpace($packages)) {
                $logger.showHelp($help)
                return
            }

            # Loop through all the packages
            foreach($package in $packages) {
                # Convert the package to a URI
                [Uri]$packageUri = [Uri]::new($package)
                # Add the package
                [string]$packageFilePath = Add-Package -packageUri $packageUri

                $logger.info("Added package '$packageFilePath'")
            }

            $logger.debug('Completed.')
        } catch {
            $logger.error("Failed: $_")
            throw "$_"
        }
    }
}