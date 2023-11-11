use olympic;
truncate table olympic_history;
select count(1) from olympic_history;

-- 1. How many olympics games have been held?
select count(distinct Games) as game_count from olympic_history;

-- 2. List down all Olympics games held so far.
select distinct Games from olympic_history
order by Games;

-- 3. Mention the total no of nations who participated in each olympics game?
select Games, count(distinct Team) as total_nation  
from olympic_history
group by Games
order by Games;

-- 4. Which year saw the highest and lowest no of countries participating in olympics?
WITH tbl AS (
	select Games,count(distinct Team) as total_nation  
	from olympic_history
	group by Games
)

select Games, total_nation
from tbl
where total_nation = (SELECT MAX(total_nation) from tbl)
	OR total_nation = (SELECT MIN(total_nation)from tbl);
    
-- 5.Which nation has participated in all of the olympic games?
SELECT region,participated
FROM (
	SELECT noc.region,count(DISTINCT Games) as participated
	FROM olympic_history olp
	JOIN noc_regions noc
	ON olp.NOC = noc.NOC
	GROUP BY noc.region
	ORDER BY noc.region
) X
WHERE participated = (select count(distinct Games) as game_count from olympic_history);

-- 6.Identify the sport which was played in all summer olympics.
SELECT distinct Sport,
	Count(distinct Games) as game_cnt
FROM olympic_history
WHERE Season ='Summer'
GROUP BY Sport
HAVING game_cnt = (
	select count(distinct Games) from olympic_history
    where Season = 'Summer'
);

-- 7.Which Sports were just played only once in the olympics?
SELECT distinct Sport,Count(distinct Games) as game_cnt
FROM olympic_history
GROUP BY Sport
HAVING game_cnt =1;

-- 8.Fetch the total no of sports played in each olympic games.
SELECT Games,COUNT(DISTINCT Sport) as no_of_sports
FROM olympic_history
GROUP BY Games
ORDER BY Games;

-- 9.Fetch details of the oldest athletes to win a gold medal.
SELECT * 
FROM olympic_history
WHERE Medal = 'Gold'
AND Age = (
	SELECT MAX(Age) FROM olympic_history
    WHERE Medal = 'Gold'
);

-- 10.Find the Ratio of male and female athletes participated in all olympic games.
with t1 as (select sex, count(1) as cnt,
	row_number() over(order by count(1)) as rn
	from olympic_history
	group by sex),
	male_cnt as (
		select cnt from t1 where rn=2
    ),
    fem_cnt as (
		select cnt from t1 where rn=1
    )
    
select male_cnt.cnt/fem_cnt.cnt as ratio 
from male_cnt, fem_cnt;


-- 11. Fetch the top 5 athletes who have won the most gold medals.
With medal as (
	SELECT name, COUNT(Medal) as medal_count
	FROM olympic_history
	WHERE Medal = 'Gold'
	GROUP BY name
	ORDER BY 2 DESC),
rank_tbl as (
	SELECT *,
	DENSE_RANK() OVER(order by medal_count DESC) as rnk
    FROM medal
)

SELECT name, medal_count 
FROM rank_tbl
WHERE rnk <= 5;

-- 12.Fetch the top 5 athletes who have won the most medals (gold/silver/bronze).
With total_medal As (SELECT name, COUNT(Medal) as medal_count,
	DENSE_RANK() OVER(order by COUNT(MEDAL) DESC) as rnk
FROM olympic_history
GROUP BY name)

select name, medal_count
from total_medal
where rnk <=5;

-- 13.Fetch the top 5 most successful countries in olympics. Success is defined by no of medals won.
With joined_tbl as (
	Select noc.region,olp.medal 
	from olympic_history olp
	join noc_regions noc
		on olp.NOC = noc.NOC)

SELECT region, count(medal) as total_cnt
FROM joined_tbl
GROUP BY region
ORDER BY 2 DESC
LIMIT 5;

-- 14. List down total gold, silver and broze medals won by each country.
With joined_tbl as (
	Select noc.region,olp.medal 
	from olympic_history olp
	join noc_regions noc
		on olp.NOC = noc.NOC
	where medal <> 'NA')

select region, 
	count(case when medal ='Bronze' then medal else null end) as 'Total_Bronze',
    count(case when medal ='Silver' then medal else null end) as 'Total_Silver',
    count(case when medal ='Gold' then medal else null end) as 'Total_Gold'
from joined_tbl
group by region
order by 3 DESC;

-- 15. List down total gold, silver and broze medals won by each country corresponding to each olympic games.
With joined_tbl as (
	Select olp.games,noc.region,olp.medal 
	from olympic_history olp
	join noc_regions noc
		on olp.NOC = noc.NOC
	where medal <> 'NA')
    
select games, region, 
	count(case when medal ='Bronze' then medal else null end) as 'Total_Bronze',
    count(case when medal ='Silver' then medal else null end) as 'Total_Silver',
    count(case when medal ='Gold' then medal else null end) as 'Total_Gold'
from joined_tbl
group by games, region
order by games, region;


-- 16. Identify which country won the most gold, most silver and most bronze medals in each olympic games.
With joined_tbl as (
	Select olp.games,noc.region,olp.medal 
	from olympic_history olp
	join noc_regions noc
		on olp.NOC = noc.NOC
	where medal <> 'NA')
    
select games, region,
	count(case when medal ='Bronze' then medal else null end) as 'Total_Bronze',
    dense_rank() over() as br_rnk
from joined_tbl
group by games, region;
