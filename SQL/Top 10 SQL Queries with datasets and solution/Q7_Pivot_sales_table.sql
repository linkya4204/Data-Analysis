-- Q7 : Pivot the output -------------------------------------------------------- 

drop table sales_data;
create table sales_data
    (
        sales_date      date,
        customer_id     varchar(30),
        amount          varchar(30)
    );
insert into sales_data values (str_to_date('01-Jan-2021','%d-%b-%Y'), 'Cust-1', '50$');
insert into sales_data values (str_to_date('02-Jan-2021','%d-%b-%Y'), 'Cust-1', '50$');
insert into sales_data values (str_to_date('03-Jan-2021','%d-%b-%Y'), 'Cust-1', '50$'); 
insert into sales_data values (str_to_date('01-Jan-2021','%d-%b-%Y'), 'Cust-2', '100$');
insert into sales_data values (str_to_date('02-Jan-2021','%d-%b-%Y'), 'Cust-2', '100$');
insert into sales_data values (str_to_date('03-Jan-2021','%d-%b-%Y'), 'Cust-2', '100$');
insert into sales_data values (str_to_date('01-Feb-2021','%d-%b-%Y'), 'Cust-2', '-100$');
insert into sales_data values (str_to_date('02-Feb-2021','%d-%b-%Y'), 'Cust-2', '-100$');
insert into sales_data values (str_to_date('03-Feb-2021','%d-%b-%Y'), 'Cust-2', '-100$');
insert into sales_data values (str_to_date('01-Mar-2021','%d-%b-%Y'), 'Cust-3', '1$');
insert into sales_data values (str_to_date('01-Apr-2021','%d-%b-%Y'), 'Cust-3', '1$');
insert into sales_data values (str_to_date('01-May-2021','%d-%b-%Y'), 'Cust-3', '1$');
insert into sales_data values (str_to_date('01-Jun-2021','%d-%b-%Y'), 'Cust-3', '1$');
insert into sales_data values (str_to_date('01-Jul-2021','%d-%b-%Y'), 'Cust-3', '-1$');
insert into sales_data values (str_to_date('01-Aug-2021','%d-%b-%Y'), 'Cust-3', '-1$');
insert into sales_data values (str_to_date('01-Sep-2021','%d-%b-%Y'), 'Cust-3', '-1$');
insert into sales_data values (str_to_date('01-Oct-2021','%d-%b-%Y'), 'Cust-3', '-1$');
insert into sales_data values (str_to_date('01-Nov-2021','%d-%b-%Y'), 'Cust-3', '-1$');
insert into sales_data values (str_to_date('01-Dec-2021','%d-%b-%Y'), 'Cust-3', '-1$');

select * from sales_data;
-- Solution ------
with unpack_tbl as (
select coalesce(customer_id,'Total') as customer,
	concat(coalesce(sum(case when month(sales_date)=1 then amount end),0),'$') as Jan_21,
    concat(coalesce(sum(case when month(sales_date)=2 then amount end),0),'$') as Feb_21,
    concat(coalesce(sum(case when month(sales_date)=3 then amount end),0),'$') as Mar_21,
    concat(coalesce(sum(case when month(sales_date)=4 then amount end),0),'$') as Apr_21,
    concat(coalesce(sum(case when month(sales_date)=5 then amount end),0),'$') as May_21,
    concat(coalesce(sum(case when month(sales_date)=6 then amount end),0),'$') as Jun_21,
    concat(coalesce(sum(case when month(sales_date)=7 then amount end),0),'$') as Jul_21,
    concat(coalesce(sum(case when month(sales_date)=8 then amount end),0),'$') as Aug_21,
    concat(coalesce(sum(case when month(sales_date)=9 then amount end),0),'$') as Sep_21,
    concat(coalesce(sum(case when month(sales_date)=10 then amount end),0),'$') as Oct_21,
    concat(coalesce(sum(case when month(sales_date)=11 then amount end),0),'$') as Nov_21,
    concat(coalesce(sum(case when month(sales_date)=12 then amount end),0),'$') as Dec_21
from sales_data
group by customer_id with rollup)

select customer,
	case when Jan_21 <0 then concat('(',ABS(Jan_21), ')$') else Jan_21 end as 'Jan-21',
    case when Feb_21 <0 then concat('(',ABS(Feb_21), ')$') else Feb_21 end as 'Feb-21',
    case when Mar_21 <0 then concat('(',ABS(Mar_21), ')$') else Mar_21 end as 'Mar-21',
    case when Apr_21 <0 then concat('(',ABS(Apr_21), ')$') else Apr_21 end as 'Apr-21',
    case when May_21 <0 then concat('(',ABS(May_21), ')$') else May_21 end as 'May-21',
    case when Jun_21 <0 then concat('(',ABS(Jun_21), ')$') else Jun_21 end as 'Jun-21',
    case when Jul_21 <0 then concat('(',ABS(Jul_21), ')$') else Jul_21 end as 'July-21',
    case when Aug_21 <0 then concat('(',ABS(Aug_21), ')$') else Aug_21 end as 'Aug-21',
    case when Sep_21 <0 then concat('(',ABS(Sep_21), ')$') else Sep_21 end as 'Sep-21',
    case when Oct_21 <0 then concat('(',ABS(Oct_21), ')$') else Oct_21 end as 'Oct-21',
    case when Nov_21 <0 then concat('(',ABS(Nov_21), ')$') else Nov_21 end as 'Nov-21',
    case when Dec_21 <0 then concat('(',ABS(Dec_21), ')$') else Dec_21 end as 'Dec-21'
from unpack_tbl;
