function Add-CSVToDB {
    param(
        [String]$FilePath,
        [String]$Database
    )

    if (-not (Get-Module -Name PSSQLite)) { Import-Module PSSQLite }

    $Data = Import-Csv $FilePath
}