function Test-ScoopInstalled {
    Process {
        try {
            $logger.debug('Starting.')
            
            # Scoop is on the path
            if (Get-Command scoop -ErrorAction SilentlyContinue) {
                # Todo: Ensure $env:SCOOP set correctly
                $logger.debug("Completed. $true")
                return $true
            }

            # Check if env:SCOOP is set
            if ( -not [string]::IsNullOrWhiteSpace($env:SCOOP) ) {
                # Check if there is a shim for scoop at env:SCOOP
                [string]$scoopFilePath = Join-Path -Path $env:SCOOP -ChildPath '/shims/scoop'
                if ( Test-Path -LiteralPath $scoopFilePath -PathType Leaf ) {
                    # Scoop is installed but $env:SCOOP\shims is not on the path.  Add it to the path
                    $env:Path = "$env:SCOOP\shims;$env:Path"
                    $logger.debug("Completed. $true")
                    return $true
                }
            }
                        
            $logger.debug("Completed. $false")
            return $false
        } catch {
            $logger.error("Failed: $_")
            throw "$_"
        }
    }
}