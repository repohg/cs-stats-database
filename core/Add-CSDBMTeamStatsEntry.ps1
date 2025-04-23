<#
.SYNOPSIS
    Add an entry to the TEAM_STATS table
.DESCRIPTION
    Accpets a game id, team name, and the stats object from the parser and inserts into the TEAM_STATS table
.EXAMPLE
    Add-CSDBMTeamStatsEntry -GameId <gameid> -Team <realTeamname> -StatObject $ParsedData.totalTeamStats.demoTeamName
#>

function Add-CSDBMTeamStatsEntry {
    [CmdletBinding()]
    param(
        [Parameter()]
        [String]$GameId,

        [Parameter()]
        [String]$Team,

        [Parameter()]
        [PSCustomObject]$StatObject
    )
    
    Write-Debug "START Add-CSDBMTeamStatsEntry"

    Invoke-CSDBMQuery @"
INSERT INTO TEAM_STATS (
    game_id, team_name, rounds, rounds_won, ct_rounds,
    ct_rounds_won, t_rounds, t_rounds_won, fiveVFour_count,
    fiveVFour_wins, fourVFive_count, fourVFive_wins, pistol_rounds,
    pistol_wins, saves, clutches, traded, f_ass, ef, util_dmg,
    util_thrown, deaths
)
VALUES (
    "$GameId",
    "$Team",
    $($StatObject.ctR + $StatObject.TR),
    $($StatObject.ctRW + $StatObject.TRW),
    $($StatObject.ctR),
    $($StatObject.ctRW),
    $($StatObject.TR),
    $($StatObject.TRW),
    $($StatObject.fiveVFourS),
    $($StatObject.fiveVFourW),
    $($StatObject.fourVFiveS),
    $($StatObject.fourVFiveW),
    $($StatObject.pistols),
    $($StatObject.pistolsW),
    $($StatObject.saves),
    $($StatObject.clutches),
    $($StatObject.traded),
    $($StatObject.fass),
    $($StatObject.ef),
    $($StatObject.ud),
    $($StatObject.util),
    $($StatObject.deaths)
)
"@

    Write-Debug "END Add-CSDBMTeamStatsEntry"

}

# function Add-TeamStatsEntry {
#     param([String]$Team)

#     $Query = @"
# INSERT INTO TEAM_STATS (
#     game_id, team_name, rounds, rounds_won, ct_rounds,
#     ct_rounds_won, t_rounds, t_rounds_won, fiveVFour_count,
#     fiveVFour_wins, fourVFive_count, fourVFive_wins, pistol_rounds,
#     pistol_wins, saves, clutches, traded, f_ass, ef, util_dmg,
#     util_thrown, deaths
# )
# VALUES (
#     "$MatchId",
#     "$($RealTeams[$Team])",
#     $($Data.totalTeamStats.$Team.ctR + $Data.totalTeamStats.$Team.TR),
#     $($Data.totalTeamStats.$Team.ctRW + $Data.totalTeamStats.$Team.TRW),
#     $($Data.totalTeamStats.$Team.ctR),
#     $($Data.totalTeamStats.$Team.ctRW),
#     $($Data.totalTeamStats.$Team.TR),
#     $($Data.totalTeamStats.$Team.TRW),
#     $($Data.totalTeamStats.$Team.fiveVFourS),
#     $($Data.totalTeamStats.$Team.fiveVFourW),
#     $($Data.totalTeamStats.$Team.fourVFiveS),
#     $($Data.totalTeamStats.$Team.fourVFiveW),
#     $($Data.totalTeamStats.$Team.pistols),
#     $($Data.totalTeamStats.$Team.pistolsW),
#     $($Data.totalTeamStats.$Team.saves),
#     $($Data.totalTeamStats.$Team.clutches),
#     $($Data.totalTeamStats.$Team.traded),
#     $($Data.totalTeamStats.$Team.fass),
#     $($Data.totalTeamStats.$Team.ef),
#     $($Data.totalTeamStats.$Team.ud),
#     $($Data.totalTeamStats.$Team.util),
#     $($Data.totalTeamStats.$Team.deaths)
# )
# "@

#     Invoke-SqliteQuery -Query $Query -DataSource $db
# }