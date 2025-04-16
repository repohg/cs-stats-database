function Remove-GameFromDB {
    param(
        [String]$GameId,
        [String]$Database
    )

    if (-not (Get-Module -Name PSSQLite)) { Import-Module PSSQLite }

    Invoke-SqliteQuery -DataSource $Database -Query "DELETE FROM PLAYER_STATS_CT WHERE game_id = '$GameId'"
    Invoke-SqliteQuery -DataSource $Database -Query "DELETE FROM PLAYER_STATS_T WHERE game_id = '$GameId'"
    Invoke-SqliteQuery -DataSource $Database -Query "DELETE FROM PLAYER_STATS_TOTAL WHERE game_id = '$GameId'"
    Invoke-SqliteQuery -DataSource $Database -Query "DELETE FROM TEAM_STATS WHERE game_id = '$GameId'"
    Invoke-SqliteQuery -DataSource $Database -Query "DELETE FROM GAME_ROUNDS WHERE game_id = '$GameId'"
    Invoke-SqliteQuery -DataSource $Database -Query "DELETE FROM GAMES WHERE game_id = '$GameId'"
}