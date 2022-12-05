-- Put everything in a schema so its easy to reset. This also makes
-- this automatically reset so we can just run it many times.
DROP SCHEMA IF EXISTS day05 CASCADE;
CREATE SCHEMA day05;

CREATE TABLE day05.crates (
  id    int,
  stack varchar(100)
);

CREATE TABLE day05.inputs (
  id    SERIAL,
  value varchar(42)
);

-- i am cheating a bit with hardcoding the inputs...
insert into day05.crates values (1, 'SPWNJZ');
insert into day05.crates values (2, 'TSG');
insert into day05.crates values (3, 'HLRQV');
insert into day05.crates values (4, 'DTSV');
insert into day05.crates values (5, 'JMBDTZQ');
insert into day05.crates values (6, 'LZCDJTWM');
insert into day05.crates values (7, 'JTGWMPL');
insert into day05.crates values (8, 'HQFBTMGN');
insert into day05.crates values (9, 'WQBPCGDR');

-- Use \COPY rather than COPY so its client-side in psql
\COPY day05.inputs (value) FROM 'day05/input.txt' WITH (FORMAT 'text');

do $$ 
declare
  i INTEGER;
  num_moves integer ;
  move_from integer;
  move_to integer;
  crane char(1);
begin
   FOR num_moves, move_from, move_to IN
   select 
   split_part(value, ' ', 2)::int num_moves, split_part(value, ' ', 4)::int move_from, split_part(value, ' ', 6)::int move_to from day05.inputs where value like 'move%' order by id
   LOOP
     FOR i in 1..num_moves LOOP
	-- read value from stack to crane
        crane := '';
        SELECT INTO crane substr(stack, 1, 1) from day05.crates where id = move_from;
        --	raise notice 'read % from stack %', crane, move_from;
	-- delete crate from stack
        UPDATE day05.crates set stack = right(stack, -1) where id = move_from;
	-- put crate on new stack
        UPDATE day05.crates set stack = crane || stack where id = move_to;
     END LOOP;
   END LOOP;
end $$;

select left(stack, 1) from day05.crates order by id;

-- reset the crates
DELETE FROM day05.crates;
insert into day05.crates values (1, 'SPWNJZ');
insert into day05.crates values (2, 'TSG');
insert into day05.crates values (3, 'HLRQV');
insert into day05.crates values (4, 'DTSV');
insert into day05.crates values (5, 'JMBDTZQ');
insert into day05.crates values (6, 'LZCDJTWM');
insert into day05.crates values (7, 'JTGWMPL');
insert into day05.crates values (8, 'HQFBTMGN');
insert into day05.crates values (9, 'WQBPCGDR');


do $$ 
declare
  i INTEGER;
  num_moves integer ;
  move_from integer;
  move_to integer;
  crane char(42);
begin
   FOR num_moves, move_from, move_to IN
   select 
   split_part(value, ' ', 2)::int num_moves, split_part(value, ' ', 4)::int move_from, split_part(value, ' ', 6)::int move_to from day05.inputs where value like 'move%' order by id
   LOOP
	-- read value from stack to crane
        SELECT INTO crane substr(stack, 1, num_moves) from day05.crates where id = move_from;
        --raise notice 'read % from stack %', crane, move_from;
	-- delete crate from stack
        UPDATE day05.crates set stack = right(stack, (-1 * num_moves)) where id = move_from;
	-- put crate on new stack
        UPDATE day05.crates set stack = crane || stack where id = move_to;
   END LOOP;
end $$;

select left(stack, 1) from day05.crates order by id;


