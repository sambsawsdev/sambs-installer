# Loop through all the functions
Get-ChildItem -Path "$PSScriptRoot/functions" -Include '*.ps1' -Recurse -Force -File | ForEach-Object {
    . $_.FullName
}

# Export all functions
Export-ModuleMember -Function *

# Create the global logger
$Global:logger = Get-Logger