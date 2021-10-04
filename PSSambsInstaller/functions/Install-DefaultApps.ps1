function Install-DefaultApps {
    Param (
        [Parameter(Mandatory=$false, Position=0)]
        [switch]$ignoreUpdate
    )
    
    Process {
        try {
            $logger.debug("Starting. [$ignoreUpdate]")

            # Install Git
            Install-ScoopApp -app 'git' $ignoreUpdate

            # Install sambs bucket
            Install-Bucket -bucket 'sambs' -bucketRepo 'https://github.com/sambsawsdev/sambs-scoop'
            # Install sambs-installer
            Install-ScoopApp -app 'sambs-installer' $ignoreUpdate

            # Install AWS
            Install-ScoopApp -app 'aws' $ignoreUpdate

            #Install python
            Install-ScoopApp -app 'python' $ignoreUpdate
            # Update pip using pip
            Install-PipApp -app 'pip' $ignoreUpdate
            # Install git-remote-codecommit
            Install-PipApp -app 'git-remote-codecommit' $ignoreUpdate
            
            # Install extras bucket
            Install-Bucket -bucket 'extras'

            $logger.debug('Completed.')
        } catch {
            $logger.error("Failed: $_")
            throw "$_"
        }
    }
}
