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

            # Get the nvsConfig
            [NvsConfig]$nvsConfig = Get-NvsConfig            

            # Save the nvsConfig to Nvs
            $logger.info("Nvs config update starting...`n")
            Invoke-Expression "nvs install"
            Invoke-Expression "nvs auto on"
            Invoke-Expression "nvs add $($nvsConfig.nodeVersion)"
            Invoke-Expression "nvs link $($nvsConfig.nodeVersion)"
            Invoke-Expression "nvs use $($nvsConfig.nodeVersion)"
            
            Invoke-Expression "npm install --global yarn@`"$($nvsConfig.yarnVersion)`""
            #Invoke-Expression "npm install --global aws-cdk@`"$($nvsConfig.awscdkVersion)`""
            $logger.info("Nvs config update completed.")


            $logger.debug("Completed.")
        } catch {
            $logger.error("Failed: $_")
            throw "$_"
        }
    }    
}