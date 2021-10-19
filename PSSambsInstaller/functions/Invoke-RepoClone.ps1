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

            # Ensure git-remote-codecommit is installed
            if ( -not (Test-PipAppInstalled -app 'git-remote-codecommit') ) {
                throw "git-remote-codecommit is required to clone the sambs repo."
            }

            $logger.info("Sambs repo clone starting...`n")
            # Get the sambs config
            #[SambsConfig]$sambsConfig = Get-SambsConfig
            $sambsConfig = Get-SambsConfig
            
            # Ensure the path exists
            if ( -not ( Test-Path -LiteralPath $sambsConfig.repoPath -PathType Container ) ) {
                $null = New-Item -Path $sambsConfig.repoPath -ItemType Directory -Force
                #throw "Can't find destination path '$($sambsConfig.repoPath)'"
            }

            Push-Location -LiteralPath $sambsConfig.repoPath
            $sambsConfig.repoPath = Get-Location

            # Ensure repo not already cloned
            [string]$repoPath = Join-Path -Path $sambsConfig.repoPath -ChildPath '/sambs-monorepo'
            if ( Test-Path -LiteralPath $repoPath -PathType Container ) {
                $logger.info("Repo path already exists '$repoPath'")
            } else {

                $logger.info("Sambs repo clone sambs-monorepo starting...`n")
                # Login to aws
                Invoke-SsoLogin

                #[SambsDevProfileConfig]$sambsDevProfileConfig = Get-SambsDevProfileConfig
                $sambsDevProfileConfig = Get-SambsDevProfileConfig
                # Todo: Check git-remote-codecommit,  and git installed
                Invoke-Expression "git clone codecommit://$($sambsDevProfileConfig.name)@sambs-monorepo"
                # Initialize the repo
                Initialize-Repo
                $logger.info("Sambs repo clone sambs-monorepo completed.")
            }
            

            # Clone the sambs-installer repo
            [string]$repoPath = Join-Path -Path $sambsConfig.repoPath -ChildPath '/sambs-installer'
            # Ensure repo not already cloned
            if ( Test-Path -LiteralPath $repoPath -PathType Container ) {
                $logger.info("Repo path already exists '$repoPath'")
            } else {
                $logger.info("Sambs repo clone sambs-installer starting...`n")
                Invoke-Expression "git clone https://github.com/sambsawsdev/sambs-installer"
                $logger.info("Sambs repo clone sambs-installer completed.")
            }
            # Clone the sambs-scoop repo
            [string]$repoPath = Join-Path -Path $sambsConfig.repoPath -ChildPath '/sambs-scoop'
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