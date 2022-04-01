function Update-DevProfileConfig {
    Param (
        [Parameter(Mandatory=$false, ValueFromRemainingArguments=$true)]
        [Object[]]$arguments    
    )

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
            $logger.debug("Starting. [$arguments]")

            # Get the existing devProfileConfig
            [DevProfileConfig]$devProfileConfig = Get-DevProfileConfig

            [string]$prefix = 'Sambs dev profile config'
            $logger.info("$prefix update starting...`n")

            # Get the name
            $response = Read-Host "$prefix name [$($devProfileConfig.name)]"
            # If user just presses enter then use the existing value
            if (-not [string]::IsNullOrWhiteSpace($response)) {
                $devProfileConfig.name = $response
            }
            # Get the sso_start_url
            $response = Read-Host "$prefix SSO start URL [$($devProfileConfig.sso_start_url)]"
            # If user just presses enter then use the existing value
            if (-not [string]::IsNullOrWhiteSpace($response)) {
                $devProfileConfig.sso_start_url = $response
            }
            # Get the sso_region
            $response = Read-Host "$prefix SSO region [$($devProfileConfig.sso_region)]"
            # If user just presses enter then use the existing value
            if (-not [string]::IsNullOrWhiteSpace($response)) {
                $devProfileConfig.sso_region = $response
            }
            # Get the sso_account_id
            $response = Read-Host "$prefix SSO account id [$($devProfileConfig.sso_account_id)]"
            # If user just presses enter then use the existing value
            if (-not [string]::IsNullOrWhiteSpace($response)) {
                $devProfileConfig.sso_account_id = $response
            }
            # Get the sso_role_name
            $response = Read-Host "$prefix SSO role name [$($devProfileConfig.sso_role_name)]"
            # If user just presses enter then use the existing value
            if (-not [string]::IsNullOrWhiteSpace($response)) {
                $devProfileConfig.sso_role_name = $response
            }
            # Get the region
            $response = Read-Host "$prefix CLI client region [$($devProfileConfig.region)]"
            # If user just presses enter then use the existing value
            if (-not [string]::IsNullOrWhiteSpace($response)) {
                $devProfileConfig.region = $response
            }
            # Get the output
            $response = Read-Host "$prefix CLI output format [$($devProfileConfig.output)]"
            # If user just presses enter then use the existing value
            if (-not [string]::IsNullOrWhiteSpace($response)) {
                $devProfileConfig.output = $response
            }

            # Save the sambs dev profile config
            $logger.debug("Saving sambs dev profile config '$($devProfileConfig.ToString())'")
            $utf8NoBomEncoding = New-Object System.Text.UTF8Encoding $False
            [System.IO.File]::WriteAllLines($devProfileConfigFilePath, $devProfileConfig.toString(), $utf8NoBomEncoding)    
            $logger.debug("Saved sambs dev profile config '$devProfileConfigFilePath'")

            $logger.info("$prefix update completed.")

            $logger.debug("Completed. $($devProfileConfig.toString())")
            return $devProfileConfig
        } catch {
            $logger.error("Failed: $_")
            throw "$_"
        }
    }
}
