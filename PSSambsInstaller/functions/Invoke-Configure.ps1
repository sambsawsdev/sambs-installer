function Invoke-Configure {
    Param(
        [Parameter(Mandatory=$false, Position=0)]
        [string[]]$configs,
        [Parameter(Mandatory=$false, ValueFromRemainingArguments=$true)]
        [Object[]]$arguments    

    )

    Begin {
        $help = [PSCustomObject]@{
            summary = 'Configures the sambs environment including sso for aws, git-remote-codecommit'
            usage = 'Usage: sambs-installer configure [-configs] <configs>

Where:
    configs     [sambs|devProfile|aws|git] The name(s) of the items to configure

Where configs:
    sambs       Will update the sambs config, sambs dev profile and aws
    devProfile  Update the sambs dev profile config
    aws         Update aws config with the sambs dev profile config
    git         Update git with the sambs config'
            example = 'Example: 
    sambs-installer configure sambs
    sambs-installer configure -configs aws, git'
        }
    }

    Process {
        try {
            $logger.debug("Starting. [$configs, $arguments]")

            # Show help
            if ([string]::IsNullOrWhiteSpace($configs) -or $configs -ieq 'help') {
                $logger.showHelp($help)
                return
            }

            foreach($config in $configs){
                switch ($config.toLower()) {
                    'sambs' { $null = Update-SambsConfig $arguments }
                    'devprofile' { $null = Update-SambsDevProfileConfig $arguments }
                    'aws' { Update-AwsWithSambsDevProfileConfig $arguments  }
                    'git' { Invoke-Expression "Update-GitConfig $arguments" } #Todo: Must implement
                    Default {
                        # Config is not known
                        # Show help
                        $logger.error("Unknown config '$config'")
                        $logger.showHelp($help)
                        throw "Unknown config '$config'"
                    }
                }
            }

            $logger.debug('Completed.')
        } catch {
            $logger.error("Failed: $_")
            throw "$_"
        }
    }
}
