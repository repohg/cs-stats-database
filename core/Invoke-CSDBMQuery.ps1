<#
.SYNOPSIS
    Run a SQL query against the database
.DESCRIPTION
    Accepts a SQL query as a string and runs it against the CSDBM database
.EXAMPLE
    Invoke-CSDBMQuery -Query '<query>'
#>

function Invoke-CSDBMQuery {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        #SQL query to be run
        [String]$Query
    )

    Write-Debug "Query: $Query"

    try { $response = Invoke-SqliteQuery -Query $Query -DataSource $script:CSDBMConfig.DatabasePath }
    catch { throw $_ }

    return $response
}