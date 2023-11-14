-- create accident severity table from Excel file
CREATE TABLE accident_severity(
	code INT,
    label VARCHAR(10)
);

INSERT INTO accident_severity (code, label) 
VALUES 
  (1, 'Fatal'), 
  (2, 'Serious'), 
  (3, 'Slight');
  
select * from accident_severity;