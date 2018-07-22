LIBRARY IEEE;
USE ieee.std_logic_1164.all; 
USE ieee.std_logic_unsigned.all;


ENTITY CarrySumN IS 
GENERIC (Nbit  :	integer := 4);
PORT (	
		A:	IN	std_logic_vector(Nbit-1 DOWNTO 0);
		B:	IN	std_logic_vector(Nbit-1 DOWNTO 0);
		Ci:	IN	std_logic_vector(Nbit/4-1 DOWNTO 0);
		S:	OUT	std_logic_vector(Nbit-1 DOWNTO 0));
END CarrySumN;

ARCHITECTURE STRUCTURAL OF CarrySumN IS

signal Cprop : std_logic_vector(Nbit/4 DOWNTO 1);
signal CarryOut : std_logic_vector (Nbit/4-1 DOWNTO 0);

COMPONENT CSBlockN
GENERIC (Nbit :	integer := 4);
PORT (	
		A:	IN	std_logic_vector(Nbit-1 DOWNTO 0);
		B:	IN	std_logic_vector(Nbit-1 DOWNTO 0);
	 	Ci:	IN	std_logic;
	 	S:	OUT	std_logic_vector(Nbit-1 DOWNTO 0);
		Cout:	OUT	std_logic);
END COMPONENT;

BEGIN
  CarrySumN1: for I in 0 to Nbit/4-1 GENERATE
	CSN : CSBlockN 
		GENERIC MAP (Nbit => 4) 
		PORT MAP (A((((I+1)*4)-1) DOWNTO I*4), B((((I+1)*4)-1) DOWNTO I*4), Ci(I), S((((I+1)*4)-1) DOWNTO I*4), Carryout(I)); 
  END GENERATE;

END STRUCTURAL;
