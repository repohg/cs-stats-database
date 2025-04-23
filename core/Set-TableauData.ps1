#$db = "D:\demos\draftLeague.db"
$db = "C:\Users\repoh\cs-stats-database\data\draftLeague.db"

$PlayerStatsCsv = "C:\Users\repoh\Desktop\tableau.csv"
$RoundStatsCsv = "C:\Users\repoh\Desktop\draftLeagueRounds.csv"
$GameStatsCsv = "C:\Users\repoh\Desktop\draftLeagueGames.csv"

$PlayerStatsQuery = @"
SELECT g.game_id,
    g.csc_id,
    g.date,
    g.map,
    p.name,
    ((0.00738764 * (s.kast * 100)) + (0.35912389 * (s.kills * 1.0 / s.rounds)) + (-0.5329508 * (s.deaths * 1.0 / s.rounds)) + (0.2372603 * s.impact) + (0.0032397 * s.adr) + 0.15872723249055132) AS rating,
    ((0.00738764 * (c.kast * 100)) + (0.35912389 * (c.kills * 1.0 / c.rounds)) + (-0.5329508 * (c.deaths * 1.0 / c.rounds)) + (0.2372603 * c.impact) + (0.0032397 * c.adr) + 0.15872723249055132) AS ctRating,
    ((0.00738764 * (t.kast * 100)) + (0.35912389 * (t.kills * 1.0 / t.rounds)) + (-0.5329508 * (t.deaths * 1.0 / t.rounds)) + (0.2372603 * t.impact) + (0.0032397 * t.adr) + 0.15872723249055132) AS tRating,
    s.adr,
    s.kast,
    s.kast_rounds,
    s.opening_kills,
    s.opening_deaths,
    s.impact,
    s.death_placement,
    s.util_dmg,
    s.ef,
    s.f_ass,
    s.util_thrown,
    s.hs,
    s.awp_kills,
    s.cl_1,
    s.cl_2,
    s.cl_3,
    s.cl_4,
    s.cl_5,
    s.supp_rounds,
    s.trades,
    s.traded,
    s.saves,
    s.rounds AS rounds,
    c.rounds AS ctRounds,
    t.rounds AS tRounds,
    s.kills,
    s.deaths,
    s.assists,
    s.damage,
    s.damage_taken,
    s.enemy_flash_time,
    s.entries,
    s.mip,
    s.twoK,
    s.threeK,
    s.fourK,
    s.fiveK,
    s.team_name
FROM PLAYER_STATS_TOTAL s
JOIN PLAYERS p ON p.steam_id = s.steam_id
LEFT JOIN PLAYER_STATS_CT c ON c.game_id = s.game_id AND c.steam_id = s.steam_id
LEFT JOIN PLAYER_STATS_T t ON t.game_id = s.game_id AND t.steam_id = s.steam_id
JOIN GAMES g ON g.game_id = s.game_id
;
"@

$RoundStatsQuery = @"
SELECT
    r.game_id,
    r.round_num,
    r.winner_team AS team_name,
    1 AS won,
    r.winner_side,
    r.round_end_reason
FROM GAME_ROUNDS r
UNION ALL
SELECT
    r.game_id,
    r.round_num,
    CASE 
        WHEN r.winner_team = g.team_a THEN g.team_b
        ELSE g.team_a
    END AS team_name,
    0 AS won,
    r.winner_side,
    r.round_end_reason
FROM GAME_ROUNDS r
JOIN GAMES g ON r.game_id = g.game_id;
"@

$GameStatsQuery = @"
SELECT 
    g.game_id,
    g.map,
    g.date,
    g.csc_id,
    g.team_a,
    g.team_b,
    SUM(CASE WHEN gr.winner_team = g.team_a THEN 1 ELSE 0 END) AS score_a,
    SUM(CASE WHEN gr.winner_team = g.team_b THEN 1 ELSE 0 END) AS score_b
FROM 
    GAMES g
LEFT JOIN GAME_ROUNDS gr ON g.game_id = gr.game_id
GROUP BY 
    g.game_id, g.map, g.date, g.csc_id, g.team_a, g.team_b
ORDER BY 
    g.csc_id
;
"@

if (-not (Get-Module -Name PSSQLite)) { Import-Module PSSQLLite }

Invoke-SqliteQuery -DataSource $db -Query $PlayerStatsQuery | Export-Csv -Path $PlayerStatsCsv -NoTypeInformation
Invoke-SqliteQuery -DataSource $db -Query $RoundStatsQuery | Export-Csv -Path $RoundStatsCsv -NoTypeInformation
Invoke-SqliteQuery -DataSource $db -Query $GameStatsQuery | Export-Csv -Path $GameStatsCsv -NoTypeInformation