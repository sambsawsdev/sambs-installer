function Get-SambsDevProfileConfig {
    [OutputType([SambsDevProfileConfig])]
    Param()

    Begin {
        # Check if the sambsDevProfileConfigFilePath exists
        [string]$sambsDevProfileConfigFilePath = Join-Path -Path $HOME -ChildPath '/.config/sambs/sambs.devProfileConfig.json'
        if ( -not ( Test-Path -LiteralPath $sambsDevProfileConfigFilePath -PathType Leaf ) ) {
            # Create the sambsDevProfileConfigFilePath
            $null = New-Item -Path $sambsDevProfileConfigFilePath -ItemType File -Force
        }
    }

    Process {
        try {
            $logger.debug("Starting.")
            # Read the sambsDevProfileConfigFilePath from the json
            $sambsDevProfileConfigJson = Get-Content -Path $sambsDevProfileConfigFilePath -Raw | ConvertFrom-Json
            
            # Create the sambsDevProfileConfig object
            [SambsDevProfileConfig]$sambsDevProfileConfig = ConvertTo-Class -sourceJson $sambsDevProfileConfigJson -destination ([SambsDevProfileConfig]::new())

            $logger.debug("Completed. '$($sambsDevProfileConfig.toString())'")
            return $sambsDevProfileConfig
        } catch {
            $logger.error("Failed: $_")
            throw "$_"
        }
    }
}