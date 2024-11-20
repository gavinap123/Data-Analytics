--What is the percentage of draws in the 2019 season?
WITH draw_stats AS (
	SELECT 
		COUNT(*) FILTER (WHERE ftr = 'D') AS num_draws,
		COUNT(*) AS total_matches
	FROM matches
	WHERE season_end_year = 2019
)
SELECT num_draws,
		total_matches,
  		num_draws::numeric / total_matches::numeric AS draw_percentage
FROM draw_stats;

--What is the total number of goals scored by each team in the 2005 season?
WITH home_goals AS (
    SELECT 
        home AS team,
        SUM(homegoals) AS goals
    FROM matches
    WHERE season_end_year = 2005
    GROUP BY home
),
away_goals AS (
    SELECT 
        away AS team,
        SUM(awaygoals) AS goals
    FROM matches
    WHERE season_end_year = 2005
    GROUP BY away
)
SELECT 
    team,
    SUM(goals) AS total_goals
FROM (
    SELECT * FROM home_goals
    UNION ALL
    SELECT * FROM away_goals
) AS combined_goals
GROUP BY team
ORDER BY total_goals DESC;

--What is the average number of goals scored per match in each week of the 2020 season?
WITH weekly_goals AS (
    SELECT 
        wk, 
        (homegoals + awaygoals) AS total_goals
    FROM matches
    WHERE season_end_year = 2020
)
SELECT 
    wk, 
    AVG(total_goals) AS avg_goal_gm
FROM weekly_goals
GROUP BY wk
ORDER BY wk;

--What is the average number of goals scored per match  by the home team in each week of the 2014 season?
WITH home_goals AS (
    SELECT 
        wk, 
        homegoals
    FROM matches
    WHERE season_end_year = 2014
)
SELECT 
    wk, 
    AVG(homegoals) AS avg_hm_goal
FROM home_goals
GROUP BY wk
ORDER BY wk;

--Which team has the most wins in the 2017 season, and how many wins do they have?
WITH wins AS (
    SELECT home AS team
    FROM matches
    WHERE season_end_year = 2017 AND ftr = 'H'
    UNION ALL
    SELECT away AS team
    FROM matches
    WHERE season_end_year = 2017 AND ftr = 'A'
)
SELECT 
    team, 
    COUNT(*) AS wins
FROM wins
GROUP BY team
ORDER BY wins DESC
LIMIT 1;

--How often does the home team win per season?
WITH home_wins AS (
    SELECT 
        season_end_year, 
        COUNT(*) AS matches, 
        SUM(CASE WHEN ftr = 'H' THEN 1 ELSE 0 END) AS home_wins
    FROM matches
    GROUP BY season_end_year
)
SELECT 
    season_end_year,
    matches,
    home_wins,
    (home_wins::numeric / matches::numeric) AS home_win_perc
FROM home_wins
ORDER BY season_end_year;

--Which week has the highest number of goals scored per season?
WITH season_week_goals AS (
    SELECT 
        season_end_year, 
        wk,
        SUM(homegoals + awaygoals) AS total_goals
    FROM matches
    GROUP BY season_end_year, wk
),
max_goals AS (
    SELECT 
        season_end_year, 
        MAX(total_goals) AS max_goals
    FROM season_week_goals
    GROUP BY season_end_year
)
SELECT 
    swg.season_end_year, 
    swg.wk, 
    swg.total_goals
FROM season_week_goals swg
JOIN max_goals mg ON swg.season_end_year = mg.season_end_year AND swg.total_goals = mg.max_goals
ORDER BY swg.season_end_year, swg.wk;
