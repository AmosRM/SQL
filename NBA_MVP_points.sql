SELECT 
	SEASON_ID
	,TEAM_ABBREVIATION
	,PLAYER_NAME
	,avg(PIEs) as avg_PIEs
	,avg(GmSc) as avg_GmSc
	,(avg(PIEs) + avg(GmSc)) as avg_MVP
FROM
(
SELECT 
	bs.GAME_ID
	,f.SEASON_ID
	,bs.TEAM_ABBREVIATION
	,bs.PLAYER_ID
	,bs.PLAYER_NAME
	,bs.PTS
	,(bv.PIE*100) as PIEs
	,(bs.PTS +(0.4*bs.FGM) -(0.7*bs.FGA) - (0.4*(bs.FTA-bs.FTM)) + (0.7*bs.OREB) +(0.3*bs.DREB) + bs.STL + (0.7*bs.AST) + (0.7*bs.BLK) -(0.4*bs.PF) - [TO]) as GmSc
FROM all_players_finals_bscore bs
LEFT OUTER JOIN finals_boxscorev2 bv
	on bs.PLAYER_ID = bv.PLAYER_ID
	AND bs.GAME_ID = bv.GAME_ID
LEFT OUTER JOIN finals f
	on bs.GAME_ID = f.GAME_ID
WHERE bv.START_POSITION not NULL
) cal
GROUP BY SEASON_ID, PLAYER_NAME
HAVING avg_MVP > 30
ORDER BY avg_MVP DESC