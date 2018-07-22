LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY PGblock IS 
PORT (	
		A :	IN std_logic;
		B :	IN std_logic;
		G :	OUT std_logic;
		P :	OUT std_logic);
END PGblock;

ARCHITECTURE Behavior OF PGblock IS
BEGIN
	
	P <= A xor B;
	G <= A and B;

END Behavior;

