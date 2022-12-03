-- Put everything in a schema so its easy to reset. This also makes
-- this automatically reset so we can just run it many times.
DROP SCHEMA IF EXISTS day01 CASCADE;
CREATE SCHEMA day01;

CREATE TABLE day01.inputs (
  id    SERIAL,
  value INTEGER
);

-- Use \COPY rather than COPY so its client-side in psql
\COPY day01.inputs (value) FROM 'day01/input.txt' WITH (FORMAT 'text', NULL '');

-- Solving with nested subqueries
-- First, assign an index to each reindeer by calculating the number of nulls seen
-- then sum over those groups
-- and fetch the max

SELECT MAX(total_calories) FROM 
	(SELECT SUM(value) total_calories FROM 
		(SELECT value, SUM(CASE WHEN value IS null THEN 1 END) OVER 
			(PARTITION by 1 ORDER BY id) ind FROM day01.inputs) AS subq GROUP BY ind) 
	AS grp;


-- Thank SQL for the LIMIT clause
SELECT SUM(total_calories) FROM 
	(SELECT SUM(value) total_calories FROM 
		(SELECT value, SUM(CASE WHEN value IS null THEN 1 END) OVER 
			(PARTITION by 1 ORDER BY id) ind FROM day01.inputs) AS subq GROUP BY ind ORDER BY total_calories DESC LIMIT 3) 
	AS grp;
