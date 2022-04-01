function Update-GitConfigWithSambs {
    Param (
        [Parameter(Mandatory=$false, ValueFromRemainingArguments=$true)]
        [Object[]]$arguments    
    )

    Process {
        try {
            $logger.debug("Starting. [$arguments]")

            # Check if git is installed
            if ( -not ( Test-ScoopAppInstalled -app 'git' ) ) {
                throw 'Git is required to update git config with sambs config.'
            }

            # Get the installConfig
            #[InstallConfig]$installConfig = Get-InstallConfig            
            $installConfig = Get-InstallConfig            

            # Save the installConfig to Git
            $logger.info("Git user config update starting...`n")
            Invoke-Expression "git config --global user.email `"$($installConfig.email)`""
            Invoke-Expression "git config --global user.name `"$($installConfig.fullName)`""
            $logger.info("Git user config update completed.")

            # Get the devProfileConfig
            [DevProfileConfig]$devProfileConfig = Get-DevProfileConfig           

            # Save the credential manager
            $logger.info("Git credential config update starting...`n")
            Invoke-Expression "git config --global credential.https://git-codecommit.$($devProfileConfig.sso_region).amazonaws.com.helper '!aws --profile $($devProfileConfig.name) codecommit credential-helper $@'"
            Invoke-Expression "git config --global credential.https://git-codecommit.$($devProfileConfig.sso_region).amazonaws.com.UseHttpPath true"
            
            # Todo: Should we set this??
            Invoke-Expression "git config --global credential.https://github.com.helper manager-core"
            Invoke-Expression "git config --global pull.rebase false"
            $logger.info("Git credential config update completed.")

            $logger.debug("Completed.")
        } catch {
            $logger.error("Failed: $_")
            throw "$_"
        }
    }    
}