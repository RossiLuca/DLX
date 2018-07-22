LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY PG IS
PORT (
		G1: 	IN std_logic;
		P1: 	IN std_logic;
		G2: 	IN std_logic;
		P2: 	IN std_logic;
		Gout:	OUT std_logic;
		Pout: 	OUT std_logic);
END PG;

ARCHITECTURE behavior OF PG IS

BEGIN

	Gout <= G1 or (P1 and G2);
	Pout <= P1 and P2;

END behavior;
