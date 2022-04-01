function Add-Package {
    Param (
        [Parameter(Mandatory=$true, Position=0)]
        [Uri]$packageUri,
        [Parameter(Mandatory=$false, Position=1)]
        [string]$packageName,
        [Parameter(Mandatory=$false, ValueFromRemainingArguments=$true)]
        [Object[]]$arguments    
    )

    Begin {
        # Create the package path if it does not exist
        [string]$packagePath = Join-Path -Path $env:SAMBS_HOME -ChildPath '/scoop/persist/sambs-installer/package'
        if ( -not ( Test-Path -LiteralPath $packagePath -PathType Container ) ) {
            $null = New-Item -Path $packagePath -ItemType Directory -Force
        }        
    }

    Process {
        try {
            $logger.debug("Starting. [$packageUri, $packageName, $arguments]")
            # Get the packageName from the Uri
            if ([string]::IsNullOrWhiteSpace($packageName)) {
                $packageName = $packageUri.Segments | Select-Object -Last 1
            }

            # Remove .json from end of packageName if there
            if ($packageName.EndsWith('.json') ) {
                $packageName = $packageName.Substring(0, $packageName.LastIndexOf('.json'))
            }   

            # Download the package
            [string]$packageFilePath = Join-Path -Path $packagePath -ChildPath "$packageName.json"
            [System.Net.WebClient]$webClient = [System.Net.WebClient]::new() 
            $webClient.DownloadFile($packageUri, $packageFilePath)

            $logger.debug("Completed. $packageFilePath")
            return $packageFilePath
        } catch {
            $logger.error("Failed: $_")
            throw "$_"
        }
    }
}