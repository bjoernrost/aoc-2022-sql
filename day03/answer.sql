-- Put everything in a schema so its easy to reset. This also makes
-- this automatically reset so we can just run it many times.
DROP SCHEMA IF EXISTS day03 CASCADE;
CREATE SCHEMA day03;

CREATE TABLE day03.inputs (
  id    SERIAL,
  value varchar(100)
);

-- Use \COPY rather than COPY so its client-side in psql
\COPY day03.inputs (value) FROM 'day03/input.txt' WITH (FORMAT 'text');


SELECT SUM(x) FROM 
	(SELECT POSITION(
		UNNEST(
		REGEXP_MATCHES(
		SUBSTRING(value FROM 0 FOR (length(value)/2)+1), '[' || substring(value from (length(value)/2)+1)  ||']')) in 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ') x  from day03.inputs) as subquery;
