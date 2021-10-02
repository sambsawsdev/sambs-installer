function Set-ScoopBySambsHome {
    Param (
        [Parameter(Mandatory=$false, Position=0)]
        [string]$sambsHome
    )

    Process {
        try {
            $logger.debug("Starting. [$sambsHome]")

            # Set the scoopPath to <sambsHome>/scoop
            [string]$scoopPath = Join-Path -Path $sambsHome -ChildPath '/scoop'
            $logger.debug("Using scoopPath $scoopPath")
            
            # Create the directory
            if ( -not ( Test-Path -LiteralPath $scoopPath -PathType Container ) ) {
                $logger.info("Creating scoop path $scoopPath")
                $null = New-Item -Path $scoopPath -ItemType Directory -Force
            }
            
            # Set env:SCOOP
            $logger.debug("Setting env:SCOOP $scoopPath")
            [System.Environment]::SetEnvironmentVariable('SCOOP', $scoopPath, 'User')
            $env:SCOOP = $scoopPath

            $logger.debug("Completed. $scoopPath")
            return $scoopPath        
        } catch {
            $logger.error("Failed: $_")
            throw "$_"
        }
    }
}