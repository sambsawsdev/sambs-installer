Begin {
    # Import the PSSambsInstaller module
    [string]$sambsInstallerModulePath = Join-Path -Path $PSScriptRoot -ChildPath '/PSSambsInstaller'
    Import-Module $sambsInstallerModulePath -Force

    $logger.info('Sambs Uninstaller starting...')

    # Set sambsHome
    [string]$sambsHome = $env:sambsHome
}

Process {
    try {        
        # Confirm sambs must be uninstalled
        $logger.warn("Uninstall will completely remove sambs and all apps installed for sambsHome $sambshome")
        [string]$confirmUninstall = Read-Host 'Are you sure you want to completly uninstall sambs [y/N]? '

        if ($confirmUninstall -ieq 'y') {
            # Uninstall Pip Apps
            # Check if pip is installed
            if ( Test-PipInstalled ) {
                # Check if git-remote-codecommit is installed
                if (Test-PipAppInstalled -app 'git-remote-codecommit') {
                    # Uninstall git-remote-codecommit
                    $logger.info('Uninstalling git-remote-codecommit starting...')
                    Invoke-Expression 'pip uninstall git-remote-codecommit --yes'
                    $logger.info('Uninstalling git-remote-codecommit completed.')
                }
            }

            # Check if scoop is installed
            if ( Test-ScoopInstalled ) {
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

            $logger.info('Removing sambs repo starting...')
            $sambsConfig = Get-SambsConfig
            if ( Test-Path -LiteralPath $sambsConfig.repoPath -PathType Container ) {
                # Remove sambs-monorepo
                [string]$repoPath = Join-Path -Path $sambsConfig.repoPath -ChildPath '/sambs-monorepo'
                if ( Test-Path -LiteralPath $repoPath -PathType Container ) {
                    $null = Remove-Item -Path $repoPath -Recurse -Force
                }
                # Remove sambs-instler
                [string]$repoPath = Join-Path -Path $sambsConfig.repoPath -ChildPath '/sambs-installer'
                if ( Test-Path -LiteralPath $repoPath -PathType Container ) {
                    $null = Remove-Item -Path $repoPath -Recurse -Force
                }
                # Remove sambs-instler
                [string]$repoPath = Join-Path -Path $sambsConfig.repoPath -ChildPath '/sambs-scoop'
                if ( Test-Path -LiteralPath $repoPath -PathType Container ) {
                    $null = Remove-Item -Path $repoPath -Recurse -Force
                }
            }
            $logger.info('Removing sambs repo completed.')

            # Todo: Find a better way of the below
            # Remove other paths 
            $logger.info('Removing other paths starting...')
            # .aws
            [string]$removePath = Join-Path -Path $HOME -ChildPath '/.aws'
            if ( Test-Path -LiteralPath $removePath -PathType Container ) {
                $logger.info("Removing $removePath")
                $null = Remove-Item -Path $removePath -Recurse -Force
            }
            # .config
            [string]$removePath = Join-Path -Path $HOME -ChildPath '/.config'
            if ( Test-Path -LiteralPath $removePath -PathType Container ) {
                $logger.info("Removing $removePath")
                $null = Remove-Item -Path $removePath -Recurse -Force
            }
            # .vscode
            $removePath = Join-Path -Path $HOME -ChildPath '/.vscode'
            if ( Test-Path -LiteralPath $removePath -PathType Container ) {
                $logger.info("Removing $removePath")
                $null = Remove-Item -Path $removePath -Recurse -Force
            }
            # .gitconfig
            $removePath = Join-Path -Path $HOME -ChildPath '.gitconfig'
            if ( Test-Path -LiteralPath $removePath -PathType Leaf ) {
                $logger.info("Removing $removePath")
                $null = Remove-Item -Path $removePath -Force
            }
            # pip             
            $removePath = Join-Path -Path ([System.Environment]::GetFolderPath('LocalApplicationData')) -ChildPath '/pip'
            if ( Test-Path -LiteralPath $removePath -PathType Container ) {
                $logger.info("Removing $removePath")
                $null = Remove-Item -Path $removePath -Recurse -Force
            }
            # yarn
            $removePath = Join-Path -Path ([System.Environment]::GetFolderPath('LocalApplicationData')) -ChildPath '/yarn'
            if ( Test-Path -LiteralPath $removePath -PathType Container ) {
                $logger.info("Removing $removePath")
                $null = Remove-Item -Path $removePath -Recurse -Force
            }
            # npm-cache
            $removePath = Join-Path -Path ([System.Environment]::GetFolderPath('ApplicationData')) -ChildPath '/npm-cache'
            if ( Test-Path -LiteralPath $removePath -PathType Container ) {
                $logger.info("Removing $removePath")
                $null = Remove-Item -Path $removePath -Recurse -Force
            }
            # Scoop Start Menu
            $removePath = Join-Path -Path ([System.Environment]::GetFolderPath('ApplicationData')) -ChildPath '/Microsoft/Windows/Start Menu/Programs/Scoop Apps'
            if ( Test-Path -LiteralPath $removePath -PathType Container ) {
                $logger.info("Removing $removePath")
                $null = Remove-Item -Path $removePath -Recurse -Force
            }

            $logger.info('Removing other paths completed.')


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