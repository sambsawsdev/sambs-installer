function Install-PipApp {
    Param (
        [Parameter(Mandatory=$true, Position=0)]
        [string]$app,
        [Parameter(Mandatory=$false, Position=1)]
        [switch]$ignoreUpdate
    )

    Process {
        try {
            $logger.debug("Starting. [$app]")

            # Ensure pip is installed
            if ( -not (Test-PipInstalled) ) {
                throw "Pip is required to install apps"
            }

            # Check if the app is installed
            if ( Test-PipAppInstalled -app $app ) {
                $logger.info("$app is already installed.")

                #--disable-pip-version-check
                if ( -not $ignoreUpdate ) {
                    # Update the already installed app.
                    $logger.info("$app is already installed.  Checking for updates starting...`n")
                    Invoke-Expression "pip --disable-pip-version-check install --upgrade $app"
                    $logger.info("$app checking for updates completed.")
                }
            } else {
                # Install the app
                $logger.info("$app installer starting...`n")
                Invoke-Expression "pip --disable-pip-version-check install $app"
                $logger.info("$app installer completed.")                
            }
            
            $logger.debug('Completed.')
        } catch {
            $logger.error("Failed: $_")
            throw "$_"
        }
    }
}