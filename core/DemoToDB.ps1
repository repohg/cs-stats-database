param(
    [Parameter(Mandatory)]
    [String]$DemoPath,

    [ValidateSet('Official','CSC Scrim', 'Scrim')]
    [String]$MatchType,
    
    [DateTime]$Date,
    
    [String]$CSCMatch
)

function Add-PlayerStats {
    param([PSCustomObject]$Player,[String]$Table)

    $Query = @"
INSERT INTO $Table(
    game_id, steam_id, name, team_name, side,
    rounds, damage, kills, assists, deaths, death_placement,
    ticks_alive, trades, traded, opening_kills, opening_deaths,
    cl_1, cl_2, cl_3, cl_4, cl_5, twoK, threeK, fourK, fiveK,
    nade_dmg, fire_dmg, util_dmg, ef, f_ass, enemy_flash_time,
    hs, kast_rounds, saves, entries, awp_kills, rounds_for,
    rounds_against, nades_thrown, fires_thrown, flash_thrown,
    smoke_thrown, damage_taken, supp_rounds, supp_dmg,
    lurk_rounds, wlp, mip, round_win_shares, eac,
    rounds_with_kills, util_thrown, atd, kast, kpa, iiwr,
    adr, dr_diff, kr, trade_ratio, impact, rating
)
VALUES (
    "$MatchId",
    $($Player.steamID),
    "$($Player.name)",
    "$($RealTeams[$Player.teamClanName])",
    $($Player.side),
    $($Player.rounds),
    $($Player.damage),
    $($Player.kills),
    $($Player.assists),
    $($Player.deaths),
    $($Player.deathPlacement),
    $($Player.ticksAlive),
    $($Player.trades),
    $($Player.traded),
    $($Player.ok),
    $($Player.ol),
    $($Player.cl_1),
    $($Player.cl_2),
    $($Player.cl_3),
    $($Player.cl_4),
    $($Player.cl_5),
    $($Player.twoK),
    $($Player.threeK),
    $($Player.fourK),
    $($Player.fiveK),
    $($Player.nadeDmg),
    $($Player.infernoDmg),
    $($Player.utilDmg),
    $($Player.ef),
    $($Player.FAss),
    $($Player.enemyFlashTime),
    $($Player.hs),
    $($Player.kastRounds),
    $($Player.saves),
    $($Player.entries),
    $($Player.awpKills),
    $($Player.RF),
    $($Player.RA),
    $($Player.nadesThrown),
    $($Player.firesThrown),
    $($Player.flashThrown),
    $($Player.smokeThrown),
    $($Player.damageTaken),
    $($Player.suppRounds),
    $($Player.suppDamage),
    $($Player.lurkRounds),
    $($Player.wlp),
    $($Player.mip),
    $($Player.rws),
    $($Player.eac),
    $($Player.rwk),
    $($Player.utilThrown),
    $($Player.atd),
    $($Player.kast),
    $($Player.killPointAvg),
    $($Player.iiwr),
    $($Player.adr),
    $($Player.drDiff),
    $($Player.KR),
    $($Player.tr),
    $($Player.impactRating),
    $($Player.rating)
)
"@

    Write-Host $Query

    Invoke-SqliteQuery -Query $Query -DataSource $db
}

function Add-GameEntry {
    $Query = @"
INSERT INTO GAMES (
    game_id, team_a, team_b, map, winner,
    match_type, date, csc_id
)
VALUES (
    "$MatchId",
    "$($RealTeams[$Data.teams.psobject.Properties.Name[0]])",
    "$($RealTeams[$Data.teams.psobject.Properties.Name[1]])",
    "$($Data.mapName)",
    "$($RealTeams[$Data.winnerClanName])",
"@

    if ($MatchType) { $Query += "`n    `"$MatchType`"," }
    else { $Query += "`n    NULL," }

    if ($Date) { $Query += "`n    `"$(Get-Date $Date -Format 'yyyy-MM-dd')`"," }
    else { $Query += "`n    NULL," }

    if ($CSCMatch) { $Query += "`n    `"$CSCMatch`");" }
    else { $Query += "`n    NULL`n);" }

    Invoke-SqliteQuery -Query $Query -DataSource $db
}

function Add-TeamStatsEntry {
    param([String]$Team)

    $Query = @"
INSERT INTO TEAM_STATS (
    game_id, team_name, rounds, rounds_won, ct_rounds,
    ct_rounds_won, t_rounds, t_rounds_won, fiveVFour_count,
    fiveVFour_wins, fourVFive_count, fourVFive_wins, pistol_rounds,
    pistol_wins, saves, clutches, traded, f_ass, ef, util_dmg,
    util_thrown, deaths
)
VALUES (
    "$MatchId",
    "$($RealTeams[$Team])",
    $($Data.totalTeamStats.$Team.ctR + $Data.totalTeamStats.$Team.TR),
    $($Data.totalTeamStats.$Team.ctRW + $Data.totalTeamStats.$Team.TRW),
    $($Data.totalTeamStats.$Team.ctR),
    $($Data.totalTeamStats.$Team.ctRW),
    $($Data.totalTeamStats.$Team.TR),
    $($Data.totalTeamStats.$Team.TRW),
    $($Data.totalTeamStats.$Team.fiveVFourS),
    $($Data.totalTeamStats.$Team.fiveVFourW),
    $($Data.totalTeamStats.$Team.fourVFiveS),
    $($Data.totalTeamStats.$Team.fourVFiveW),
    $($Data.totalTeamStats.$Team.pistols),
    $($Data.totalTeamStats.$Team.pistolsW),
    $($Data.totalTeamStats.$Team.saves),
    $($Data.totalTeamStats.$Team.clutches),
    $($Data.totalTeamStats.$Team.traded),
    $($Data.totalTeamStats.$Team.fass),
    $($Data.totalTeamStats.$Team.ef),
    $($Data.totalTeamStats.$Team.ud),
    $($Data.totalTeamStats.$Team.util),
    $($Data.totalTeamStats.$Team.deaths)
)
"@

    Invoke-SqliteQuery -Query $Query -DataSource $db
}

function Add-GameRoundEntry {
    param([PSCustomObject]$Round)
    if ($Round.winnerENUM -eq 3) { $Side = "CT" }
    elseif ($Round.winnerENUM -eq 2) { $Side = "T" }

    $Query = @"
INSERT INTO GAME_ROUNDS (
    game_id, round_num, winner_team, winner_side,
    round_end_reason, planter, defuser
)
VALUES (
    "$MatchId",
    $($Round.roundNum),
    "$($RealTeams[$Round.winnerClanName])",
    "$Side",
    "$($Round.roundEndReason)",
"@

    if ($Round.planter -eq 0) { $Query += "`n    NULL," }
    else { $Query += "`n    `"$($Round.planter)`"," }

    if ($Round.defuser -eq 0) { $Query += "`n    NULL`n);" }
    else { $Query += "`n    `"$($Round.defuser)`"`n);" }

    Invoke-SqliteQuery -Query $Query -DataSource $db
}

function Find-RealTeamNames {
    $TeamAInGame = $Data.teams.psobject.Properties.name[0]
    $TeamBInGame = $Data.teams.psobject.Properties.name[1]

    $PlayersInGame = @($Data.totalPlayerStats.psobject.Properties.name | ForEach-Object {$Data.totalPlayerStats.$_})
    $TeamAPlayers = ($PlayersInGame | Where-Object {$_.teamClanName -eq $TeamAInGame}).steamID
    $TeamBPlayers = ($PlayersInGame | Where-Object {$_.teamClanName -eq $TeamBInGame}).steamID

    $TeamATeams = Invoke-SqliteQuery -DataSource $db -Query "SELECT team FROM PLAYERS WHERE steam_id IN ($($TeamAPlayers -join ','));"
    $TeamBTeams = Invoke-SqliteQuery -DataSource $db -Query "SELECT team FROM PLAYERS WHERE steam_id IN ($($TeamBPlayers -join ','));"

    $TeamAReal = ($TeamATeams.team | Group-Object | Sort-Object Count -Descending | Select-Object -First 1).Name
    $TeamBReal = ($TeamBTeams.team | Group-Object | Sort-Object Count -Descending | Select-Object -First 1).Name

    return @{
        $TeamAInGame = $TeamAReal
        $TeamBInGame = $TeamBReal
    }
}

if (-not (Get-Module -Name PSSQLite)) { Import-Module PSSQLite }

$db = "D:\demos\s16Stats.db"

#Parse the demo
$FileContent = [System.IO.File]::ReadAllBytes($DemoPath)

Try { $Data = Invoke-RestMethod -Uri "http://localhost:8080/api/parse" -Method Post -Body $FileContent -ContentType 'application/octet-stream' -ErrorAction Stop }
Catch { Throw "Demo failed to parse: $_" }

$MatchId = [Guid]::NewGuid().Guid

#Translate team names
$RealTeams = Find-RealTeamNames

#Insert into GAMES
Add-GameEntry

#Insert into TEAM_STATS
$Data.totalTeamStats.psobject.Properties.Name | ForEach-Object {
    Add-TeamStatsEntry -Team $_
}

#Insert into GAME_ROUNDS
$Data.rounds | ForEach-Object {
    Add-GameRoundEntry -Round $_
}

#Insert into PLAYER_STATS tables
$Data.totalPlayerStats.psobject.Properties.Name | ForEach-Object {
    Add-PlayerStats -Player $Data.totalPlayerStats.$_ -Table PLAYER_STATS_TOTAL
    Add-PlayerStats -Player $Data.ctPlayerStats.$_ -Table PLAYER_STATS_CT
    Add-PlayerStats -Player $Data.TPlayerStats.$_ -Table PLAYER_STATS_T
}