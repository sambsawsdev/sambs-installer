function Install-Bucket {
    Param (
        [Parameter(Mandatory=$false, Position=0)]
        [string]$bucket,
        [Parameter(Mandatory=$false, Position=1)]
        [string]$bucketRepo
    )
    
    Process {
        try {
            $logger.debug("Starting. [$bucket, $bucketRepo]")

            # Ensure scoop is installed
            if ( -not (Test-ScoopInstalled) ) {
                throw "Scoop is required to install buckets."
            }

            if ( Test-BucketInstalled -bucket $bucket ) {
                $logger.info("$bucket bucket is already installed.")
            } else {
                # Git is required for install bucket
                if ( -not (Test-ScoopAppInstalled -app 'git') ) {
                    # Install git
                    $logger.info('Git is required for bucket install.')
                    $logger.info('Installing git starting...')
                    Install-ScoopApp -app 'git' $ignoreUpdate
                    $logger.info('Installing git completed.')
                }
                
                $logger.info("$bucket bucket installer starting...`n")
                # Add bucket
                Invoke-Expression "scoop bucket add $bucket $bucketRepo"
                $logger.info("$bucket bucket installer completed.")                
            }

            $logger.debug('Completed.')
        } catch {
            $logger.error("Failed: $_")
            throw "$_"
        }
    }
}
