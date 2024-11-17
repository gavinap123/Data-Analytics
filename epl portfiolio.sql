--What is the percentage of draws in the 2019 season?
SELECT 
COUNT(*) FILTER (WHERE ftr = 'D') AS num_draws,
  COUNT(*) AS total_matches,
  COUNT(*) FILTER (WHERE ftr = 'D')::numeric / COUNT(*)::numeric AS draw_percentage
  FROM matches
WHERE season_end_year = 2019;

--What is the total number of goals scored by each team in the 2005 season?
SELECT 
    team,
    SUM(goals) AS total_goals
FROM (
    SELECT 
        home AS team,
        SUM(homegoals) AS goals
    FROM matches
    WHERE season_end_year = 2005
    GROUP BY home
    
    UNION ALL
    
    SELECT 
        away AS team,
        SUM(awaygoals) AS goals
    FROM matches
    WHERE season_end_year = 2005
    GROUP BY away
) AS combined_goals
GROUP BY team
ORDER BY total_goals DESC;
--What is the total number of goals scored by each team in the 2005 season? 
SELECT 
	home as team,
	SUM(homegoals) AS home_goals,
	SUM(awaygoals) AS away_goals, 
	SUM(homegoals) + SUM(awaygoals) AS total_goals 
FROM matches 
WHERE season_end_year = 2005 
GROUP BY team 
UNION ALL 
SELECT 
	away, 
	SUM(awaygoals) AS home_goals, 
	SUM(homegoals) AS away_goals, 
	SUM(awaygoals) + SUM(homegoals) AS total_goals 
FROM matches 
WHERE season_end_year = 2005 
GROUP BY away 
ORDER BY total_goals DESC;

--What is the average number of goals scored per match in each week of the 2020 season?
SELECT wk, 
		avg(homegoals + awaygoals) AS avg_goal_gm
FROM matches
WHERE season_end_year = 2020
GROUP BY wk
ORDER BY wk;
--What is the average number of goals scored per match in each week of the 2020 season? 
SELECT wk, 
	avg(homegoals + awaygoals) AS avg_goal_gm 
FROM matches 
WHERE season_end_year = 2020 
GROUP BY wk 
ORDER BY wk;

--What is the average number of goals scored per match  by the home team in each week of the 2014 season?
SELECT wk, avg(homegoals) AS avg_hm_goal
FROM matches
WHERE season_end_year = 2014
GROUP BY wk
ORDER BY wk;

--Which team has the most wins in the 2017 season, and how many wins do they have?
SELECT
	team, 
	count(*) AS wins
FROM (
	SELECT home AS team
	FROM matches
	WHERE season_end_year = 2017 AND ftr = 'H'
UNION ALL
	SELECT away AS team
	FROM matches
	WHERE season_end_year = 2017 AND ftr = 'A'
) AS wins
GROUP BY team
ORDER BY wins DESC
LIMIT 1;

--How often does the home team win per season?
SELECT season_end_year, 
	COUNT(*) AS matches, 
	SUM(CASE WHEN ftr = 'H' THEN 1 ELSE 0 END) AS home_wins,
	(SUM(CASE WHEN ftr = 'H' THEN 1 ELSE 0 END)::numeric / COUNT(*))::numeric AS home_win_perc
FROM matches
GROUP BY season_end_year
ORDER BY season_end_year;

--Which week has the highest number of goals scored per season?
WITH season_week_goals AS
(
SELECT season_end_year, wk,
    SUM(homegoals + awaygoals) AS total_goals
FROM matches
GROUP BY season_end_year, wk
)
SELECT season_end_year, wk, total_goals
FROM season_week_goals
WHERE 
  (season_end_year, total_goals) IN 
( 
SELECT season_end_year, MAX(total_goals)
FROM season_week_goals
GROUP BY season_end_year
)
ORDER BY season_end_year, wk;
