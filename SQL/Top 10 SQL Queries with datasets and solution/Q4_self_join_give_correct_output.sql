-- Q4 : Convert the given input to expected output -------------------------------------------------

drop table src_dest_distance;
create table src_dest_distance
(
    source          varchar(20),
    destination     varchar(20),
    distance        int
);
insert into src_dest_distance values ('Bangalore', 'Hyderbad', 400);
insert into src_dest_distance values ('Hyderbad', 'Bangalore', 400);
insert into src_dest_distance values ('Mumbai', 'Delhi', 400);
insert into src_dest_distance values ('Delhi', 'Mumbai', 400);
insert into src_dest_distance values ('Chennai', 'Pune', 400);
insert into src_dest_distance values ('Pune', 'Chennai', 400);

select * from src_dest_distance;
-- Solution ---------------------------
with cte as (
	select *,
    row_number() over() as rnb
    from src_dest_distance
)

select c1.*
from cte c1
join cte c2
	on c1.rnb < c2.rnb
    and c1.source = c2.destination
    and c2.destination = c1.source;
