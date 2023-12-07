-- Q10: Pizza Delivery Status --- 

drop table cust_orders;
create table cust_orders
(
cust_name   varchar(50),
order_id    varchar(10),
status      varchar(50)
);

insert into cust_orders values ('John', 'J1', 'DELIVERED');
insert into cust_orders values ('John', 'J2', 'DELIVERED');
insert into cust_orders values ('David', 'D1', 'SUBMITTED');
insert into cust_orders values ('David', 'D2', 'DELIVERED'); -- This record is missing in question
insert into cust_orders values ('David', 'D3', 'CREATED');
insert into cust_orders values ('Smith', 'S1', 'SUBMITTED');
insert into cust_orders values ('Krish', 'K1', 'CREATED');
commit;
-- Solution: Write a query to report the customer_name and Final_Status of each customer's arder. Order the results by customer
select * from cust_orders;

select distinct cust_name as customer_name,
	'COMPLETE' as status
from cust_orders d
	where d.status = 'DELIVERED'
    and not exists (
		select 1 from cust_orders d2
        where d2.cust_name = d.cust_name
        and d2.status in ('SUBMITTED','CREATED')
    )
	union
select distinct cust_name as customer_name,
	'IN PROGRESS' as status
from cust_orders d
	where d.status = 'DELIVERED'
    and exists (
		select 1 from cust_orders d2
        where d2.cust_name = d.cust_name
        and d2.status in ('SUBMITTED','CREATED')
    )
	union
select distinct cust_name as customer_name,
	'AWAITING PROGRESS' as status
from cust_orders d
	where d.status = 'SUBMITTED'
    and not exists (
		select 1 from cust_orders d2
        where d2.cust_name = d.cust_name
        and d2.status in ('DELIVERED','CREATED')
    )
    union
select distinct cust_name as customer_name,
	'AWAITING SUBMISSION' as status
from cust_orders d
	where d.status = 'CREATED'
    and not exists (
		select 1 from cust_orders d2
        where d2.cust_name = d.cust_name
        and d2.status in ('DELIVERED','SUBMITTED')
    );