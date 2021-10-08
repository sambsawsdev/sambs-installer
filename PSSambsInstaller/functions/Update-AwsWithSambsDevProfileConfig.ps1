function Update-AwsWithSambsDevProfileConfig {
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

                #$logger.warn('Aws-cli is required to updated aws config with sambs dev profile.')

                # Install aws-cli if not already installed
                #Install-ScoopApp -app 'aws'
            }

            # Get the sambsDevProfileConfig
            [SambsDevProfileConfig]$sambsDevProfileConfig = Get-SambsDevProfileConfig            

            # Save the aws config
            $logger.info("Aws config update starting...`n")
            $sambsDevProfileConfig | Get-Member -MemberType Properties | ForEach-Object {
                Invoke-Expression "aws configure set $($_.Name) $($sambsDevProfileConfig.$($_.Name)) --profile $($sambsDevProfileConfig.name)"
            }
            $logger.info("Aws config update completed.")

            $logger.debug("Completed.")
        } catch {
            $logger.error("Failed: $_")
            throw "$_"
        }
    }
    
}