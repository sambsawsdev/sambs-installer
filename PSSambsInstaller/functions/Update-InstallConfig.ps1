function Update-InstallConfig {
    Param (
        [Parameter(Mandatory=$false, ValueFromRemainingArguments=$true)]
        [Object[]]$arguments    
    )

    Begin {
        # Check if the installConfigFilePath exists
        [string]$installConfigFilePath = Join-Path -Path $HOME -ChildPath '/.config/sambs/sambs.install.json'
        if ( -not ( Test-Path -LiteralPath $installConfigFilePath -PathType Leaf ) ) {
            # Create the installConfigFilePath
            $null = New-Item -Path $installConfigFilePath -ItemType File -Force
        }
    }

    Process {
        try {
            $logger.debug("Starting. [$arguments]")

            # Get the existing config
            #[InstallConfig]$installConfig = Get-InstallConfig
            $installConfig = Get-InstallConfig

            $logger.info("Install config update starting...`n")

            # Get the email
            $installConfig.email = Get-ValidEmail -email $installConfig.email
            # Get the fullName
            [string]$response = Read-Host "Full name [$($installConfig.fullName)]"
            # If user just presses enter then use the existing value
            if (-not [string]::IsNullOrWhiteSpace($response)) {
                $installConfig.fullName = $response
            }
            # Get the repoPath
            # Todo: Validate
            $response = Read-Host "Sambs repository path [$($installConfig.repoPath)]"
            # If user just presses enter then use the existing value
            if (-not [string]::IsNullOrWhiteSpace($response)) {
                $installConfig.repoPath = $response
            }

            # Get the packagePath
            $response = Read-Host "Sambs package path [$($installConfig.packagePath)]"
            # If user just presses enter then use the existing value
            if (-not [string]::IsNullOrWhiteSpace($response)) {
                $installConfig.packagePath = $response
            }

            # Save the sambs config
            $logger.debug("Saving install config '$($installConfig.ToString())'")
            $utf8NoBomEncoding = New-Object System.Text.UTF8Encoding $False
            [System.IO.File]::WriteAllLines($installConfigFilePath, $installConfig.toString(), $utf8NoBomEncoding)    
            $logger.debug("Saved install config '$installConfigFilePath'")

            # Update the devProfileConfig
            #[DevProfileConfig]$devProfileConfig = Update-DevProfileConfig $arguments
            $null = Update-DevProfileConfig $arguments
            # Update the nvsConfig
            $null = Update-NvsConfig $arguments
            # Update AWS with the devProfileConfig
            Update-AwsConfigWithSambs $arguments
            # Update Git with the installConfig
            Update-GitConfigWithSambs $arguments
            # Update Nvs with the nvsConfig
            Update-NvsConfigWithSambs $arguments

            # Login to aws using sso
            #Invoke-SsoLogin -profile $devProfileConfig.name
            # Invoke-SsoLogin
            # Install the repo
            # Invoke-RepoClone
            $logger.info("Install config update completed.")

            $logger.debug("Completed. $($installConfig.toString())")
            return $installConfig
        } catch {
            $logger.error("Failed: $_")
            throw "$_"
        }
    }
}