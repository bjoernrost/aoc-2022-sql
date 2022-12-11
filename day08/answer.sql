-- Put everything in a schema so its easy to reset. This also makes
-- this automatically reset so we can just run it many times.
DROP SCHEMA IF EXISTS day08 CASCADE;
CREATE SCHEMA day08;

CREATE TABLE day08.inputs (
  id    SERIAL,
  value varchar(250)
);

-- Use \COPY rather than COPY so its client-side in psql
\COPY day08.inputs (value) FROM 'day08/input.txt' WITH (FORMAT 'text');

do $$ 
declare
  row int;
  line varchar ;
  forest int[][];
  results int[][];
  tree_cols int;
  tree_rows int;
  max_height int;
  visible_trees int := 0;
begin
   SELECT max(length(value)) INTO tree_cols from day08.inputs;
   SELECT count(42) INTO tree_rows from day08.inputs;
   forest := array_fill(42, array[tree_cols,tree_rows]);
   results := array_fill(0, array[tree_cols,tree_rows]);
   FOR row, line IN
   select 
   id, value from day08.inputs order by id
   LOOP
	--raise notice 'line is %', line;
	-- initialize array with forest line by line
	for i in 1.. tree_cols LOOP
		raise notice 'tree is % tall', substr(line, i, 1)::int;
		forest[i][row] := substr(line, i, 1)::int;
	END LOOP;
   END LOOP;
   -- check rows from left to right
   for y in 1.. tree_rows LOOP
   	max_height := -1;
   	for x in 1.. tree_cols LOOP
		if forest[x][y] > max_height THEN
			max_height := forest[x][y];
			results[x][y] := 1;	
		END if;
	END LOOP;
   END LOOP;
   -- check rows from right to left
   for y in 1.. tree_rows LOOP
   	max_height := -1;
   	for x in reverse tree_cols.. 1 LOOP
		if forest[x][y] > max_height THEN
			max_height := forest[x][y];
			results[x][y] := 1;	
		END if;
	END LOOP;
   END LOOP;
   -- check cols from top to bottom
   for x in 1.. tree_cols LOOP
   	max_height := -1;
   	for y in 1.. tree_rows LOOP
		if forest[x][y] > max_height THEN
			max_height := forest[x][y];
			results[x][y] := 1;	
		END if;
	END LOOP;
   END LOOP;
   -- check cols from borrom to top
   for x in 1.. tree_cols LOOP
   	max_height := -1;
   	for y in reverse tree_rows.. 1 LOOP
		if forest[x][y] > max_height THEN
			max_height := forest[x][y];
			results[x][y] := 1;	
		END if;
		if results[x][y] = 1 THEN 
			visible_trees := visible_trees+1;
		END if;
	END LOOP;
   END LOOP;
   -- raise notice '%', results;
   --raise notice '%', forest;
   raise notice 'there are % visible trees', visible_trees;
end $$;
