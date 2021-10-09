function Get-SambsNvsConfig {
    [OutputType([SambsNvsConfig])]
    Param()

    Begin {
        # Check if the sambsNvsConfigFilePath exists
        [string]$sambsNvsConfigFilePath = Join-Path -Path $HOME -ChildPath '/.config/sambs/sambs.nvsConfig.json'
        if ( -not ( Test-Path -LiteralPath $sambsNvsConfigFilePath -PathType Leaf ) ) {
            # Create the sambsNvsConfigFilePath
            $null = New-Item -Path $sambsNvsConfigFilePath -ItemType File -Force
        }
    }

    Process {
        try {
            $logger.debug("Starting.")
            # Read the sambsNvsConfigFilePath from the json
            $sambsNvsConfigJson = Get-Content -Path $sambsNvsConfigFilePath -Raw | ConvertFrom-Json
            
            # Create the sambsNvsConfig object
            [SambsNvsConfig]$sambsNvsConfig = ConvertTo-Class -sourceJson $sambsNvsConfigJson -destination ([SambsNvsConfig]::new())

            $logger.debug("Completed. '$($sambsNvsConfig.toString())'")
            return $sambsNvsConfig
        } catch {
            $logger.error("Failed: $_")
            throw "$_"
        }
    }
}