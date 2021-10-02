function Set-SambsHome {
    Param (
        [Parameter(Mandatory=$false, Position=0)]
        [string]$sambsHome
    )

    Process {
        try {
            $logger.debug("Starting. [$sambsHome]")

            # Check if a sambsHome has been provided
            if ( -not [string]::IsNullOrWhiteSpace($sambsHome) ) {
                # Check if the provided sambsHome is different to env:sambsHome
                if ( ($sambsHome -ine $env:sambsHome) -and (-not [string]::IsNullOrWhiteSpace($env:sambsHome)) ) {
                    # Confirm if want to change to new sambsHome
                    $logger.warn("SambsHome is currently set to $env:sambsHome for $env:userName.`nYou will need to manually fix the environment if you switch to sambsHome $sambsHome.")
                    $changeSambsHome = Read-Host "Would you still like to switch to sambsHome $sambsHome [y/N]? "

                    # Do not change the sambsHome
                    if ($changeSambsHome -ine 'y') {
                        $sambsHome = $env:sambsHome
                        $logger.info("Setting sambsHome $sambsHome")
                    }
                }
            } else {
                # Use env:sambsHome
                $sambsHome = $env:sambsHome
            }

            # Set sambsHome to <HOME>/.sambs by default
            if ( [string]::IsNullOrWhiteSpace($sambsHome) ) {
                $sambsHome = Join-Path $HOME -ChildPath '/.sambs'
                $logger.info("Setting sambsHome $sambsHome")
            }
            
            # Set env:sambsHome
            $logger.debug("Setting env:sambsHome $sambsHome")            
            [System.Environment]::SetEnvironmentVariable('sambsHome', $sambsHome, 'User')
            $env:sambsHome = $sambsHome
            
            # Set env:SCOOP
            $null = Set-ScoopBySambsHome -sambsHome $sambsHome

            $logger.debug("Completed. $sambsHome")
            return $sambsHome        
        } catch {
            $logger.error("Failed: $_")
            throw "$_"
        }
    }
}