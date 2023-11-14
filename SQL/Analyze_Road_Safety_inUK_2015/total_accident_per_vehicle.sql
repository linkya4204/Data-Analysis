-- Evaluate Accident Severity and Total Accidents per Vehicle Type
with cte as(
	select vt.label as vehicle_type,
		av.label as severity
	from vehicles v
	join accidents acc
		on v.Accident_Index = acc.Accident_Index
	join vehicle_types vt
		on v.Vehicle_Type = vt.code
	join accident_severity av
		on av.code = acc.Accident_Severity)
        
select *, count(*) as accident_count
from cte
group by vehicle_type, severity
order by vehicle_type, accident_count desc;
    