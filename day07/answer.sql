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
	cwd varchar
);	
-- Use \COPY rather than COPY so its client-side in psql
\COPY day07.inputs (value) FROM 'day07/input.txt' WITH (FORMAT 'text');

do $$ 
declare
  op varchar ;
  cwd varchar[] ;
  cd_to varchar := '';
  subdir varchar;
begin
   FOR op IN
   select 
   value from day07.inputs where id > 0 order by id
   LOOP
	CASE split_part(op, ' ', 1)
		when '$' then	
			if op like '$ cd%' then
				cd_to := split_part(op, ' ', 3);
				if cd_to = '..' then
					if array_length(cwd, 1) > 1 THEN
						cwd := array_remove(cwd, cwd[array_length(cwd, 1)]);
					end if;
				else 
					cwd := array_append(cwd, cd_to);
				end if;
			end if;
		when 'dir' then
		else 
			subdir := '/';
			-- insert one row for each subdir
			for i in 1.. array_length(cwd, 1)
			LOOP
				subdir := subdir || cwd[i] || '/';
				INSERT INTO day07.files (name, size, cwd) values (split_part(op, ' ', 2), split_part(op, ' ', 1)::int, subdir);
			END LOOP;
	end case;
	raise notice 'cwd is %', cwd;
   END LOOP;
end $$;

select sum(total_size) from (
select cwd, sum(size) total_size from day07.files group by cwd having sum(size) < 100000
) as subq ;


-- got stuck here for now as none of the subdir sizes are the right answer
with needed_space as (
	SELECT 30000000-70000000-SUM(size) FROM day07.files WHERE cwd = '///'
)
select * from needed_space;
select cwd, sum(size) from day07.files group by cwd order by sum(size) desc;
