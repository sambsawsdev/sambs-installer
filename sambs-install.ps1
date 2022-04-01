# Run the sambs-installer-install
Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://github.com/sambsawsdev/sambs-installer/raw/develop/sambs-installer-install.ps1')
# Install the sambs package
Invoke-Expression 'sambs-installer install sambs'
# Refresh the path
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
# Configure sambs
Invoke-Expression 'sambs-installer configure sambs'
# Clone the repo
Invoke-Expression "sambs-installer repo clone"

