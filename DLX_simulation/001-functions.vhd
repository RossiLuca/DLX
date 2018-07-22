LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

PACKAGE functions IS
	FUNCTION log2_N (x : NATURAL) RETURN NATURAL;
	FUNCTION reminder (w, z: INTEGER) RETURN integer;
END;

PACKAGE BODY functions IS
	FUNCTION log2_N (x : NATURAL) RETURN NATURAL IS
		VARIABLE count: NATURAL := 0;
		VARIABLE n : NATURAL := 1;
	BEGIN
		WHILE n < x LOOP
			n := n*2;
			count := count+1;
		END LOOP;
	RETURN count;
	END FUNCTION;
	
	FUNCTION reminder (w, z: INTEGER) RETURN INTEGER IS
		VARIABLE result: INTEGER := 0;
		VARIABLE rest: INTEGER := 0;
	BEGIN
		WHILE ((result<w) AND (w-result >= z)) LOOP
			result := result+z;
		END LOOP;
		rest := w - result;
	RETURN rest;
	END FUNCTION;
END PACKAGE BODY;
