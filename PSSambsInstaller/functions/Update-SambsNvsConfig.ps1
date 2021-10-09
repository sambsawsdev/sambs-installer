function Update-SambsNvsConfig {
    Param (
        [Parameter(Mandatory=$false, ValueFromRemainingArguments=$true)]
        [Object[]]$arguments    
    )

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
            $logger.debug("Starting. [$arguments]")

            # Get the existing sambsNvsConfig
            [SambsNvsConfig]$sambsNvsConfig = Get-SambsNvsConfig

            [string]$prefix = 'Sambs nvs config'
            $logger.info("$prefix update starting...`n")

            # Get the nodeVersion
            $response = Read-Host "$prefix Node version [$($sambsNvsConfig.nodeVersion)]"
            # If user just presses enter then use the existing value
            if (-not [string]::IsNullOrWhiteSpace($response)) {
                $sambsNvsConfig.nodeVersion = $response
            }
            # Get the yarnVersion
            $response = Read-Host "$prefix Yarn [Global] version [$($sambsNvsConfig.yarnVersion)]"
            # If user just presses enter then use the existing value
            if (-not [string]::IsNullOrWhiteSpace($response)) {
                $sambsNvsConfig.yarnVersion = $response
            }

            # Save the sambs dev profile config
            $logger.debug("Saving sambs nvs config '$($sambsNvsConfig.ToString())'")
            $sambsNvsConfig | ConvertTo-Json -Depth 2 | Out-File $sambsNvsConfigFilePath -Force
            $logger.debug("Saved sambs nvs config '$sambsNvsConfigFilePath'")

            $logger.info("$prefix update completed.")

            $logger.debug("Completed. $($sambsNvsConfig.toString())")
            return $sambsNvsConfig
        } catch {
            $logger.error("Failed: $_")
            throw "$_"
        }
    }
}

