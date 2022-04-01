function Update-NvsConfig {
    Param (
        [Parameter(Mandatory=$false, ValueFromRemainingArguments=$true)]
        [Object[]]$arguments    
    )

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
            $logger.debug("Starting. [$arguments]")

            # Get the existing nvsConfig
            [NvsConfig]$nvsConfig = Get-NvsConfig

            [string]$prefix = 'Sambs nvs config'
            $logger.info("$prefix update starting...`n")

            # Get the nodeVersion
            $response = Read-Host "$prefix Node version [$($nvsConfig.nodeVersion)]"
            # If user just presses enter then use the existing value
            if (-not [string]::IsNullOrWhiteSpace($response)) {
                $nvsConfig.nodeVersion = $response
            }
            # Get the yarnVersion
            $response = Read-Host "$prefix Yarn [Global] version [$($nvsConfig.yarnVersion)]"
            # If user just presses enter then use the existing value
            if (-not [string]::IsNullOrWhiteSpace($response)) {
                $nvsConfig.yarnVersion = $response
            }
            <#
            # Get the awscdkVersion
            $response = Read-Host "$prefix aws-cdk version [$($nvsConfig.awscdkVersion)]"
            # If user just presses enter then use the existing value
            if (-not [string]::IsNullOrWhiteSpace($response)) {
                $nvsConfig.awscdkVersion = $response
            }
            #>
            # Save the sambs dev profile config
            $logger.debug("Saving sambs nvs config '$($nvsConfig.ToString())'")
            $utf8NoBomEncoding = New-Object System.Text.UTF8Encoding $False
            [System.IO.File]::WriteAllLines($nvsConfigFilePath, $nvsConfig.toString(), $utf8NoBomEncoding)    
            $logger.debug("Saved sambs nvs config '$nvsConfigFilePath'")

            $logger.info("$prefix update completed.")

            $logger.debug("Completed. $($nvsConfig.toString())")
            return $nvsConfig
        } catch {
            $logger.error("Failed: $_")
            throw "$_"
        }
    }
}

