function Update-SambsConfig {
    Param (
        [Parameter(Mandatory=$false, ValueFromRemainingArguments=$true)]
        [Object[]]$arguments    
    )

    Begin {
        # Check if the sambsConfigFilePath exists
        [string]$sambsConfigFilePath = Join-Path -Path $HOME -ChildPath '/.config/sambs/sambs.config.json'
        if ( -not ( Test-Path -LiteralPath $sambsConfigFilePath -PathType Leaf ) ) {
            # Create the sambsConfigFilePath
            $null = New-Item -Path $sambsConfigFilePath -ItemType File -Force
        }
    }

    Process {
        try {
            $logger.debug("Starting. [$arguments]")

            # Get the existing config
            [SambsConfig]$sambsConfig = Get-SambsConfig

            $logger.info("Sambs config update starting...`n")

            # Get the email
            $sambsConfig.email = Get-ValidEmail -email $sambsConfig.email
            # Get the fullName
            $newFullNameResponse = Read-Host "Full name [$($sambsConfig.fullName)]"
            # If user just presses enter then use the existing value
            if (-not [string]::IsNullOrWhiteSpace($newFullNameResponse)) {
                $sambsConfig.fullName = $newFullNameResponse
            }

            # Save the sambs config
            $logger.debug("Saving sambs config '$($sambsConfig.ToString())'")
            $sambsConfig | ConvertTo-Json -Depth 2 | Out-File $sambsConfigFilePath -Force
            $logger.debug("Saved sambs config '$sambsConfigFilePath'")

            # Update the sambsDevProfileConfig
            #[SambsDevProfileConfig]$sambsDevProfileConfig = Update-SambsDevProfileConfig $arguments
            $null = Update-SambsDevProfileConfig $arguments
            # Update the sambsNvsConfig
            $null = Update-SambsNvsConfig $arguments
            # Update AWS with the sambsDevProfileConfig
            Update-AwsConfigWithSambs $arguments
            # Update Git with the sambsConfig
            Update-GitConfigWithSambs $arguments
            # Update Nvs with the sambsNvsConfig
            Update-NvsConfigWithSambs $arguments
            $logger.info("Sambs config update completed.")

            # Login to aws using sso
            #Invoke-SsoLogin -profile $sambsDevProfileConfig.name
            Invoke-SsoLogin

            $logger.debug("Completed. $($sambsConfig.toString())")
            return $sambsConfig
        } catch {
            $logger.error("Failed: $_")
            throw "$_"
        }
    }
}