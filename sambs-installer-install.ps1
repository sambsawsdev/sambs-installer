function Test-SambsInstallerInstalled {
    Process {
        try {
            # Check if installer is on the path
            if ( Get-Command sambs-installer -CommandType Application -ErrorAction Ignore ) {
                return $true
            }

            return $false
        } catch {
            throw "Test-SambsInstallerInstalled Failed: $_"
        }
    }
}

function Test-ScoopInstalled {
    Process {
        try {
            # Check if scoop is on the path
            if ( Get-Command scoop -CommandType Application -ErrorAction Ignore ) {
                return $true
            }

            return $false
        } catch {
            throw "Test-ScoopInstalled Failed: $_"
        }
    }
}

function Test-GitInstalled {
    Process {
        try {
            # Ensure scoop is installed
            if ( -not (Test-ScoopInstalled) ) {
                throw "Scoop is required to check if git is installed."
            }

            # Get the list of installed apps using scoop export
            [bool]$isInstalled = $false
            [string[]]$apps = Invoke-Expression 'scoop export' | ForEach-Object { return $_.split(" ")[0].ToLower() }
            if ($null -ne $apps) {
                $isInstalled = $apps.Contains('git')
            }
                        
            return $isInstalled
        } catch {
            throw "Test-GitInstalled Failed: $_"
        }
    }
}

function Test-SambsBucketInstalled {
    Process {
        try {
            # Ensure scoop is installed
            if ( -not (Test-ScoopInstalled) ) {
                throw "Scoop is required to check if sambs bucket is installed."
            }

            # Get the list of installed buckets using scoop bucket list
            [bool]$isInstalled = $false
            [string[]]$buckets = Invoke-Expression 'scoop bucket list' | ForEach-Object { return $_ }
            if ($null -ne $buckets) {
                $isInstalled = $buckets.Contains('sambs')
            }

            return $isInstalled
        } catch {
            throw "Test-SambsBucketInstalled Failed: $_"
        }
    }
}

function Set-SambsHome {
    Process {
        try {
            # Use env:sambsHome or the default <userHome>/.sambs
            if ([string]::IsNullOrWhiteSpace($env:sambsHome)) {
                $env:sambsHome = Join-Path -Path $HOME -ChildPath '/.sambs'
            }

            $env:SCOOP = Join-Path -Path $env:sambsHome -ChildPath '/scoop'
            [System.Environment]::SetEnvironmentVariable('sambsHome', $env:sambsHome, 'User')
            [System.Environment]::SetEnvironmentVariable('SCOOP', $env:SCOOP, 'User')
        } catch {
            throw "Set-SambsHome Failed: $_"
        }
    }
}

function Install-Scoop {
    Process {
        try {
            # Check if scoop already installed
            if ( Test-ScoopInstalled ) {
                return
            }

            # Run the scoop installer
            Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://get.scoop.sh')
        } catch {
            throw "Install-Scoop Failed: $_"
        }
    }
}

function Install-Git {
    Process {
        try {
            # Ensure scoop is installed
            if ( -not (Test-ScoopInstalled) ) {
                throw "Scoop is required to install git."
            }
            
            # Check if git already installed
            if ( Test-GitInstalled ) {
                return
            }

            # Install git using scoop
            Invoke-Expression 'scoop install git'
        } catch {
            throw "Install-Git Failed: $_"
        }
    }
}

function Install-SambsBucket {
    Process {
        try {
            # Ensure git is installed
            if ( -not (Test-GitInstalled) ) {
                throw "Git is required to install sambs bucket."
            }
            
            # Check if sambs bucket already installed
            if ( Test-SambsBucketInstalled ) {
                return
            }

            # Install sambs bucket using scoop
            Invoke-Expression 'scoop bucket add sambs https://github.com/sambsawsdev/sambs-scoop'
        } catch {
            throw "Install-SambsBucket Failed: $_"
        }
    }
}

function Install-SambsInstaller {
    Process {
        try {
            # Check if installer already installed
            if ( Test-SambsInstallerInstalled ) {
                Write-Warning "Sambs installer already installed.`nExiting sambs-installer-install"
                return
            }

            # Set sambsHome
            Set-SambsHome
            # Install scoop
            Install-Scoop
            # Install git
            Install-Git
            # Add sambs bucket
            Install-SambsBucket
            
            # Install sambs-installer
            Invoke-Expression 'scoop install sambs-installer'
        } catch {
            throw "Install-SambsInstaller Failed: $_"
        }
    }
}

Install-SambsInstaller 
