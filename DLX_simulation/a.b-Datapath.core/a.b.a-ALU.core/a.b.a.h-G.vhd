LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY G IS
PORT (
		G1: 	IN std_logic;
		P1: 	IN std_logic;
		G2: 	IN std_logic;
		Gout: 	OUT std_logic);
END G;

ARCHITECTURE behavior OF G IS

BEGIN

	Gout <= G1 or (P1 and G2);
	
END behavior;
	
