function Update-NvsConfigWithSambs {
    Param (
        [Parameter(Mandatory=$false, ValueFromRemainingArguments=$true)]
        [Object[]]$arguments    
    )

    Process {
        try {
            $logger.debug("Starting. [$arguments]")

            # Check if nvs is installed
            if ( -not ( Test-ScoopAppInstalled -app 'nvs' ) ) {
                throw 'Nvs is required to update nvs config with sambs nvs config.'
            }

            # Get the sambsNvsConfig
            [SambsNvsConfig]$sambsNvsConfig = Get-SambsNvsConfig            

            # Save the sambsNvsConfig to Nvs
            $logger.info("Nvs config update starting...`n")
            Invoke-Expression "nvs install"
            Invoke-Expression "nvs auto on"
            Invoke-Expression "nvs add $($sambsNvsConfig.nodeVersion)"
            Invoke-Expression "nvs link $($sambsNvsConfig.nodeVersion)"
            Invoke-Expression "nvs use $($sambsNvsConfig.nodeVersion)"
            
            Invoke-Expression "npm install --global yarn@`"$($sambsNvsConfig.yarnVersion)`""
            $logger.info("Nvs config update completed.")


            $logger.debug("Completed.")
        } catch {
            $logger.error("Failed: $_")
            throw "$_"
        }
    }    
}