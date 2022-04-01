class InstallConfig {
    [string]$email='None'
    [string]$fullName='None'
    [string]$repoPath=(Resolve-Path -LiteralPath '.')
    [string]$packagePath=(Join-Path -Path $env:sambsHome -ChildPath '/packages')

    [string] toString() {
        return $this | ConvertTo-Json -Depth 2 -Compress
    }
}

function Get-InstallConfig {
    [OutputType([InstallConfig])]
    Param()
    
    Begin {
        # Check if the installConfigFilePath exists
        [string]$installConfigFilePath = Join-Path -Path $HOME -ChildPath '/.config/sambs/sambs.install.json'
        if ( -not ( Test-Path -LiteralPath $installConfigFilePath -PathType Leaf ) ) {
            # Create the installConfigFilePath
            $null = New-Item -Path $installConfigFilePath -ItemType File -Force
        }
    }

    Process {
        try {
            $logger.debug("Starting.")
            # Read the installConfig json file
            $installConfigJson = Get-Content -Path $installConfigFilePath -Raw | ConvertFrom-Json
            # Create the installConfig object
            [InstallConfig]$installConfig = ConvertTo-Class -sourceJson $installConfigJson -destination ([InstallConfig]::new())

            $logger.debug("Completed. '$($installConfig.toString())'")
            return $installConfig
        } catch {
            $logger.error("Failed: $_")
            throw "$_"
        }
    }
}