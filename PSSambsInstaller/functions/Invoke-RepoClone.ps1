function Invoke-RepoClone {
    Param (
        [Parameter(Mandatory=$false, ValueFromRemainingArguments=$true)]
        [Object[]]$arguments    
    )

    Begin {
        $help = [PSCustomObject]@{
            summary = 'Clones the sambs repo from aws'
            usage = 'Usage: sambs-installer repo clone'
            example = 'Example: 
    sambs-installer repo clone'
        }
    }

    Process {
        try {
            $logger.debug("Starting. [$arguments]")

            # Show help
            if ($null -ne $arguments -and $arguments[0] -ieq 'help') {
                $logger.showHelp($help)
                return
            }

            # Ensure git is installed
            if ( -not (Test-ScoopAppInstalled -app 'git') ) {
                throw "git is required to clone the sambs repo."
            }

            $logger.info("Sambs repo clone starting...`n")
            # Get the sambs config
            #[InstallConfig]$installConfig = Get-InstallConfig
            $installConfig = Get-InstallConfig
            
            # Ensure the path exists
            if ( -not ( Test-Path -LiteralPath $installConfig.repoPath -PathType Container ) ) {
                $null = New-Item -Path $installConfig.repoPath -ItemType Directory -Force
                #throw "Can't find destination path '$($installConfig.repoPath)'"
            }

            Push-Location -LiteralPath $installConfig.repoPath
            $installConfig.repoPath = Get-Location

            # Ensure repo not already cloned
            [string]$repoPath = Join-Path -Path $installConfig.repoPath -ChildPath '/sambs-monorepo'
            if ( Test-Path -LiteralPath $repoPath -PathType Container ) {
                $logger.info("Repo path already exists '$repoPath'")
            } else {

                $logger.info("Sambs repo clone sambs-monorepo starting...`n")
                # Login to aws
                Invoke-SsoLogin

                #[DevProfileConfig]$devProfileConfig = Get-DevProfileConfig
                $devProfileConfig = Get-DevProfileConfig
                # Todo: Check git-remote-codecommit,  and git installed
                Invoke-Expression "git clone https://git-codecommit.eu-west-1.amazonaws.com/v1/repos/MonorepoRepository $repoPath"
                # Initialize the repo
                Initialize-Repo
                $logger.info("Sambs repo clone sambs-monorepo completed.")
            }
            

            # Clone the sambs-installer repo
            [string]$repoPath = Join-Path -Path $installConfig.repoPath -ChildPath '/sambs-installer'
            # Ensure repo not already cloned
            if ( Test-Path -LiteralPath $repoPath -PathType Container ) {
                $logger.info("Repo path already exists '$repoPath'")
            } else {
                $logger.info("Sambs repo clone sambs-installer starting...`n")
                Invoke-Expression "git clone https://github.com/sambsawsdev/sambs-installer"
                $logger.info("Sambs repo clone sambs-installer completed.")
            }
            # Clone the sambs-scoop repo
            [string]$repoPath = Join-Path -Path $installConfig.repoPath -ChildPath '/sambs-scoop'
            # Ensure repo not already cloned
            if ( Test-Path -LiteralPath $repoPath -PathType Container ) {
                $logger.info("Repo path already exists '$repoPath'")
            } else {
                $logger.info("Sambs repo clone sambs-scoop starting...`n")
                Invoke-Expression "git clone https://github.com/sambsawsdev/sambs-scoop"
                $logger.info("Sambs repo clone sambs-scoop completed.")
            }

            Pop-Location
            $logger.info("Sambs repo clone completed.")

            $logger.debug('Completed.')
        } catch {
            $logger.error("Failed: $_")
            throw "$_"
        }
    }
}