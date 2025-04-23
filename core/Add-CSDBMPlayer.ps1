<#
.SYNOPSIS
    Add a player to the database
.DESCRIPTION
    Accepts a username and steam_id and inserts it into the PLAYERS table
.EXAMPLE
    Add-CSDBMPlayer -Username <username> -SteamID <steamID>
#>

function Add-CSDBMPlayer {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        #Preferred username of the player
        [String]$Username,

        [Parameter(Mandatory, ParameterSetName = 'SteamID')]
        #Numeric SteamId of the user
        [String]$SteamID,

        [Parameter(Mandatory, ParameterSetName = 'SteamUrl')]
        #Steam profile URL (numeric profile, not custom identifier)
        [String]$SteamUrl,

        [Parameter()]
        [Int32]$Mmr,

        [Parameter()]
        [string]$Team
    )

    Write-Debug "START Add-CSDBMPlayer"

    #parse out the steam ID if needed
    if ($SteamUrl) { $SteamID = (Select-String -InputObject $SteamUrl -Pattern '^https:\/\/steamcommunity\.com\/profiles\/(\d+)$').Matches[0].Groups[1].Value }

    #check to see if there is already an entry in PLAYERS
    $playerExists = Invoke-CSDBMQuery "SELECT * FROM PLAYERS WHERE steam_id = '$SteamId';"
    if ($playerExists) { throw "A player with this id already exists: $($playerExists.steam_id) - $($playerExists.Name)" }

    #construct the query columns and values
    $columnNames = [System.Collections.Generic.List[String]]@('steam_id','name')
    $columnValues = [System.Collections.Generic.List[String]]@("'$SteamID'", "'$Username'")

    if ($Team) { $columnNames.Add('team'); $columnValues.Add("'$Team'") }
    if ($Mmr)  { $columnNames.Add('mmr') ; $columnValues.Add($mmr)      }

    Invoke-CSDBMQuery "INSERT INTO PLAYERS ($($columnNames -join ',')) VALUES ($($columnValues -join ","));"

    Write-Debug "END Add-CSDBMPlayer"
}