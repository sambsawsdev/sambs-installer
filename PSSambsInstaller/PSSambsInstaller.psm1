# Loop through all the functions
Get-ChildItem -Path "$PSScriptRoot/functions" -Include '*.ps1' -Recurse -Force -File | ForEach-Object {
    . $_.FullName
}

# Export all functions
Export-ModuleMember -Function *

# Create the global logger
$Global:logger = Get-Logger

class DevProfileConfig {
    [string]$name='sso-aws-sambs-dev'
    [string]$sso_start_url='https://d-93670d3ca3.awsapps.com/start'
    [string]$sso_region='eu-west-1'
    [string]$sso_account_id='456758731030'
    [string]$sso_role_name='Administrators' # Todo: Change to something else
    [string]$region='eu-west-1'
    [string]$output='json'

    [string] toString() {
        return $this | ConvertTo-Json -Depth 2 -Compress
    }
}

class NvsConfig {
    [string]$nodeVersion="14"
    [string]$yarnVersion="^1"
    #[string]$awscdkVersion="1.127.0"

    [string] toString() {
        return $this | ConvertTo-Json -Depth 2 -Compress
    }
}