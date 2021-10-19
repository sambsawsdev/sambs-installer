# Run the sambs-installer-install
Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://github.com/sambsawsdev/sambs-installer/raw/develop/sambs-installer-install.ps1')
# Install the sambs package
Invoke-Expression 'sambs-installer install sambs'
# Refresh the path
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
# Configure sambs
Invoke-Expression 'sambs-installer configure sambs'

# Check if repo path exists
[string]$monoRepoPath = Join-Path -Path '.' -ChildPath '/sambs-monorepo'
if ( Test-Path -LiteralPath $monoRepoPath -PathType Container ) {
    # Clone the repo
    Invoke-Expression "sambs-installer repo initialize $monoRepoPath"
} else {
    # Clone the repo
    Invoke-Expression 'sambs-installer repo clone'
}

# Check if sambs-installer exists
[string]$sambsInstallerPath = Join-Path -Path '.' -ChildPath '/sambs-installer'
if ( -not (Test-Path -LiteralPath $sambsInstallerPath -PathType Container) ) {
    # Clone the repo
    Invoke-Expression "git clone https://github.com/sambsawsdev/sambs-installer"
}

# Check if sambs-scoop exists
[string]$sambsScoopPath = Join-Path -Path '.' -ChildPath '/sambs-scoop'
if ( -not (Test-Path -LiteralPath $sambsScoopPath -PathType Container) ) {
    # Clone the repo
    Invoke-Expression "git clone https://github.com/sambsawsdev/sambs-scoop"
}

