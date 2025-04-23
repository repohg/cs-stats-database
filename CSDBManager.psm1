if (-not (Get-Module -Name PSSQLite)) { Import-Module -Name PSSQLite }

#Load config utils
$script:CSDBMConfig = "$PSScriptRoot/config.json"

#Load functions
Get-ChildItem -Path "$PSScriptRoot/core/*.ps1"         | ForEach-Object { . $_.FullName }
Get-ChildItem -Path "$PSScriptRoot/maintenance/*.ps1"  | ForEach-Object { . $_.FullName }
Get-ChildItem -Path "$PSScriptRoot/automation/*.ps1"   | ForEach-Object { . $_.FullName }
Get-ChildItem -Path "$PSScriptRoot/export/*.ps1"       | ForEach-Object { . $_.FullName }
Get-ChildItem -Path "$PSScriptRoot/utils/*.ps1"        | ForEach-Object { . $_.FullName }