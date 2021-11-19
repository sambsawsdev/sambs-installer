class SambsConfig {
    [string]$email='None'
    [string]$fullName='None'
    [string]$repoPath=(Resolve-Path -LiteralPath '.')
    [string]$packagePath=(Join-Path -Path $env:sambsHome -ChildPath '/packages')

    [string] toString() {
        return $this | ConvertTo-Json -Depth 2 -Compress
    }
}

function Get-SambsConfig {
    [OutputType([SambsConfig])]
    Param()
    
    Begin {
        # Check if the sambsConfigFilePath exists
        [string]$sambsConfigFilePath = Join-Path -Path $HOME -ChildPath '/.config/sambs/sambs.config.json'
        if ( -not ( Test-Path -LiteralPath $sambsConfigFilePath -PathType Leaf ) ) {
            # Create the sambsConfigFilePath
            $null = New-Item -Path $sambsConfigFilePath -ItemType File -Force
        }
    }

    Process {
        try {
            $logger.debug("Starting.")
            # Read the sambsConfig json file
            $sambsConfigJson = Get-Content -Path $sambsConfigFilePath -Raw | ConvertFrom-Json
            # Create the sambsConfig object
            [SambsConfig]$sambsConfig = ConvertTo-Class -sourceJson $sambsConfigJson -destination ([SambsConfig]::new())

            $logger.debug("Completed. '$($sambsConfig.toString())'")
            return $sambsConfig
        } catch {
            $logger.error("Failed: $_")
            throw "$_"
        }
    }
}