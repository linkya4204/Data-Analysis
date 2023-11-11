-- The exercise will consist of problems that use windows functions, pivot table using CASE WHEN
-- #1) Election Results ---

-- DATASET
create table candidates
(
    id      int,
    gender  varchar(1),
    age     int,
    party   varchar(20)
);
insert into candidates values(1,'M',55,'Democratic');
insert into candidates values(2,'M',51,'Democratic');
insert into candidates values(3,'F',62,'Democratic');
insert into candidates values(4,'M',60,'Republic');
insert into candidates values(5,'F',61,'Republic');
insert into candidates values(6,'F',58,'Republic');

create table results
(
    constituency_id     int,
    candidate_id        int,
    votes               int
);
insert into results values(1,1,847529);
insert into results values(1,4,283409);
insert into results values(2,2,293841);
insert into results values(2,5,394385);
insert into results values(3,3,429084);
insert into results values(3,6,303890);

select * from candidates;
select * from results;

-- Expected output: show how many seats each party have won
with tbl1 as (
	select party, constituency_id, candidate_id,votes,
	rank() over(partition by constituency_id order by votes desc) as rnk
	from candidates c
	join results r 
	on c.id = r.candidate_id
	order by constituency_id, votes desc),
    final_tbl as (
    select party, count(*) as cnt
	from tbl1
	where rnk =1
    group by party
    )
    
select concat(party, ' ',cnt) as election_result
from final_tbl;

--- #2) Advertising System Deviations report ---

-- DATASET
drop table if exists customers;
create table customers
(
    id          int,
    first_name  varchar(50),
    last_name   varchar(50)
);
insert into customers values(1, 'Carolyn', 'O''Lunny');
insert into customers values(2, 'Matteo', 'Husthwaite');
insert into customers values(3, 'Melessa', 'Rowesby');

drop table if exists campaigns;
create table campaigns
(
    id          int,
    customer_id int,
    name        varchar(50)
);
insert into campaigns values(2, 1, 'Overcoming Challenges');
insert into campaigns values(4, 1, 'Business Rules');
insert into campaigns values(3, 2, 'YUI');
insert into campaigns values(1, 3, 'Quantitative Finance');
insert into campaigns values(5, 3, 'MMC');

drop table if exists events;
create table events
(
    campaign_id int,
    status      varchar(50)
);
insert into events values(1, 'success');
insert into events values(1, 'success');
insert into events values(2, 'success');
insert into events values(2, 'success');
insert into events values(2, 'success');
insert into events values(2, 'success');
insert into events values(2, 'success');
insert into events values(3, 'success');
insert into events values(3, 'success');
insert into events values(3, 'success');
insert into events values(4, 'success');
insert into events values(4, 'success');
insert into events values(4, 'failure');
insert into events values(4, 'failure');
insert into events values(5, 'failure');
insert into events values(5, 'failure');
insert into events values(5, 'failure');
insert into events values(5, 'failure');
insert into events values(5, 'failure');
insert into events values(5, 'failure');

insert into events values(4, 'success');
insert into events values(5, 'success');
insert into events values(5, 'success');
insert into events values(1, 'failure');
insert into events values(1, 'failure');
insert into events values(1, 'failure');
insert into events values(2, 'failure');
insert into events values(3, 'failure');

select * from customers;
select * from campaigns;
select * from events;

-- Expected output: find the customer with the most successful/ fail campaigns + name + total
with cte as (
	select concat(first_name, ' ',last_name) as customer_name,
		group_concat(distinct cp.name separator ', ') as campaigns,
		ev.status as event_type,
        count(1) as total,
        rank() over(partition by status order by count(1) desc) as rnk
	from customers c
		join campaigns cp
		on c.id = cp.customer_id
	join events ev
		on cp.id = ev.campaign_id
	group by customer_name, event_type
)

select event_type, customer_name, campaigns,total
from cte
where rnk =1
order by event_type desc;

-- --- #3) Election Exit Poll by state report ---

-- DATASET
drop table if exists candidates_tab;
create table candidates_tab
(
    id          int,
    first_name  varchar(50),
    last_name   varchar(50)
);
insert into candidates_tab values(1, 'Davide', 'Kentish');
insert into candidates_tab values(2, 'Thorstein', 'Bridge');

drop table if exists results_tab;
create table results_tab
(
    candidate_id    int,
    state           varchar(50)
);
insert into results_tab values(1, 'Alabama');
insert into results_tab values(1, 'Alabama');
insert into results_tab values(1, 'California');
insert into results_tab values(1, 'California');
insert into results_tab values(1, 'California');
insert into results_tab values(1, 'California');
insert into results_tab values(1, 'California');
insert into results_tab values(2, 'California');
insert into results_tab values(2, 'California');
insert into results_tab values(2, 'New York');
insert into results_tab values(2, 'New York');
insert into results_tab values(2, 'Texas');
insert into results_tab values(2, 'Texas');
insert into results_tab values(2, 'Texas');

insert into results_tab values(1, 'New York');
insert into results_tab values(1, 'Texas');
insert into results_tab values(1, 'Texas');
insert into results_tab values(1, 'Texas');
insert into results_tab values(2, 'California');
insert into results_tab values(2, 'Alabama');

select * from candidates_tab;
select * from results_tab;

-- expected output: list out number of votes each candidate receives and the ranking
-- Approach #1:
with cte as (
	select concat(first_name, ' ',last_name) as name,
		state,
        count(1) as cnt,
        dense_rank() over(partition by concat(first_name, ' ',last_name) order by count(1) desc) as rnk
	from candidates_tab ct
	join results_tab rt
		on ct.id = rt.candidate_id
	group by name, state
	),
    first as (
		select name, 
        concat(state,' (',cnt,') ') as 1st_place
        from cte
        where rnk =1
    ),
    second as (
		select name, 
        concat(state,' (',cnt,') ') as 2nd_place
        from cte
        where rnk =2
    ),
    third as (
		select name, 
        concat(state,' (',cnt,') ') as 3rd_place
        from cte
        where rnk =3
    )
    
    
select first.name,
	group_concat(distinct 1st_place separator ' , ') as First_place,
    group_concat(distinct 2nd_place separator ' , ') as Second_place,
    group_concat(distinct 3rd_place separator ' , ') as Third_place
from first
join second
	on first.name = second.name
join third 
	on first.name = third.name
group by first.name;

-- Approach #2:
with cte as (
	select concat(first_name, ' ',last_name) as name,
		state,
        count(1) as cnt,
        dense_rank() over(partition by concat(first_name, ' ',last_name) order by count(1) desc) as rnk
	from candidates_tab ct
	join results_tab rt
		on ct.id = rt.candidate_id
	group by name, state
	)
    
select name as 'Candidate name',
	group_concat((case when rnk =1 then concat(state,' (',cnt,') ') end) separator ',' ) as '1st Place',
    group_concat((case when rnk =2 then concat(state,' (',cnt,') ') end) separator ',' ) as '2nd Place',
    group_concat((case when rnk =3 then concat(state,' (',cnt,') ') end) separator ',' ) as '3rd Place'
from cte
where rnk <=3
group by name;
