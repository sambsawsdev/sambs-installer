function Initialize-Repo {
    Param (
        [Parameter(Mandatory=$false, ValueFromRemainingArguments=$true)]
        [Object[]]$arguments
    )

    #Todo: Help
    Process {
        try {
            $logger.debug("Starting. [$repoPath, $arguments]")

            # Get the existing config
            #[SambsConfig]$sambsConfig = Get-SambsConfig
            $sambsConfig = Get-SambsConfig
            [string]$repoPath = Join-Path -Path $sambsConfig.repoPath -ChildPath '/sambs-monorepo'

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
            
            # Change directory to the repo
            Push-Location -LiteralPath $repoPath
            $repoPath = Get-Location

            # Yarn install to unplug (aws-cdk, aws-sdk)
            $logger.info("Yarn install starting ...`n")
            Invoke-Expression "yarn install"
            $logger.info("Yarn install completed.")

            # Build the repository
            $logger.info("Build sambs repo starting...`n")
            Invoke-Expression "yarn tsc --build tsconfig.json tsconfig.esm.json"
            $logger.info("Build sambs repo completed.")

            $logger.info("Shim sambs cli starting...`n")
            [string]$scoopPath = (Get-Command scoop -ErrorAction Ignore -ShowCommandInfo).Definition | Split-Path
            [string]$scoopCoreFilePath = Join-Path -Path $scoopPath -ChildPath '../apps/scoop/current/lib/core.ps1'
            [string]$sambsFilePath = Join-Path -Path $sambsScriptCliPath -ChildPath '/bin/sambs.ps1'
            . "$scoopCoreFilePath"
            shim $sambsFilePath
            $logger.info("Shim sambs cli completed.")

            # Add yarn vscode sdk
            $logger.info("Add yarn vscode sdk starting...`n")
            Invoke-Expression "yarn dlx @yarnpkg/sdks vscode"
            $logger.info("Add yarn vscode sdk completed.")
            Pop-Location

            $logger.info("Sambs repo initialize completed.")

            $logger.debug('Completed.')
        } catch {
            $logger.error("Failed: $_")
            throw "$_"
        }
    }
}