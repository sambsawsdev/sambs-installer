Begin {
    # Import the PSSambsInstaller module
    [string]$sambsInstallerModulePath = Join-Path -Path $PSScriptRoot -ChildPath '/PSSambsInstaller'
    Import-Module $sambsInstallerModulePath -Force

    $logger.info('Sambs Uninstaller starting...')

    # Set sambsHome
    [string]$sambsHome = Set-SambsHome -sambsHome $sambsHome
}

Process {
    try {        
        # Confirm sambs must be uninstalled
        $logger.warn("Uninstall will completely remove sambs and all apps installed for sambsHome $sambshome")
        [string]$confirmUninstall = Read-Host 'Are you sure you want to completly uninstall sambs [y/N]? '

        if ($confirmUninstall -ieq 'y') {
            # Uninstall Pip Apps
            # Check if pip is installed
            if ( Get-IsPipInstalled ) {
                # Check if git-remote-codecommit is installed
                if (Get-IsPipAppInstalled -app 'git-remote-codecommit') {
                    # Uninstall git-remote-codecommit
                    $logger.info('Uninstalling git-remote-codecommit starting...')
                    Invoke-Expression 'pip uninstall git-remote-codecommit --yes'
                    $logger.info('Uninstalling git-remote-codecommit completed.')
                }
            }

            # Check if scoop is installed
            if ( Get-IsScoopInstalled ) {
                # Uninstall scoop.  This will uninstall scoop and all apps installed by scoop
                $logger.info('Uninstalling scoop starting...')
                # Todo: Force the uninstall!!
                Invoke-Expression 'scoop uninstall scoop -p'
                $logger.info('Uninstalling scoop completed.')
            }

            # Remove sambsHome
            $logger.info('Removing sambsHome starting...')
            if ( Test-Path -LiteralPath $sambsHome -PathType Container ) {
                # Remove the directory
                $null = Remove-Item -Path $sambsHome -Recurse -Force
            }
            [System.Environment]::SetEnvironmentVariable('sambsHome', $null, 'User')
            $logger.info('Removing sambsHome completed.')


            # Cleanup path
            $logger.info('Removing sambs from the path starting...')
            [string[]]$newPath = $null
            # Loop through all the path items
            foreach ($pathItem in [System.Environment]::GetEnvironmentVariable('Path', 'User').Split(';')) {
                # Do not include anything that starts with <sambsHome>
                if (-not $pathItem.StartsWith($sambsHome)) {
                    $newPath = "$newPath$pathItem$([IO.Path]::PathSeparator)"
                }
            }
            # Set the path
            [System.Environment]::SetEnvironmentVariable('PATH', $newPath, 'User')
            $logger.info('Removing sambs from the path completed.')
            
            $logger.info('Removing environment variables starting...')
            # Cleanup env (Currently known items that are added)
            [System.Environment]::SetEnvironmentVariable('GIT_INSTALL_ROOT', $null, 'User')
            [System.Environment]::SetEnvironmentVariable('SCOOP', $null, 'User')
            $logger.info('Removing environment variables completed.')        
        }
        
        $logger.info('Sambs Uninstaller completed.')
    } catch {
        $logger.error("Sambs Uninstaller Failed: $_")
        throw "Sambs Install Failed: $_"
    }
}