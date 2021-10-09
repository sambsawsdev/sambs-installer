function Invoke-SsoLogin {
    Param(
        [Parameter(Mandatory=$false, Position=0)]
        [string]$ssoProfile,
        [Parameter(Mandatory=$false, ValueFromRemainingArguments=$true)]
        [Object[]]$arguments    

    )

    Begin {
        $help = [PSCustomObject]@{
            summary = 'Starts the aws-cli sso login for the provided ssoProfile'
            usage = 'Usage: sambs-installer login [-ssoProfile <ssoProfile>]

Where:
    ssoProfile     [default = name from sambs dev profile]The name of the ssoProfile to use for aws-cli sso login'

            example = 'Example: 
    sambs-installer login sso-aws-sambs-dev'
        }
    }

    Process {
        try {
            $logger.debug("Starting. [$ssoProfile, $arguments]")

            # Get the ssoProfile from sambs dev profile config
            if ([string]::IsNullOrWhiteSpace($ssoProfile)) {
                [SambsDevProfileConfig]$sambsDevProfileConfig = Get-SambsDevProfileConfig
                $ssoProfile = $sambsDevProfileConfig.name
            }

            # Show help
            if ([string]::IsNullOrWhiteSpace($ssoProfile) -or $ssoProfile -ieq 'help') {
                $logger.showHelp($help)
                return
            }

            # Check if aws is installed
            if ( -not ( Test-PipAppInstalled -app 'aws-sso-util' ) ) {
                throw 'Aws-sso-util is required to login to aws via sso.'
            }

            $logger.info("Sso login to aws starting...`n")
            Invoke-Expression "aws-sso-util login --profile $ssoProfile"
            $logger.info("Sso login to aws completed.")

            $logger.debug('Completed.')
        } catch {
            $logger.error("Failed: $_")
            throw "$_"
        }
    }
}
