-- Solution: Write a query to find the difference in average sales for each month of 2003 and 2004 ---
Select * from sales_order;

with cte as (
	select year(order_date) as year, upper(left(monthname(order_date),3)) as month_name,
		month(order_date) as month_number,
		AVG(sales) as avg_sales
	from sales_order
	group by year, month_name, month_number)
    
select c1.month_name as mon,
	ABS(ROUND((c2.avg_sales - c1.avg_sales),2)) as diff
from cte c1
join cte c2
	on c1.month_number= c2.month_number
    where c1.year =2003 and c2.year=2004
    order by c1.month_number;