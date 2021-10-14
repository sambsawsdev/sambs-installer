function Invoke-RepoClone {
    Param (
        [Parameter(Mandatory=$false, Position=0)]
        [string]$repoPath='.',
        [Parameter(Mandatory=$false, ValueFromRemainingArguments=$true)]
        [Object[]]$arguments    
    )

    Begin {
        $help = [PSCustomObject]@{
            summary = 'Clones the sambs repo from aws'
            usage = 'Usage: sambs-installer repo clone [-repoPath <repoPath>]

Where:
    repoPath    [default = .] The path where you would like to clone the sambs repo'
            example = 'Example: 
    sambs-installer repo clone .
    sambs-installer repo clone "C:\Users\sambs\repo"'
        }
    }

    Process {
        try {
            $logger.debug("Starting. [$repoPath, $arguments]")

            # Show help
            if ([string]::IsNullOrWhiteSpace($repoPath) -or $repoPath -ieq 'help') {
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
            
            # Ensure the path exists
            if ( -not ( Test-Path -LiteralPath $repoPath -PathType Container ) ) {
                throw "Can't find destination path '$repoPath'"
            }

            # Ensure repo not already cloned
            [string]$monoRepoPath = Join-Path -Path $repoPath -ChildPath '/sambs-monorepo'
            if ( Test-Path -LiteralPath $monoRepoPath -PathType Container ) {
                throw "Repo path already exists '$monoRepoPath'"
            }

            # Login to aws
            Invoke-SsoLogin

            Push-Location -LiteralPath $repoPath
            [string]$repoPath = Get-Location
            $logger.info("Sambs repo clone '$repoPath' starting...`n")

            [SambsDevProfileConfig]$sambsDevProfileConfig = Get-SambsDevProfileConfig
            # Todo: Check git-remote-codecommit,  and git installed
            Invoke-Expression "git clone codecommit://$($sambsDevProfileConfig.name)@sambs-monorepo"

            Pop-Location

            # Initialize the repo
            Initialize-Repo -repoPath $monoRepoPath
            $logger.info("Sambs repo clone completed.")

            $logger.debug('Completed.')
        } catch {
            $logger.error("Failed: $_")
            throw "$_"
        }
    }
}