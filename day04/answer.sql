-- Put everything in a schema so its easy to reset. This also makes
-- this automatically reset so we can just run it many times.
DROP SCHEMA IF EXISTS day04 CASCADE;
CREATE SCHEMA day04;

CREATE TABLE day04.inputs (
  id    SERIAL,
  range1 varchar(42),
  range2 varchar(42)
);

-- Use \COPY rather than COPY so its client-side in psql
\COPY day04.inputs (range1, range2) FROM 'day04/input.txt' WITH (FORMAT 'csv');


-- today i learned that in PG I have to explicitly cast to int
-- or otherwise '8' > '10'
select * from day04.inputs where (split_part(range1, '-', 1) >= split_part(range2, '-', 1) and split_part(range1, '-', 2) <= split_part(range2, '-', 2)) or (split_part(range2, '-', 1) >= split_part(range1, '-', 1) and split_part(range2, '-', 2)::int <= split_part(range1, '-', 2)::int);


select count(*) from day04.inputs where (split_part(range1, '-', 1)::int >= split_part(range2, '-', 1)::int and split_part(range1, '-', 1)::int <= split_part(range2, '-', 2)::int) or (split_part(range2, '-', 1)::int >= split_part(range1, '-', 1)::int and split_part(range2, '-', 1)::int <= split_part(range1, '-', 2)::int);
