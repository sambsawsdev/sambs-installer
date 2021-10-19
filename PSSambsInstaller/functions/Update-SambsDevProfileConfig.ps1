function Update-SambsDevProfileConfig {
    Param (
        [Parameter(Mandatory=$false, ValueFromRemainingArguments=$true)]
        [Object[]]$arguments    
    )

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
            $logger.debug("Starting. [$arguments]")

            # Get the existing sambsDevProfileConfig
            [SambsDevProfileConfig]$sambsDevProfileConfig = Get-SambsDevProfileConfig

            [string]$prefix = 'Sambs dev profile config'
            $logger.info("$prefix update starting...`n")

            # Get the name
            $response = Read-Host "$prefix name [$($sambsDevProfileConfig.name)]"
            # If user just presses enter then use the existing value
            if (-not [string]::IsNullOrWhiteSpace($response)) {
                $sambsDevProfileConfig.name = $response
            }
            # Get the sso_start_url
            $response = Read-Host "$prefix SSO start URL [$($sambsDevProfileConfig.sso_start_url)]"
            # If user just presses enter then use the existing value
            if (-not [string]::IsNullOrWhiteSpace($response)) {
                $sambsDevProfileConfig.sso_start_url = $response
            }
            # Get the sso_region
            $response = Read-Host "$prefix SSO region [$($sambsDevProfileConfig.sso_region)]"
            # If user just presses enter then use the existing value
            if (-not [string]::IsNullOrWhiteSpace($response)) {
                $sambsDevProfileConfig.sso_region = $response
            }
            # Get the sso_account_id
            $response = Read-Host "$prefix SSO account id [$($sambsDevProfileConfig.sso_account_id)]"
            # If user just presses enter then use the existing value
            if (-not [string]::IsNullOrWhiteSpace($response)) {
                $sambsDevProfileConfig.sso_account_id = $response
            }
            # Get the sso_role_name
            $response = Read-Host "$prefix SSO role name [$($sambsDevProfileConfig.sso_role_name)]"
            # If user just presses enter then use the existing value
            if (-not [string]::IsNullOrWhiteSpace($response)) {
                $sambsDevProfileConfig.sso_role_name = $response
            }
            # Get the region
            $response = Read-Host "$prefix CLI client region [$($sambsDevProfileConfig.region)]"
            # If user just presses enter then use the existing value
            if (-not [string]::IsNullOrWhiteSpace($response)) {
                $sambsDevProfileConfig.region = $response
            }
            # Get the output
            $response = Read-Host "$prefix CLI output format [$($sambsDevProfileConfig.output)]"
            # If user just presses enter then use the existing value
            if (-not [string]::IsNullOrWhiteSpace($response)) {
                $sambsDevProfileConfig.output = $response
            }

            # Save the sambs dev profile config
            $logger.debug("Saving sambs dev profile config '$($sambsDevProfileConfig.ToString())'")
            $utf8NoBomEncoding = New-Object System.Text.UTF8Encoding $False
            [System.IO.File]::WriteAllLines($sambsDevProfileConfigFilePath, $sambsDevProfileConfig.toString(), $utf8NoBomEncoding)    
            $logger.debug("Saved sambs dev profile config '$sambsDevProfileConfigFilePath'")

            $logger.info("$prefix update completed.")

            $logger.debug("Completed. $($sambsDevProfileConfig.toString())")
            return $sambsDevProfileConfig
        } catch {
            $logger.error("Failed: $_")
            throw "$_"
        }
    }
}
