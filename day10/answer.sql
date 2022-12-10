-- Put everything in a schema so its easy to reset. This also makes
-- this automatically reset so we can just run it many times.
DROP SCHEMA IF EXISTS day10 CASCADE;
CREATE SCHEMA day10;

CREATE TABLE day10.inputs (
  id    SERIAL,
  value varchar(42)
);

-- Use \COPY rather than COPY so its client-side in psql
\COPY day10.inputs (value) FROM 'day10/input.txt' WITH (FORMAT 'text');

do $$ 
declare
  x INTEGER := 1;
  i INTEGER := 1;
  op integer ;
  result integer := 0;
begin
   FOR op IN
   select 
   nullif(split_part(value, ' ', 2),'')::int op from day10.inputs order by id
   LOOP
    -- FOR i in 1..num_moves LOOP
	-- raise notice 'at cycle % x is %', i, x;
	if mod(i-20, 40) = 0  then
		raise notice 'at cycle % the signal strength is %', i, x*i;
		result := result+(x*i);
	end if;
	i := i+1;
	if op is not null then
		if mod(i-20, 40) = 0 then
			raise notice 'at cycle % the signal strength is %', i, x*i;
			result := result+(x*i);
		end if;
		i := i+1;
		x := x+op;
	end if;
    -- END LOOP;
   END LOOP;
   raise notice 'finishing with result %', result;
end $$;


do $$ 
declare
  x INTEGER := 1;
  i INTEGER := 1;
  op integer ;
  screen varchar(240) := '';
begin
   FOR op IN
   select 
   nullif(split_part(value, ' ', 2),'')::int op from day10.inputs order by id
   LOOP
    -- FOR i in 1..num_moves LOOP
	raise notice 'at column %, x is %', mod(i, 40), x;
	if mod(i-1, 40) between x-1 and x+1  then
		raise notice 'drawing pixel at %', i;
		screen := screen || '#';
	else
		screen := screen || '.';
	end if;
	i := i+1;
	if op is not null then
		if mod(i-1, 40) between x-1 and x+1  then
			raise notice 'drawing pixel at %', i;
			screen := screen || '#';
		else
			screen := screen || '.';
		end if;
		i := i+1;
		x := x+op;
	end if;
    -- END LOOP;
   END LOOP;
   for y in 1..240 by 40
	LOOP
   		raise notice 'output: %', substr(screen, y, 39);
	END LOOP;
end $$;
