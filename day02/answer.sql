-- Put everything in a schema so its easy to reset. This also makes
-- this automatically reset so we can just run it many times.
DROP SCHEMA IF EXISTS day02 CASCADE;
CREATE SCHEMA day02;

CREATE TABLE day02.inputs (
  id    SERIAL,
  value CHAR(3)
);

-- Use \COPY rather than COPY so its client-side in psql
\COPY day02.inputs (value) FROM 'day02/input.txt' WITH (FORMAT 'text');

select SUM(
-- I am sure there are more elegant ways to decode the results
CASE
	WHEN value = 'A X' then 4
	WHEN value = 'A Y' then 8
	WHEN value = 'A Z' then 3
	WHEN value = 'B X' then 1
	WHEN value = 'B Y' then 5
	WHEN value = 'B Z' then 9
	WHEN value = 'C X' then 7
	WHEN value = 'C Y' then 2
	WHEN value = 'C Z' then 6
END
) FROM day02.inputs;
	

select SUM(
-- I am sure there are more elegant ways to decode the results
CASE
	WHEN value = 'A X' then 0 + 3
	WHEN value = 'A Y' then 3 + 1
	WHEN value = 'A Z' then 6 + 2
	WHEN value = 'B X' then 0 + 1
	WHEN value = 'B Y' then 3 + 2
	WHEN value = 'B Z' then 6 + 3
	WHEN value = 'C X' then 0 + 2
	WHEN value = 'C Y' then 3 + 3
	WHEN value = 'C Z' then 6 + 1
END
) FROM day02.inputs;
	
