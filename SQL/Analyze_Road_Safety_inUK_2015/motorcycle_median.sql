-- Evaluate the median severity value of accidents caused by various Motorcycles.
with cte as(
	select vt.label as motor_type,
		av.label as severity,
        row_number() over(partition by vt.label order by av.code) as rnb
	from vehicles v
	join accidents acc
		on v.Accident_Index = acc.Accident_Index
	join vehicle_types vt
		on v.Vehicle_Type = vt.code
	join accident_severity av
		on av.code = acc.Accident_Severity
	where vt.label like '%motorcycle%'),
    cnt as (
		select motor_type, count(1) as cnt
        from cte
        group by motor_type
    )

select cte.motor_type, severity
from cte
join cnt
	on cte.motor_type = cnt.motor_type
where cte.rnb between cnt.cnt/2.0 and cnt.cnt/2.0+1;