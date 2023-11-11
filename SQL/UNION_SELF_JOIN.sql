-- Query 1:
/* There are source and target and there are records new in source,
	there are records new on target,
	and there are mismatched record
    find all the items without using sub-queries*/
select * from source;
select * from target;

select s.name, 'New in source' as remark
from source s
	LEFT JOIN target t
	ON s.id = t.id
	WHERE t.id is null
		union
	select t.name, 'New in target' as remark
	from source s
	RIGHT JOIN target t
	ON s.id = t.id
	WHERE s.id is null
		union
	select s.name, 'Name mismatch' as remark
	from source s
	JOIN target t
	ON s.id = t.id
	where s.name <> t.name;

-- Query 2:
/* There are 10 IPL team. write an sql query such that each team play with every other team just once. */
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

WITH new_team as (
select *,
ROW_NUMBER() OVER() as rnb 
from teams)

select * 
from new_team t1
JOIN new_team t2
ON t1.rnb < t2.rnb
ORDER BY t1.rnb,t2.rnb;

-- Query 3:
-- From the doctors table, fetch the details of doctors who work in the same hospital but in different speciality.
-- Table Structure:
drop table doctors;
create table doctors
(
id int primary key,
name varchar(50) not null,
speciality varchar(100),
hospital varchar(50),
city varchar(50),
consultation_fee int
);

insert into doctors values
(1, 'Dr. Shashank', 'Ayurveda', 'Apollo Hospital', 'Bangalore', 2500),
(2, 'Dr. Abdul', 'Homeopathy', 'Fortis Hospital', 'Bangalore', 2000),
(3, 'Dr. Shwetha', 'Homeopathy', 'KMC Hospital', 'Manipal', 1000),
(4, 'Dr. Murphy', 'Dermatology', 'KMC Hospital', 'Manipal', 1500),
(5, 'Dr. Farhana', 'Physician', 'Gleneagles Hospital', 'Bangalore', 1700),
(6, 'Dr. Maryam', 'Physician', 'Gleneagles Hospital', 'Bangalore', 1500);

select * from doctors;

-- Solution:
select d1.name, d1.speciality,d1.hospital,d2.name,d2.speciality,d2.hospital
from doctors d1
join doctors d2
on d1.id <> d2.id AND d1.hospital = d2.hospital AND d1.speciality <> d2.speciality;

-- Sub Question:
-- Now find the doctors who work in same hospital irrespective of their speciality.
-- Solution:
select d1.name, d1.speciality,d1.hospital,d2.name,d2.speciality,d2.hospital
from doctors d1
join doctors d2
on d1.id <> d2.id AND d1.hospital = d2.hospital;

-- Query 4:
-- From the login_details table, fetch the users who logged in consecutively 3 or more times.
-- Table Structure:

drop table login_details;
create table login_details(
login_id int primary key,
user_name varchar(50) not null,
login_date date);

delete from login_details;
insert into login_details values
(101, 'Michael', current_date),
(102, 'James', current_date),
(103, 'Stewart', current_date+1),
(104, 'Stewart', current_date+1),
(105, 'Stewart', current_date+1),
(106, 'Michael', current_date+2),
(107, 'Michael', current_date+2),
(108, 'Stewart', current_date+3),
(109, 'Stewart', current_date+3),
(110, 'James', current_date+4),
(111, 'James', current_date+4),
(112, 'James', current_date+5),
(113, 'James', current_date+6);

select * from login_details;
-- Solution
WITH tbl AS (select *,
	LAG(login_date) OVER() as prv,
    LEAD(login_date) OVER() as next
from login_details
ORDER BY 2)

SELECT user_name
FROM tbl
WHERE prv = login_date - INTERVAL '1' day
	AND next = login_date + INTERVAL '1' day;
    
-- Query 5:
-- From the weather table, fetch all the records when London had extremely cold temperature for 3 consecutive days or more.
-- Note: Weather is considered to be extremely cold then its temperature is less than zero.
-- Table Structure:

drop table weather;
create table weather
(
id int,
city varchar(50),
temperature int,
day date
);
delete from weather;
insert into weather values
(1, 'London', -1, STR_TO_DATE('2021 Jan 01','%Y %M %d')),
(2, 'London', -2, STR_TO_DATE('2021 Jan 02','%Y %M %d')),
(3, 'London', 4, STR_TO_DATE('2021 Jan 03','%Y %M %d')),
(4, 'London', 1, STR_TO_DATE('2021 Jan 04','%Y %M %d')),
(5, 'London', -2, STR_TO_DATE('2021 Jan 05','%Y %M %d')),
(6, 'London', -5, STR_TO_DATE('2021 Jan 06','%Y %M %d')),
(7, 'London', -7, STR_TO_DATE('2021 Jan 07','%Y %M %d')),
(8, 'London', 5, STR_TO_DATE('2021 Jan 08','%Y %M %d'));

select * from weather;
-- Solution
SELECT day
FROM (
	select *,
	CASE
		WHEN temperature <0 AND
			LEAD(temperature) OVER(ORDER BY ID)<0
            AND LEAD(temperature,2) OVER(ORDER BY ID)<0
            THEN 'YES'
		WHEN temperature <0 
			AND LEAD(temperature) OVER(ORDER BY ID)<0
            AND LAG(temperature) OVER(ORDER BY ID)<0
            THEN 'YES'
		WHEN temperature <0 
			AND LAG(temperature) OVER(ORDER BY ID)<0
            AND LAG(temperature,2) OVER(ORDER BY ID)<0 
            THEN 'YES'
	END as chk_f
from weather
) X
WHERE chk_f='YES';

-- Query 6:
-- Find the top 2 accounts with the maximum number of 
-- unique patients on a monthly basis.
-- Note: Prefer the account if with the least value in case of same number of unique patients
-- Table Structure:

drop table patient_logs;
create table patient_logs
(
  account_id int,
  date date,
  patient_id int
);

insert into patient_logs values (1, STR_TO_DATE('02 Jan 2020','%d %M %Y'), 100);
insert into patient_logs values (1, STR_TO_DATE('27 Jan 2020','%d %M %Y'), 200);
insert into patient_logs values (2, STR_TO_DATE('01 Jan 2020','%d %M %Y'), 300);
insert into patient_logs values (2, STR_TO_DATE('21 Jan 2020','%d %M %Y'), 400);
insert into patient_logs values (2, STR_TO_DATE('21 Jan 2020','%d %M %Y'), 300);
insert into patient_logs values (2, STR_TO_DATE('01 Jan 2020','%d %M %Y'), 500);
insert into patient_logs values (3, STR_TO_DATE('20 Jan 2020','%d %M %Y'), 400);
insert into patient_logs values (1, STR_TO_DATE('04 Mar 2020','%d %M %Y'), 500);
insert into patient_logs values (3, STR_TO_DATE('20 Jan 2020','%d %M %Y'), 450);

select * from patient_logs;
-- Solution
WITH tbl as (
	SELECT *,
	DENSE_RANK() OVER(PARTITION BY month ORDER BY cnt DESC,account_id ASC) as rnk
FROM (
	select MONTHNAME(date) as month,
	account_id,
	count(distinct patient_id) as cnt
from patient_logs
GROUP BY 1,2
) X)

select month,account_id,cnt as unique_count
from tbl
where rnk <3;
