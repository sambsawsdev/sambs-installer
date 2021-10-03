function New-SambsInstallerPath {
    # Check if env:sambsHome is defined
    [string]$newSambsInstallerPath = $null
    if ( [string]::IsNullOrWhiteSpace($env:sambsHome) ) {
        $newSambsInstallerPath = Join-Path -Path $HOME -ChildPath '/.sambs/sambs-installer'
    } else {
        $newSambsInstallerPath = Join-Path -Path $env:sambsHome -ChildPath '/sambs-installer'
    }

    if ( Test-Path -LiteralPath $newSambsInstallerPath -PathType Container ) {
        # Delete everything in the sambs-installer directory
        $null = Remove-Item -Path $newSambsInstallerPath/* -Recurse -Force
    } else {
        # Create the sambs-installer directory
        $null = New-Item -Path $newSambsInstallerPath -ItemType Directory -Force
    }

    return $newSambsInstallerPath
}

# Get all the sambs.installer on the Path
[string[]]$sambsInstallerFilePaths = Get-Command sambs.install.cmd -CommandType Application -ShowCommandInfo -ErrorAction SilentlyContinue | ForEach-Object {
    return $_.Definition
}

# Check if there is a sambs.installer on the path
if ($sambsInstallerFilePaths.Count -ile 0) {
    # Download sambs-installer as a zip from github
    [string]$sambsInstallerPath = New-SambsInstallerPath
    [string]$sambsInstallerZipFilePath = Join-Path -Path $sambsInstallerPath -ChildPath 'sambs-installer.zip'
    [System.Net.WebClient]$webClient = [System.Net.WebClient]::new() 
    $webClient.DownloadFile('https://github.com/sambsawsdev/sambs-installer/zipball/main', $sambsInstallerZipFilePath)

    # Extract the archive
    Expand-Archive -Path $sambsInstallerZipFilePath -DestinationPath $sambsInstallerPath
    # Rename the extract
    Copy-Item -Path $sambsInstallerPath/sambsawsdev-sambs-installer-* -Destination $sambsInstallerPath/sambs-installer -Recurse -Force
    Remove-Item -Path $sambsInstallerZipFilePath, $sambsInstallerPath/sambsawsdev-sambs-installer-* -Recurse -Force
    
    $sambsInstallerFilePaths += Join-Path -Path $sambsInstallerPath -ChildPath 'sambs-installer/sambs.install.cmd'
}

# Run the installer
Invoke-Expression ". `"$($sambsInstallerFilePaths[0])`""
#Start-Process powershell -ArgumentList "-File `"$($sambsInstallerFilePaths[0])`"" -PassThru -NoNewWindow -Wait
#Write-Output $sambsInstallerFilePaths[0]
