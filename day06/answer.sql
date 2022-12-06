-- Put everything in a schema so its easy to reset. This also makes
-- this automatically reset so we can just run it many times.
DROP SCHEMA IF EXISTS day06 CASCADE;
CREATE SCHEMA day06;

CREATE TABLE day06.inputs (
  id    SERIAL,
  value varchar(4096)
);

-- Use \COPY rather than COPY so its client-side in psql
\COPY day06.inputs (value) FROM 'day06/input.txt' WITH (FORMAT 'text');


create or replace function solution(input varchar(4096), len int)
   returns int
   language plpgsql
  as
$$
declare 
-- variable declaration
buffer char(14);
dups int;
begin
 -- logic
FOR i IN len.. length(input)
LOOP
  buffer = substr(input, i-len+1, len);
  dups := 0;
  FOR j IN 1.. len
  LOOP
	dups := dups+length(buffer)-length(replace(buffer, substr(buffer,j,1),''))-1;
  END LOOP;
  if dups = 0 then
	return i;
  end if;
END LOOP;
return 42;
end;
$$

;
select solution(value,4) from day06.inputs;
select solution(value,14) from day06.inputs;


