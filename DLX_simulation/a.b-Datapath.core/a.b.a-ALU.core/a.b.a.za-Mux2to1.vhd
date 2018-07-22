LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY Mux2to1 IS
PORT (	
		x1	: IN STD_LOGIC;
		x2	: IN STD_LOGIC;
		s 	: IN STD_LOGIC;
		f 	: OUT STD_LOGIC);
END Mux2to1;

ARCHITECTURE Behavior OF Mux2to1 IS

BEGIN
	f <= (NOT (s) AND x1) OR (s AND x2);
END Behavior;