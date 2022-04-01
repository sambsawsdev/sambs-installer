function Update-AwsConfigWithSambs {
    Param (
        [Parameter(Mandatory=$false, ValueFromRemainingArguments=$true)]
        [Object[]]$arguments    
    )

    Process {
        try {
            $logger.debug("Starting. [$arguments]")

            # Check if aws is installed
            if ( -not ( Test-ScoopAppInstalled -app 'aws' ) ) {
                throw 'Aws-cli is required to updated aws config with sambs dev profile.'
            }

            # Check if aws-sso-util is installed
            if ( -not ( Test-PipAppInstalled -app 'aws-sso-util' ) ) {
                throw 'Aws-sso-util is required to updated aws config with sambs dev profile.'
            }

            # Get the devProfileConfig
            [DevProfileConfig]$devProfileConfig = Get-DevProfileConfig            

            # Save the aws config
            $logger.info("Aws config update starting...`n")
            $devProfileConfig | Get-Member -MemberType Properties | ForEach-Object {
                Invoke-Expression "aws configure set $($_.Name) $($devProfileConfig.$($_.Name)) --profile $($devProfileConfig.name)"
            }

            # Configure the aws-sso-util
            Invoke-Expression "aws-sso-util configure profile $($devProfileConfig.name)"
            $logger.info("Aws config update completed.")

            $logger.debug("Completed.")
        } catch {
            $logger.error("Failed: $_")
            throw "$_"
        }
    }
    
}