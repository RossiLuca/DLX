LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE WORK.global.all;

ENTITY AddSubN IS
GENERIC (Nbit : 	integer := Nbit);
PORT	( 	
			A :			IN std_logic_vector (Nbit-1 DOWNTO 0);
			B :			IN std_logic_vector (Nbit-1 DOWNTO 0);
			addnsub :	IN std_logic;
			S :			OUT std_logic_vector (Nbit-1 DOWNTO 0);
			Cout:		OUT std_logic);
END AddSubN;

ARCHITECTURE Structure OF AddSubN IS

SIGNAL Carry : std_logic_vector ((Nbit/4) DOWNTO 0);
SIGNAL addendB: std_logic_vector ((Nbit -1) DOWNTO 0); 

COMPONENT SparseTreeCarryGenN IS
GENERIC (Nbit: integer:=16 );
PORT ( 
			A : 	IN std_logic_vector (Nbit-1 DOWNTO 0);
			B :		IN std_logic_vector (Nbit-1 DOWNTO 0);
			Cin : 	IN std_logic;
			Cout :	OUT std_logic_vector ((Nbit/4) DOWNTO 0));
END COMPONENT;

COMPONENT CarrySumN IS 
GENERIC (Nbit  :	integer := 4);
PORT (		
			A:	IN	std_logic_vector(Nbit-1 DOWNTO 0);
			B:	IN	std_logic_vector(Nbit-1 DOWNTO 0);
			Ci:	IN	std_logic_vector(Nbit/4-1 DOWNTO 0);
			S:	OUT	std_logic_vector(Nbit-1 DOWNTO 0));
END COMPONENT;

BEGIN
	
addsub:	FOR i IN 0 TO (Nbit-1) GENERATE
			addendB(i) <= B(i) XOR addnsub;
		END GENERATE;

STCG: 	SparseTreeCarryGenN
		GENERIC MAP (Nbit => Nbit)
		PORT MAP (A, addendB, addnsub, Carry);

CSN:	CarrySumN
		GENERIC MAP (Nbit => Nbit)
		PORT MAP (A, addendB, Carry(Nbit/4-1 DOWNTO 0), S);

Cout <= Carry (Nbit/4);

END Structure;
