function Install-DefaultApps {
    Param (
        [Parameter(Mandatory=$false, Position=0)]
        [switch]$ignoreUpdate
    )
    
    Process {
        try {
            $logger.debug("Starting. [$ignoreUpdate]")

            # Install Git
            Install-App -app 'git' $ignoreUpdate
            # Install AWS
            Install-App -app 'aws' $ignoreUpdate

            # Install sambs bucket
            Install-Bucket -bucket 'sambs' -bucketRepo 'https://github.com/sambsawsdev/sambs-scoop'

            # Install sambs-installer
            Install-App -app 'sambs-installer' $ignoreUpdate

            # Install extras bucket
            #Install-Bucket -bucket 'extras'

            $logger.debug('Completed.')
        } catch {
            $logger.error("Failed: $_")
            throw "$_"
        }
    }
}