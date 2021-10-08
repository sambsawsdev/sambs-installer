function ConvertTo-Class {
    Param (
        [Parameter(Mandatory=$false, Position=0)]
        [Object]$sourceJson,
        [Parameter(Mandatory=$true, Position=1)]
        [Object]$destination
    )
    
    Process {
        try {
            $logger.debug("Starting. [$sourceJson, $($destination.toString())]")

            # Ensure the sourceJson is not null
            if ($null -ne $sourceJson) {
            
                # Loop through all the properties of the destination
                $destination | Get-Member -MemberType Properties | ForEach-Object {
                    # Ensure the property on the json is not null
                    if (-not [string]::IsNullOrWhiteSpace($sourceJson."$($_.Name)")) {
                        # Populate the destination property with the value from the json
                        $destination."$($_.Name)" = $sourceJson."$($_.Name)"
                    }
                }
            }

            $logger.debug("Completed $($destination.toString())")
            return $destination
        } catch {
            $logger.error("Failed: $_")
            throw "$_"
        }
    }
}