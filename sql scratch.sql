-- SQLite
ALTER TABLE PLAYER_IDS RENAME TO PLAYERS;
ALTER TABLE PLAYERS ADD COLUMN mmr INTEGER NULL;
ALTER TABLE PLAYERS ADD COLUMN team TEXT NULL;
ALTER TABLE PLAYERS RENAME COLUMN MMR TO mmr;

SELECT * FROM PLAYERS;

INSERT INTO PLAYERS (steam_id, name) VALUES ('76561198168895291','HoneyedBiscuit');
INSERT INTO PLAYERS (steam_id, name) VALUES ('76561198028038300','AlexAlexov');
INSERT INTO PLAYERS (steam_id, name) VALUES ('76561197989705408','steez');
INSERT INTO PLAYERS (steam_id, name) VALUES ('76561198277444580','beef');
INSERT INTO PLAYERS (steam_id, name) VALUES ('76561198797718588','IAmArch');


SELECT * FROM GAMES;

UPDATE GAMES SET csc_id = 'M11' WHERE game_id = '394e02b3-9c86-422f-a2f6-e0cb0e483f43';
UPDATE GAMES SET csc_id = 'M11' WHERE game_id = '32c2f3db-b043-4f27-bbfb-c6772b97194c';
UPDATE GAMES SET csc_id = 'M12' WHERE game_id = 'e8c44097-08f1-4491-abc3-674ce279b284';
UPDATE GAMES SET csc_id = 'M12' WHERE game_id = 'b19ec78c-9eac-44d0-b4ac-f2da21dd620c';


SELECT * FROM PLAYERS;

SELECT * FROM GAMES;

UPDATE GAMES SET csc_id = 'M10' WHERE game_id = '7362a701-1040-4a0e-b970-a6966671ac95';

.tables

UPDATE GAMES
SET date = '2025-04-10',
    csc_id = 'M06'
WHERE game_id = '473aa348-62ed-4c3c-9f8c-adb7ad8cd5b8';


SELECT * FROM GAMES ORDER BY csc_id;
SELECT * FROM GAME_ROUNDS;

SELECT * FROM PLAYER_STATS_TOTAL
WHERE game_id = '142a2212-e015-4fb8-9173-7ff9fb56b20f'
ORDER BY team_name, rating DESC;

SELECT * FROM TEAM_STATS;

UPDATE GAME_ROUNDS
SET winner_side = 'T'
WHERE game_id = '1495eb9b-8537-459f-be65-3b9a792bcbaa'
    AND round_num = 35
;

SELECT * FROM PLAYER_STATS_T WHERE game_id = 'bd29bbb7-ef53-4bb1-852f-2fdc524d699e';

INSERT INTO PLAYERS (steam_id, name) VALUES ('76561198225517508','Rymaster');
INSERT INTO PLAYERS (steam_id, name) VALUES ('76561198851562577','joe');
INSERT INTO PLAYERS (steam_id, name) VALUES ('76561199082886629','Lance');
INSERT INTO PLAYERS (steam_id, name) VALUES ('76561198069525004','PalomaSucio');

SELECT * FROM PLAYERS;

SELECT DISTINCT(round_end_reason) FROM GAME_ROUNDS;

SELECT team_a, team_b, winner, map
FROM GAMES
WHERE game_id = '1495eb9b-8537-459f-be65-3b9a792bcbaa'
;
SELECT s.team_name,
    p.name,
    ROUND(s.rating,2) AS `rating`,
    s.kills,
    s.assists,
    s.deaths,
    ROUND(s.adr,1) AS `adr`,
    s.opening_kills || ":" || s.opening_deaths AS `fk:fd`,
    ROUND(s.kast * 100,1) || "%" AS `kast`,
    ROUND(s.impact,2) AS `impact`,
    s.util_dmg,
    s.ef
FROM PLAYER_STATS_TOTAL s
JOIN PLAYERS p ON p.steam_id = s.steam_id
WHERE game_id = '1495eb9b-8537-459f-be65-3b9a792bcbaa'
ORDER BY s.team_name,s.rating DESC
;
SELECT round_num,
    winner_team,
    winner_side,
    round_end_reason
FROM GAME_ROUNDS
WHERE game_id = '473aa348-62ed-4c3c-9f8c-adb7ad8cd5b8'
ORDER BY round_num ASC
;

SELECT * FROM GAME_ROUNDS;

SELECT s.team_name,
    p.name,
    ROUND(s.rating,2) AS `rating`,
    s.kills,
    s.assists,
    s.deaths,
    ROUND(s.kast * 100,1) || "%" AS `kast`,
    s.opening_kills AS `fk`,
    s.opening_deaths AS `fd`,
    s.util_dmg,
    s.util_thrown
FROM PLAYER_STATS_TOTAL s
JOIN PLAYERS p ON p.steam_id = s.steam_id
ORDER BY s.team_name,s.rating DESC
;

.schema TEAMS

DROP TABLE TEAMS;

CREATE TABLE `TEAMS`(
    `team_name` TEXT NOT NULL,
    `franchise_name` TEXT NULL,
    `tier` TEXT NULL,
    FOREIGN KEY(`franchise_name`) REFERENCES FRANCHISES(`franchise_name`),
    FOREIGN KEY(`tier`) REFERENCES TIERS(`tier_name`),
    PRIMARY KEY(`team_name`)
);


ALTER TABLE TEAMS ALTER COLUMN franchise_name NULL;

INSERT INTO MAPS VALUES ('de_inferno');
INSERT INTO MAPS VALUES ('de_mirage');
INSERT INTO MAPS VALUES ('de_nuke');
INSERT INTO MAPS VALUES ('de_ancient');
INSERT INTO MAPS VALUES ('de_anubis');
INSERT INTO MAPS VALUES ('de_train');
INSERT INTO MAPS VALUES ('de_overpass');
INSERT INTO MAPS VALUES ('de_cache');
INSERT INTO MAPS VALUES ('de_cbble');

INSERT INTO TEAMS (team_name) VALUES ('Spreadsheet Enjoyers');
INSERT INTO TEAMS (team_name) VALUES ('Bongo Bangers');
INSERT INTO TEAMS (team_name) VALUES ('Peeble Palace');
INSERT INTO TEAMS (team_name) VALUES ('Smells Like Team Spirit');


SELECT *
FROM PLAYER_STATS_TOTAL s
JOIN GAMES g ON g.game_id = s.game_id
JOIN PLAYERS p ON p.steam_id = s.steam_id;


SELECT p.name,
    ROUND(sum(s.rating * s.rounds) / sum(s.rounds),2) AS `rating1.0`
FROM PLAYER_STATS_TOTAL s
LEFT JOIN PLAYERS p ON p.steam_id = s.steam_id
GROUP BY p.name
ORDER BY p.name ASC
;

SELECT * FROM GAME_ROUNDS WHERE game_id = 'a30bccbd-1fc6-4348-8531-cb46763341d0';


UPDATE GAMES SET team_b = 'Greek Yogurt' WHERE game_id = 'a30bccbd-1fc6-4348-8531-cb46763341d0';
UPDATE GAME_ROUNDS SET winner_team = 'Greek Yogurt' WHERE winner_team = 'Bongo Bangers' AND game_id = 'a30bccbd-1fc6-4348-8531-cb46763341d0';
UPDATE GAME_ROUNDS SET team_b = 'Greek Yogurt' WHERE game_id = 'a30bccbd-1fc6-4348-8531-cb46763341d0';
UPDATE GAMES SET team_b = 'Greek Yogurt' WHERE game_id = 'a30bccbd-1fc6-4348-8531-cb46763341d0';
UPDATE GAMES SET team_b = 'Greek Yogurt' WHERE game_id = 'a30bccbd-1fc6-4348-8531-cb46763341d0';

UPDATE GAMES SET csc_id = 'M07' WHERE game_id = '46f1a3bf-c3ee-419e-9588-15a84eb461b7';

SELECT * FROM GAMES;
SELECT kast * 100 FROM PLAYER_STATS_TOTAL;

--playerData export
SELECT g.game_id,
    g.csc_id,
    g.date,
    g.map,
    p.name,
    ((0.00738764 * (s.kast * 100)) + (0.35912389 * (s.kills * 1.0 / s.rounds)) + (-0.5329508 * (s.deaths * 1.0 / s.rounds)) + (0.2372603 * s.impact) + (0.0032397 * s.adr) + 0.15872723249055132) AS rating,
    --((0.00738764 * (c.kast * 100)) + (0.35912389 * (c.kills * 1.0 / c.rounds)) + (-0.5329508 * (c.deaths * 1.0 / c.rounds)) + (0.2372603 * c.impact) + (0.0032397 * c.adr) + 0.15872723249055132) AS ctRating,
    --((0.00738764 * (t.kast * 100)) + (0.35912389 * (t.kills * 1.0 / t.rounds)) + (-0.5329508 * (t.deaths * 1.0 / t.rounds)) + (0.2372603 * t.impact) + (0.0032397 * t.adr) + 0.15872723249055132) AS tRating,
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
JOIN PLAYER_STATS_CT c ON c.game_id = s.game_id AND c.steam_id = s.steam_id
JOIN PLAYER_STATS_T t ON t.game_id = s.game_id AND t.steam_id = s.steam_id
JOIN GAMES g ON g.game_id = s.game_id
WHERE g.game_id = 'a30bccbd-1fc6-4348-8531-cb46763341d0'
;

SELECT p.name, SUM(s.saves)
FROM PLAYER_STATS_TOTAL s
JOIN PLAYERS p ON p.steam_id = s.steam_id
GROUP BY p.name
ORDER BY SUM(s.saves) DESC
;

SELECT *
FROM PLAYER_STATS_TOTAL s
JOIN PLAYERS p ON p.steam_id = s.steam_id
LEFT JOIN PLAYER_STATS_CT c ON c.game_id = s.game_id AND c.steam_id = s.steam_id
LEFT JOIN PLAYER_STATS_T t ON t.game_id = s.game_id AND t.steam_id = s.steam_id
WHERE s.game_id = 'a30bccbd-1fc6-4348-8531-cb46763341d0';

--rounds export
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


--game export
SELECT
    g.game_id,
    g.csc_id,
    g.date,
    g.map,
    g.team_a,
    SUM(CASE WHERE
FROM GAMES g
JOIN GAME_ROUNDS r ON r.game_id = g.game_id;

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
LEFT JOIN 
    GAME_ROUNDS gr
ON 
    g.game_id = gr.game_id
GROUP BY 
    g.game_id, g.map, g.date, g.csc_id, g.team_a, g.team_b
ORDER BY 
    g.csc_id
;


SELECT * FROM TEAM_STATS WHERE game_id = '4cdc061f-ee10-4b8d-8b1e-4ba22655f98c';

UPDATE TEAM_STATS
SET team_name = 'Greek Yogurt'
WHERE game_id = '4cdc061f-ee10-4b8d-8b1e-4ba22655f98c'
    AND team_name  = 'tmp'
;
