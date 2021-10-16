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
            
            $logger.info("Sambs repo initialize starting...")

            # Ensure the latest Nvs config is setup according to the sambs config
            # This ensures nvs and all globals (e.g yarn, aws-cdk) are installed.
            $logger.info("Configure nvs starting...")
            Update-NvsConfigWithSambs
            $logger.info("Configure nvs completed")

            # Change directory to the sambs-scripts-cli project
            Push-Location -LiteralPath $sambsScriptCliPath
            $sambsScriptCliPath = Get-Location

            # Build the sambs-scripts-cli project
            $logger.info("Build sambs cli starting...`n")
            Invoke-Expression "yarn tsc --build tsconfig.json tsconfig.esm.json"
            $logger.info("Build sambs cli completed.")
            Pop-Location

            # Add yarn vscode sdk
            $logger.info("Add yarn vscode sdk starting...`n")
            Invoke-Expression "yarn dlx @yarnpkg/sdks vscode"
            $logger.info("Add yarn vscode sdk completed.")

            $logger.info("Sambs repo initialize completed.")

            $logger.debug('Completed.')
        } catch {
            $logger.error("Failed: $_")
            throw "$_"
        }
    }
}