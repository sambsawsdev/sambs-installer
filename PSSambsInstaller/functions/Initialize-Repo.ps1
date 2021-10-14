function Initialize-Repo {
    Param (
        [Parameter(Mandatory=$false, Position=0)]
        [string]$repoPath='.',
        [Parameter(Mandatory=$false, ValueFromRemainingArguments=$true)]
        [Object[]]$arguments
    )

    #Todo: Help
    Process {
        try {
            $logger.debug("Starting. [$repoPath, $arguments]")

            # Ensure repo is installed
            if (-not (Test-RepoInstalled -repoPath $repoPath) ) {
                throw "Can't find valid sambs repo in '$repoPath'"
            }
            # Check if the repo contains the sambs-scripts.cli path
            [string]$sambsScriptCliPath = Join-Path -Path $repoPath -ChildPath '/sambs-scripts/sambs-scripts-cli'
            if (-not (Test-Path -LiteralPath $sambsScriptCliPath -PathType Container) ) {
                throw "Can't find sambs-scripts-cli project '$sambsScriptCliPath'"
            }
            
            $logger.info("Sambs cli initialize starting...")

            # Ensure the latest Nvs config is setup according to the sambs config
            # This ensures nvs and all globals (e.g yarn, aws-cdk) are installed.
            $logger.info("Sambs cli initialize configure nvs starting...")
            Update-NvsConfigWithSambs
            $logger.info("Sambs cli initialize configure nvs completed")

            # Change directory to the sambs-scripts-cli project
            Push-Location -LiteralPath $sambsScriptCliPath
            $sambsScriptCliPath = Get-Location

            # Build the sambs-scripts-cli project
            $logger.info("Sambs cli initialize build sambs cli starting...`n")
            Invoke-Expression "yarn tsc --build tsconfig.json tsconfig.esm.json"
            $logger.info("Sambs cli initialize build sambs cli completed.")

            # Link the project
            $logger.info("Sambs cli initialize link sambs cli starting...`n")
            Invoke-Expression "npm link --force"
            $logger.info("Sambs cli initialize link sambs cli completed.")

            Pop-Location
            $logger.info("Sambs cli initialize completed.")

            $logger.debug('Completed.')
        } catch {
            $logger.error("Failed: $_")
            throw "$_"
        }
    }
}