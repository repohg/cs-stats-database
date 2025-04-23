<#
.SYNOPSIS
    Add an entry to the GAMES table
.DESCRIPTION
    Accpets parameters to insert into the GAMES table for a particular demo
.EXAMPLE
    Add-CSDBMGameEntry -GameId <gameid> -TeamA <teamname> -TeamB <teamname> -Map <de_mapname> -Winner <teamname>
#>

function Add-CSDBMGameRoundEntry {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [String]$GameId,

        [Parameter]
        [Hashtable]$RealTeams,

        [Parameter(Mandatory)]
        [PSCustomObject]$Round
    )

    Write-Debug "START Add-CSDBMGameRoundEntry"
    
    if ($Round.winnerENUM -eq 3) { $Side = "CT" }
    elseif ($Round.winnerENUM -eq 2) { $Side = "T" }
    else { throw "Invalid side value: $($Round.winnerENUM)"}

    Write-Debug "END Add-CSDBMGameRoundEntry"
}


# function Add-GameRoundEntry {
#     param([PSCustomObject]$Round)
#     if ($Round.winnerENUM -eq 3) { $Side = "CT" }
#     elseif ($Round.winnerENUM -eq 2) { $Side = "T" }

#     $Query = @"
# INSERT INTO GAME_ROUNDS (
#     game_id, round_num, winner_team, winner_side,
#     round_end_reason, planter, defuser
# )
# VALUES (
#     "$MatchId",
#     $($Round.roundNum),
#     "$($RealTeams[$Round.winnerClanName])",
#     "$Side",
#     "$($Round.roundEndReason)",
# "@

#     if ($Round.planter -eq 0) { $Query += "`n    NULL," }
#     else { $Query += "`n    `"$($Round.planter)`"," }

#     if ($Round.defuser -eq 0) { $Query += "`n    NULL`n);" }
#     else { $Query += "`n    `"$($Round.defuser)`"`n);" }

#     Invoke-SqliteQuery -Query $Query -DataSource $db
# }