function Get-IsBucketInstalled {
    Param (
        [Parameter(Mandatory=$true, Position=0)]
        [string]$bucket
    )

    Process {
        try {
            $logger.debug("Starting. [$bucket]")

            # Ensure scoop is installed
            if ( -not (Get-IsScoopInstalled) ) {
                throw "Scoop is required to check if buckets are installed."
            }

            # Get the list of installed buckets using scoop bucket list
            [bool]$isInstalled = $false
            [string[]]$buckets = Invoke-Expression 'scoop bucket list' | ForEach-Object { return $_.ToLower() }
            if ($null -ne $buckets) {
                $isInstalled = $buckets.Contains($bucket.ToLower())
            }
                        
            $logger.debug("Completed. $isInstalled")
            return $isInstalled
        } catch {
            $logger.error("Failed: $_")
            throw "$_"
        }
    }
}