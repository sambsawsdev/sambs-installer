function Get-DevProfileConfig {
    [OutputType([DevProfileConfig])]
    Param()

    Begin {
        # Check if the devProfileConfigFilePath exists
        [string]$devProfileConfigFilePath = Join-Path -Path $HOME -ChildPath '/.config/sambs/sambs.devProfile.json'
        if ( -not ( Test-Path -LiteralPath $devProfileConfigFilePath -PathType Leaf ) ) {
            # Create the devProfileConfigFilePath
            $null = New-Item -Path $devProfileConfigFilePath -ItemType File -Force
        }
    }

    Process {
        try {
            $logger.debug("Starting.")
            # Read the devProfileConfigFilePath from the json
            $devProfileConfigJson = Get-Content -Path $devProfileConfigFilePath -Raw | ConvertFrom-Json
            
            # Create the devProfileConfig object
            [DevProfileConfig]$devProfileConfig = ConvertTo-Class -sourceJson $devProfileConfigJson -destination ([DevProfileConfig]::new())

            $logger.debug("Completed. '$($devProfileConfig.toString())'")
            return $devProfileConfig
        } catch {
            $logger.error("Failed: $_")
            throw "$_"
        }
    }
}