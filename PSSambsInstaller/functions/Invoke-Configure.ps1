function Invoke-Configure {
    Param(
        [Parameter(Mandatory=$false, Position=0)]
        [string[]]$configs='sambs',
        [Parameter(Mandatory=$false, ValueFromRemainingArguments=$true)]
        [Object[]]$arguments    

    )

    Begin {
        $help = [PSCustomObject]@{
            summary = 'Configures the sambs environment including sso for aws, git-remote-codecommit'
            usage = 'Usage: sambs-installer configure [-configs "<configs>"]

Where:
    configs     [default = sambs] The name(s) of the items to configure

Where configs:
    sambs       [default] Will update the sambs config, sambs dev profile, sambs nvs config, aws, git and nvs
    devProfile  Update the sambs dev profile config
    nvsConfig   Update the sambs nvs config
    aws         Update aws config with the sambs dev profile config
    git         Update git config with the sambs config
    nvs         Update nvs config with the sambs nvs config'
            example = 'Example: 
    sambs-installer configure sambs
    sambs-installer configure -configs "aws, git"'
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
                    'sambs' { $null = Update-InstallConfig $arguments }
                    'devprofile' { $null = Update-DevProfileConfig $arguments }
                    'nvsconfig' { $null = Update-NvsConfig $arguments }
                    'aws' { $null = Update-AwsConfigWithSambs $arguments  }
                    'git' { $null = Update-GitConfigWithSambs $arguments }
                    'nvs' { $null = Update-NvsConfigWithSambs $arguments }
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
