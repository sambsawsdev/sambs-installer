function Test-RepoInstalled {
    Param (
        [Parameter(Mandatory=$false, Position=0)]
        [string]$repoPath='.'
    )

    Process {
        try {
            $logger.debug("Starting. [$repoPath]")

            # Ensure there is a package.json
            [string]$packageJsonFilePath = Join-Path -Path $repoPath -ChildPath 'package.json'
            if ( -not (Test-Path -LiteralPath $packageJsonFilePath -PathType Leaf)  ) {
                throw "Can't find package.json in '$repoPath'"
            }            

            [bool]$isRepoInstalled = $true
            # Read the json from the file
            $packageJson = Get-Content -LiteralPath $packageJsonFilePath -Raw | ConvertFrom-Json

            # Check the name in package.json is sambs
            if ($packageJson.name -ine 'sambs') {
                $logger.debug("sambs is not the name in package.json")
                $isRepoInstalled = $false
            }

            # Loop through all the workspaces defined in the package.json
            foreach($workspace in $packageJson.workspaces){
                # Check if the path exists
                [string]$workspacePath = Join-Path -Path $repoPath -ChildPath "/$workspace"
                if ( -not (Test-Path -LiteralPath $workspacePath -PathType Container) ) {
                    $logger.debug("workspace path does not exist '$workspacePath'.")
                    $isRepoInstalled = $false
                }
            }

            $logger.debug("Completed. $isRepoInstalled")
            return $isRepoInstalled
        } catch {
            $logger.error("Failed: $_")
            throw "$_"
        }
    }
}