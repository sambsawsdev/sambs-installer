function Test-PipAppInstalled {
    Param (
        [Parameter(Mandatory=$true, Position=0)]
        [string]$app
    )

    Process {
        try {
            $logger.debug("Starting. [$app]")

            # Ensure pip is installed
            if ( -not (Test-PipInstalled) ) {
                throw "Pip is required to check if apps are installed."
            }

            # Get the list of installed apps using scoop export
            [bool]$isInstalled = $false
            [string[]]$apps = Invoke-Expression 'pip --disable-pip-version-check list' | ForEach-Object { return $_.split(" ")[0].ToLower() }
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