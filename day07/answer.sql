-- Put everything in a schema so its easy to reset. This also makes
-- this automatically reset so we can just run it many times.
DROP SCHEMA IF EXISTS day07 CASCADE;
CREATE SCHEMA day07;

CREATE TABLE day07.inputs (
  id    SERIAL,
  value varchar(42)
);

CREATE TABLE day07.files (
	id SERIAL,
	name varchar(42),
	size int,
	cwd varchar[]
);	
-- Use \COPY rather than COPY so its client-side in psql
\COPY day07.inputs (value) FROM 'day07/input.txt' WITH (FORMAT 'text');

do $$ 
declare
  op varchar ;
  cwd varchar[] ;
  cd_to varchar := '';
begin
   FOR op IN
   select 
   value from day07.inputs where id > 1 order by id
   LOOP
	CASE split_part(op, ' ', 1)
		when '$' then	
			if op like '$ cd%' then
				cd_to := split_part(op, ' ', 3);
				if cd_to = '..' then
					cwd := array_remove(cwd, cwd[array_length(cwd, 1)]);
				else 
					cwd := array_append(cwd, cd_to);
				end if;
			end if;
		when 'dir' then
		else 
			INSERT INTO day07.files (name, size, cwd) values (split_part(op, ' ', 2), split_part(op, ' ', 1)::int, cwd);
	end case;
	raise notice 'cwd is %', cwd;
   END LOOP;
end $$;

--select sum(total_size) from (
with cte as (select distinct unnest(cwd) dir from day07.files)
select sum(size) total_size, dir from day07.files, cte where cte.dir = ANY(cwd) group by dir having sum(size) < 100000;
--) as subq ;

