function Get-NvsConfig {
    [OutputType([NvsConfig])]
    Param()

    Begin {
        # Check if the nvsConfigFilePath exists
        [string]$nvsConfigFilePath = Join-Path -Path $HOME -ChildPath '/.config/sambs/sambs.nvs.json'
        if ( -not ( Test-Path -LiteralPath $nvsConfigFilePath -PathType Leaf ) ) {
            # Create the nvsConfigFilePath
            $null = New-Item -Path $nvsConfigFilePath -ItemType File -Force
        }
    }

    Process {
        try {
            $logger.debug("Starting.")
            # Read the nvsConfigFilePath from the json
            $nvsConfigJson = Get-Content -Path $nvsConfigFilePath -Raw | ConvertFrom-Json
            
            # Create the nvsConfig object
            [NvsConfig]$nvsConfig = ConvertTo-Class -sourceJson $nvsConfigJson -destination ([NvsConfig]::new())

            $logger.debug("Completed. '$($nvsConfig.toString())'")
            return $nvsConfig
        } catch {
            $logger.error("Failed: $_")
            throw "$_"
        }
    }
}