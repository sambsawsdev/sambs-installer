function Invoke-SsoLogin {
    Param(
        [Parameter(Mandatory=$false, Position=0)]
        [string]$profile,
        [Parameter(Mandatory=$false, ValueFromRemainingArguments=$true)]
        [Object[]]$arguments    

    )

    Begin {
        $help = [PSCustomObject]@{
            summary = 'Starts the aws-cli sso login for the provided profile'
            usage = 'Usage: sambs-installer login [-profile] <profile>

Where:
    profile     The name of the profile to use for aws-cli sso login'

            example = 'Example: 
    sambs-installer login sso-aws-sambs-dev'
        }
    }

    Process {
        try {
            $logger.debug("Starting. [$profile, $arguments]")

            # Todo: Handle default profile and error check if profile configured on aws

            # Show help
            if ([string]::IsNullOrWhiteSpace($profile) -or $profile -ieq 'help') {
                $logger.showHelp($help)
                return
            }

            # Check if aws is installed
            if ( -not ( Test-ScoopAppInstalled -app 'aws' ) ) {
                throw 'Aws-cli is required to login via sso.'
            }

            $logger.info("Sso login to aws starting...`n")
            Invoke-Expression "aws sso login --profile $profile"
            $logger.info("Sso login to aws completed.")

            $logger.debug('Completed.')
        } catch {
            $logger.error("Failed: $_")
            throw "$_"
        }
    }
}
