function Install-App {
    Param (
        [Parameter(Mandatory=$true, Position=0)]
        [string]$app,
        [Parameter(Mandatory=$false, Position=1)]
        [switch]$ignoreUpdate
    )

    Process {
        try {
            $logger.debug("Starting. [$app]")

            # Ensure scoop is installed
            if ( -not (Get-IsScoopInstalled) ) {
                throw "Scoop is required to install apps"
            }

            # Check if the app is installed
            if ( Get-IsAppInstalled -app $app ) {
                $logger.info("$app is already installed.")

                if ( -not $ignoreUpdate ) {
                    # Update the already installed app.
                    $logger.info("$app is already installed.  Checking for updates starting...`n")
                    Invoke-Expression "scoop update $app"
                    $logger.info("$app checking for updates completed.")
                }
            } else {
                # Install the app
                $logger.info("$app installer starting...`n")
                Invoke-Expression "scoop install $app"
                $logger.info("$app installer completed.")                
            }
            
            $logger.debug('Completed.')
        } catch {
            $logger.error("Failed: $_")
            throw "$_"
        }
    }
}