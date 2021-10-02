function Get-IsAppInstalled {
    Param (
        [Parameter(Mandatory=$true, Position=0)]
        [string]$app
    )

    Process {
        try {
            $logger.debug("Starting. [$app]")

            # Ensure scoop is installed
            if ( -not (Get-IsScoopInstalled) ) {
                throw "Scoop is required to check if apps are installed."
            }

            # Get the list of installed apps using scoop export
            [bool]$isInstalled = $false
            [string[]]$apps = Invoke-Expression 'scoop export' | ForEach-Object { return $_.split(" ")[0].ToLower() }
            if ($null -ne $apps) {
                $isInstalled = $apps.Contains($app.ToLower())
            }
                        
            $logger.debug("Completed. $isInstalled")
            return $isInstalled
        } catch {
            $logger.error("Failed: $_")
            throw "$_"
        }
    }
}