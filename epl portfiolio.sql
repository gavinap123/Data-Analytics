/*
--What is the percentage of draws in the 2019 season?
SELECT 
  SUM(CASE WHEN ftr = 'D' THEN 1 ELSE 0 END) AS num_draws,
  COUNT(*) AS total_matches,
  SUM(CASE WHEN ftr = 'D' THEN 1 ELSE 0 END)::numeric / count(*)::numeric as draw_percentage
FROM matches
WHERE season_end_year = 2019;
*/
/*
--What is the total number of goals scored by each team in the 2005 season?
SELECT 
  home as team,
  SUM(homegoals) AS home_goals,
  SUM(awaygoals) AS away_goals,
  SUM(homegoals) + SUM(awaygoals) AS total_goals
FROM 
  matches
WHERE 
  season_end_year = 2005
GROUP BY 
  team
UNION ALL
SELECT 
  away,
  SUM(awaygoals) AS home_goals,
  SUM(homegoals) AS away_goals,
  SUM(awaygoals) + SUM(homegoals) AS total_goals
FROM 
  matches
WHERE 
  season_end_year = 2005
GROUP BY 
  away
ORDER BY 
  total_goals DESC;
*/
/*  
--What is the average number of goals scored per match in each week of the 2020 season?
select wk, avg(homegoals + awaygoals) as avg_goal_gm
from matches
where season_end_year = 2020
group by wk
order by wk;
*/
/*
--What is the average number of goals scored per match  by the home team in each week of the 2014 season?
select wk, avg(homegoals) as avg_hm_goal
from matches
where season_end_year = 2014
group by wk
order by wk
*/
/*
--Which team has the most wins in the 2017 season, and how many wins do they have?
select team, count(*) as wins
from 
(
select home as team
from matches
where season_end_year = 2017 and ftr = 'H'
union all
select away as team
from matches
where season_end_year = 2017 and ftr = 'A'
) as wins
group by team
order by wins desc
limit 1;

--17 home wins 13 away
*/
/*
--How often does the home team win per season?
select season_end_year, count(*) as matches, SUM(CASE WHEN ftr = 'H' THEN 1 ELSE 0 END) AS home_wins,
	(SUM(CASE WHEN ftr = 'H' THEN 1 ELSE 0 END)::numeric / count(*))::numeric as home_win_perc
from matches
where season_end_year = 2000
group by season_end_year
order by season_end_year
*/
/*
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
*/