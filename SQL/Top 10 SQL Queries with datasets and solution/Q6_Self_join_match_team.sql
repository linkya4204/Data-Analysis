-- Q6 : IPL Matches ----------------------------------------------- 

drop table teams;
create table teams
    (
        team_code       varchar(10),
        team_name       varchar(40)
    );

insert into teams values ('RCB', 'Royal Challengers Bangalore');
insert into teams values ('MI', 'Mumbai Indians');
insert into teams values ('CSK', 'Chennai Super Kings');
insert into teams values ('DC', 'Delhi Capitals');
insert into teams values ('RR', 'Rajasthan Royals');
insert into teams values ('SRH', 'Sunrisers Hyderbad');
insert into teams values ('PBKS', 'Punjab Kings');
insert into teams values ('KKR', 'Kolkata Knight Riders');
insert into teams values ('GT', 'Gujarat Titans');
insert into teams values ('LSG', 'Lucknow Super Giants');
commit;

select * from teams;
-- Solution: 1) Write an sql query such that each team play with every other team just once. ---
with cte as (
select * ,
	row_number() over() as rnb
from teams)

select *
from cte t1
join cte t2
	on t1.rnb < t2.rnb
order by t1.rnb, t2.rnb;

-- Solution 2) Write an sql query such that each team play with every other team twice.--
with cte as (
select * ,
	cast(row_number() over() as UNSIGNED) as rnb
from teams)

select *
from cte t1
join cte t2
	on t1.rnb < t2.rnb or t1.rnb > t2.rnb
order by t1.rnb, t2.rnb;
