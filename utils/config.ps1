function Get-CSDBMConfig {
    $configPath = Join-Path -Path $PSScriptRoot -ChildPath "..\\config.json"
    if (-Not (Test-Path $configPath)) {
        throw "Missing config.json. Please copy config.sample.json and customize it."
    }
    return Get-Content $configPath | ConvertFrom-Json
}

function New-CSDBMConfig {
    $root = Join-Path $PSScriptRoot ".."
    $sample = Join-Path $root "config.sample.json"
    $real   = Join-Path $root "config.json"
    if (-Not (Test-Path $real)) {
        Copy-Item $sample -Destination $real
        Write-Host "config.json created. Please edit it with your paths."
    } else {
        Write-Host "config.json already exists."
    }
}
