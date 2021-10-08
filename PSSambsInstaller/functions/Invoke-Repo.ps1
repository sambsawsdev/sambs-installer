function Invoke-Repo {
    Param (
        [Parameter(Mandatory=$false, Position=0)]
        [string]$destinationPath,
        [Parameter(Mandatory=$false, ValueFromRemainingArguments=$true)]
        [Object[]]$arguments    
    )

    Begin {
        $help = [PSCustomObject]@{
            summary = 'Clones the sambs repo from aws'
            usage = 'Usage: sambs-installer repo [-destinationPath] <destinationPath>

Where:
    destinationPath    The path where you would like to clone the sambs repo'
            example = 'Example: 
    sambs-installer repo .
    sambs-installer repo "C:\Users\sambs\repo"'
        }
    }

    Process {
        try {
            $logger.debug("Starting. [$destinationPath, $arguments]")

            # Show help
            if ([string]::IsNullOrWhiteSpace($destinationPath) -or $destinationPath -ieq 'help') {
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
            
            # Ensure git-remote-codecommit is installed
            if ( -not ( Test-Path -LiteralPath $destinationPath -PathType Container ) ) {
                throw "Can't find destination path '$destinationPath'"
            }

            # Ensure the path exists
            if ( -not ( Test-Path -LiteralPath $destinationPath -PathType Container ) ) {
                throw "Can't find destination path '$destinationPath'"
            }

            # Ensure repo not already cloned
            [string]$repoPath = Join-Path -Path $destinationPath -ChildPath '/sambs-monorepo'
            if ( Test-Path -LiteralPath $repoPath -PathType Container ) {
                throw "Repo path already exists '$repoPath'"
            }

            Push-Location -LiteralPath $destinationPath
            [string]$destinationPath = Get-Location
            $logger.info("Cloneing sambs repo '$destinationPath' starting...`n")

            [SambsDevProfileConfig]$sambsDevProfileConfig = Get-SambsDevProfileConfig
            # Todo: Check git-remote-codecommit,  and git installed
            Invoke-Expression "git clone codecommit://$($sambsDevProfileConfig.name)@sambs-monorepo"
            Pop-Location
            $logger.info("Cloneing sambs repo completed.")

            $logger.debug('Completed.')
        } catch {
            $logger.error("Failed: $_")
            throw "$_"
        }
    }
}