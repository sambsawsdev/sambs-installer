function Invoke-Repo {
    Param (
        [Parameter(Mandatory=$false, Position=0)]
        [string]$command,
        [Parameter(Mandatory=$false, Position=1)]
        [string]$repoPath='.',
        [Parameter(Mandatory=$false, ValueFromRemainingArguments=$true)]
        [Object[]]$arguments    
    )

    Begin {
        $help = [PSCustomObject]@{
            summary = 'Execute commands for the sambs repo in aws'
            usage = 'Usage: sambs-installer repo [-commnd] <command> [-repoPath] [<repoPath>]
Where:
    command     The name of the command to execute.
    repoPath    [Default = .]The path to where the repo will be installed (clone) or is installed (initialize).

Where command:
    clone       Will clone the sambs repo from aws into the repoPath
    initialize  Will initialize the sambs repo in the repoPath'
            example = 'Example: 
    sambs-installer repo clone .
    sambs-installer repo -command clone -repoPath "C:\Users\sambs\repo"
    sambs-installer repo initialize .
    sambs-installer repo -command initialize -repoPath "C:\Users\sambs\repo"'
        }
    }

    Process {
        try {
            $logger.debug("Starting. [$command, $repoPath, $arguments]")

            # Show help
            if ([string]::IsNullOrWhiteSpace($command) -or $command -ieq 'help') {
                $logger.showHelp($help)
                return
            }

            switch ($command.toLower()) {
                'clone' { $null = Invoke-RepoClone -repoPath $repoPath $arguments }
                'initialize' { $null = Initialize-Repo -repoPath $repoPath $arguments }
                Default {
                    # Show help
                    $logger.error("Unknown command '$command'")
                    $logger.showHelp($help)
                    throw "Unknown command '$command'"
                }
            }

            $logger.debug('Completed.')
        } catch {
            $logger.error("Failed: $_")
            throw "$_"
        }
    }
}