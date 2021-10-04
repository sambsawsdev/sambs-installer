function Install-Scoop {
    Param (
        [Parameter(Mandatory=$false, Position=0)]
        [string]$sambsHome,
        [Parameter(Mandatory=$false, Position=1)]
        [switch]$ignoreUpdate
    )

    Begin {
        $logger.debug("Starting. [$sambsHome, $ignoreUpdate]")

        # Set sambsHome
        $sambsHome = Set-SambsHome -sambsHome $sambsHome
        $logger.info("Using sambsHome $sambsHome")
    }
    
    Process {
        try {
            # Check if scoop is already installed
            if ( -not (Get-IsScoopInstalled) ) {
                $logger.info("Scoop Web-Installer starting...`n")
                # Run the installer
                Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://get.scoop.sh')
                $logger.info("Scoop Web-Installer completed.")          

            } else {
                $logger.info("Scoop is already installed.")

                if ( -not $ignoreUpdate ) {
                    # Git is required for update
                    if ( -not (Get-IsScoopAppInstalled -app 'git') ) {
                        # Install git
                        $logger.info('Git is required for updates.')
                        $logger.info('Installing git starting...')
                        Install-ScoopApp -app 'git' $ignoreUpdate
                        $logger.info('Installing git completed.')
                    }

                    $logger.info("Cheking for updates starting...`n")
                    Invoke-Expression 'scoop update'
                    $logger.info('Cheking for updates completed.')
                }
            }

            $logger.debug('Completed.')
        } catch {
            $logger.error("Failed: $_")
            throw "$_"
        }
    }
}