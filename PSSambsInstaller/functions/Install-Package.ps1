function Install-Package {
    Param (
        [Parameter(Mandatory=$true, Position=0)]
        <#
        [ValidateScript({
            if ( -not ( Test-Path -LiteralPath $_ -PathType Leaf ) ) {
                throw "Install-Package Failed: Can't find package '$_'"
            }

            return $true
        })]
        #>
        [string]$packageFilePath,
        [Parameter(Mandatory=$false, ValueFromRemainingArguments=$true)]
        [Object[]]$arguments    
    )

    Process {
        try {
            $logger.debug("Starting. [$packageFilePath, $arguments]")

            # Throw error if package is not found
            if ( -not ( Test-Path -LiteralPath $packageFilePath -PathType Leaf ) ) {
                throw "Can't find package '$packageFilePath'"
            }

            # Read the json from the file
            $packageJson = Get-Content -LiteralPath $packageFilePath -Raw | ConvertFrom-Json

            # Install all the buckets
            foreach ($bucket in $packageJson.buckets) {
                Install-Bucket -bucket $bucket.name -bucketRepo $bucket.repo
            }

            # Install all the scoopApps
            foreach ($scoopApp in $packageJson.scoopApps) {
                Install-ScoopApp -app $scoopApp.app
            }
           
            # Install all the pipApps
            foreach ($pipApp in $packageJson.pipApps) {
                Install-PipApp -app $pipApp.app
            }

            $logger.debug('Completed.')
        } catch {
            $logger.error("Failed: $_")
            throw "$_"
        }
    }
}
