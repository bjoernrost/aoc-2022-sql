-- i don't think i will import and parse this data
-- and populate my program manually instead

do $$ 
declare
  num_items int :=36;
  item bigint;
  m int;
  monkey bigint[8][36];
  inspections int[8]; 
  divisor int := 3;
  rounds int := 20;
begin
   monkey := array_fill(0, array[8,num_items]);
   monkey[1][1] := 63;
   monkey[1][2] := 57;
   monkey[2][3] := 82;
   monkey[2][4] := 66;
   monkey[2][5] := 87;
   monkey[2][6] := 78;
   monkey[2][7] := 77;
   monkey[2][8] := 92;
   monkey[2][9] := 83;
   monkey[3][10] := 97;
   monkey[3][11] := 53;
   monkey[3][12] := 53;
   monkey[3][13] := 85;
   monkey[3][14] := 58;
   monkey[3][15] := 54;
   monkey[4][16] := 50;
   monkey[5][17] := 64;
   monkey[5][18] := 69;
   monkey[5][19] := 52;
   monkey[5][20] := 65;
   monkey[5][21] := 73;
   monkey[6][22] := 57;
   monkey[6][23] := 91;
   monkey[6][24] := 65;
   monkey[7][25] := 67;
   monkey[7][26] := 91;
   monkey[7][27] := 84;
   monkey[7][28] := 78;
   monkey[7][29] := 60;
   monkey[7][30] := 69;
   monkey[7][31] := 99;
   monkey[7][32] := 83;
   monkey[8][33] := 58;
   monkey[8][34] := 78;
   monkey[8][35] := 69;
   monkey[8][36] := 65;
   raise notice 'monkey %', monkey;
   inspections := array_fill(0, array[8]);
for x in 1.. rounds 
LOOP
   -- processing monkey 1
   m := 1;
   for i in 1.. num_items 
   LOOP
	item := monkey[m][i];
	if item > 0 THEN
		item := item*11;
		item := floor(item/divisor);
		if mod(item,7) = 0 THEN
			monkey[m][i] := 0;
			monkey[7][i] := item;
		else
			monkey[m][i] := 0;
			monkey[3][i] := item;
		end if;
	inspections[m] := inspections[m]+1;
	end if;
    end loop;
   -- processing monkey 2
   m := 2;
   for i in 1.. num_items 
   LOOP
	item := monkey[m][i];
	if item > 0 THEN
		item := item+1;
		item := floor(item/divisor);
		if mod(item,11) = 0 THEN
			monkey[m][i] := 0;
			monkey[6][i] := item;
		else
			monkey[m][i] := 0;
			monkey[1][i] := item;
		end if;
	inspections[m] := inspections[m]+1;
	end if;
    end loop;
   -- processing monkey 3
   m := 3;
   for i in 1.. num_items 
   LOOP
	item := monkey[m][i];
	if item > 0 THEN
		item := item*7;
		item := floor(item/divisor);
		if mod(item,13) = 0 THEN
			monkey[m][i] := 0;
			monkey[5][i] := item;
		else
			monkey[m][i] := 0;
			monkey[4][i] := item;
		end if;
	inspections[m] := inspections[m]+1;
	end if;
    end loop;
   -- processing monkey 4
   m := 4;
   for i in 1.. num_items 
   LOOP
	item := monkey[m][i];
	if item > 0 THEN
		item := item+3;
		item := floor(item/divisor);
		if mod(item,3) = 0 THEN
			monkey[m][i] := 0;
			monkey[2][i] := item;
		else
			monkey[m][i] := 0;
			monkey[8][i] := item;
		end if;
	inspections[m] := inspections[m]+1;
	end if;
    end loop;
   -- processing monkey 5
   m := 5;
   for i in 1.. num_items 
   LOOP
	item := monkey[m][i];
	if item > 0 THEN
		item := item+6;
		item := floor(item/divisor);
		if mod(item,17) = 0 THEN
			monkey[m][i] := 0;
			monkey[4][i] := item;
		else
			monkey[m][i] := 0;
			monkey[8][i] := item;
		end if;
	inspections[m] := inspections[m]+1;
	end if;
    end loop;
   -- processing monkey 6
   m := 6;
   for i in 1.. num_items 
   LOOP
	item := monkey[m][i];
	if item > 0 THEN
		item := item+5;
		item := floor(item/divisor);
		if mod(item,2) = 0 THEN
			monkey[m][i] := 0;
			monkey[1][i] := item;
		else
			monkey[m][i] := 0;
			monkey[7][i] := item;
		end if;
	inspections[m] := inspections[m]+1;
	end if;
    end loop;
   -- processing monkey 7
   m := 7;
   for i in 1.. num_items 
   LOOP
	item := monkey[m][i];
	if item > 0 THEN
		item := item*item;
		item := floor(item/divisor);
		if mod(item,5) = 0 THEN
			monkey[m][i] := 0;
			monkey[3][i] := item;
		else
			monkey[m][i] := 0;
			monkey[5][i] := item;
		end if;
	inspections[m] := inspections[m]+1;
	end if;
    end loop;
   -- processing monkey 8
   m := 8;
   for i in 1.. num_items 
   LOOP
	item := monkey[m][i];
	if item > 0 THEN
		item := item+7;
		item := floor(item/divisor);
		if mod(item,19) = 0 THEN
			monkey[m][i] := 0;
			monkey[6][i] := item;
		else
			monkey[m][i] := 0;
			monkey[2][i] := item;
		end if;
	inspections[m] := inspections[m]+1;
	end if;
    end loop;
end loop;
   raise notice 'monkey %', monkey;
   CREATE EXTENSION IF NOT EXISTS intarray;
   raise notice 'inspections %', inspections;
   inspections := sort(inspections);
   raise notice 'monkey business is %', (inspections[8]*inspections[7]);
end $$;
