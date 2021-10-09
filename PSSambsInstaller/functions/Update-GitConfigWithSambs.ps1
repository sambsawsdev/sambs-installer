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

            # Get the sambsConfig
            [SambsConfig]$sambsConfig = Get-SambsConfig            

            # Save the sambsConfig to Git
            $logger.info("Git user config update starting...`n")
            Invoke-Expression "git config --global user.email `"$($sambsConfig.email)`""
            Invoke-Expression "git config --global user.name `"$($sambsConfig.fullName)`""
            $logger.info("Git user config update completed.")

            # Get the sambsDevProfileConfig
            [SambsDevProfileConfig]$sambsDevProfileConfig = Get-SambsDevProfileConfig           

            # Save the credential manager
            $logger.info("Git credential config update starting...`n")
            Invoke-Expression "git config --global credential.https://git-codecommit.$($sambsDevProfileConfig.sso_region).amazonaws.com.helper '!aws --profile $($sambsDevProfileConfig.name) codecommit credential-helper $@'"
            Invoke-Expression "git config --global credential.https://git-codecommit.$($sambsDevProfileConfig.sso_region).amazonaws.com.UseHttpPath true"
            
            # Todo: Should we set this??
            Invoke-Expression "git config --global credential.https://github.com.helper manager-core"
            $logger.info("Git credential config update completed.")

            $logger.debug("Completed.")
        } catch {
            $logger.error("Failed: $_")
            throw "$_"
        }
    }    
}