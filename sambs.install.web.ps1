function New-DownloadedSambsInstallerPath {
    # Check if env:sambsHome is defined
    [string]$downloadedSambsInstallerPath = Get-DownloadedSambsInstallerPath

    if ( Test-Path -LiteralPath $downloadedSambsInstallerPath -PathType Container ) {
        # Delete everything in the sambs-installer directory
        $null = Remove-Item -Path $downloadedSambsInstallerPath/* -Recurse -Force
    } else {
        $null = New-Item -Path $downloadedSambsInstallerPath -ItemType Directory -Force
    }

    return $downloadedSambsInstallerPath
}

function Get-DownloadedSambsInstallerPath {
    # Check if env:sambsHome is defined
    [string]$downloadedSambsInstallerPath = $null
    if ( [string]::IsNullOrWhiteSpace($env:sambsHome) ) {
        $downloadedSambsInstallerPath = Join-Path -Path $HOME -ChildPath '/.sambs/sambs-installer'
    } else {
        $downloadedSambsInstallerPath = Join-Path -Path $env:sambsHome -ChildPath '/sambs-installer'
    }
    
    return $downloadedSambsInstallerPath
}

function Get-SambsInstallerFilePath {
    # Get all the sambs.installer.cmd on the Path
    [string[]]$sambsInstallerFilePaths = Get-Command sambs.install.cmd -CommandType Application -ShowCommandInfo -ErrorAction Ignore | ForEach-Object {
        return $_.Definition
    }

    # Return the first sambs.installer.cmd found on the path
    if ($sambsInstallerFilePaths.Count -cge 1) {
        return $sambsInstallerFilePaths[0]
    }

    $downloadedSambsInstallerFilePath = Join-Path -Path (Get-DownloadedSambsInstallerPath) -ChildPath 'sambs.install.cmd'
    if ( Test-Path -LiteralPath $downloadedSambsInstallerFilePath -PathType Leaf ) {
        return $downloadedSambsInstallerFilePath
    }

    return $null
}

function Get-DownloadSambsInstaller {
    # Download sambs-installer as a zip from github
    [string]$downloadedSambsInstallerPath = New-DownloadedSambsInstallerPath
    [string]$downloadSambsInstallerZipFilePath = Join-Path -Path $downloadedSambsInstallerPath -ChildPath 'sambs-installer.zip'
    [System.Net.WebClient]$webClient = [System.Net.WebClient]::new() 
    $webClient.DownloadFile('https://github.com/sambsawsdev/sambs-installer/zipball/main', $downloadSambsInstallerZipFilePath)

    # Extract the archive
    Expand-Archive -Path $downloadSambsInstallerZipFilePath -DestinationPath $downloadedSambsInstallerPath

    # Rename the extract
    Copy-Item -Path $downloadedSambsInstallerPath/sambsawsdev-sambs-installer-*/* -Destination $downloadedSambsInstallerPath -Recurse -Force
    Remove-Item -Path $downloadSambsInstallerZipFilePath, $downloadedSambsInstallerPath/sambsawsdev-sambs-installer-* -Recurse -Force    

    return Get-SambsInstallerFilePath
}

$sambsInstallerFilePath = Get-SambsInstallerFilePath
# Check if there is a sambs.installer on the path
if ($null -eq $sambsInstallerFilePath ) {
   $sambsInstallerFilePath = Get-DownloadSambsInstaller
}

# Run the installer
Invoke-Expression ". `"$($sambsInstallerFilePath)`""
# Delete the donwloaded installer
$downloadedSambsInstallerPath = Get-DownloadedSambsInstallerPath
if ( Test-Path -LiteralPath $downloadedSambsInstallerPath -PathType Container ) {
    Remove-Item -Path $downloadedSambsInstallerPath -Recurse -Force    
}