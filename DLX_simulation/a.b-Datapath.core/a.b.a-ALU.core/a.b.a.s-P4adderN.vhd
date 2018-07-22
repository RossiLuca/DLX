LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY P4adderN IS
GENERIC (Nbit : 	integer := 32 );
PORT	( 	
		A :		IN std_logic_vector (Nbit-1 DOWNTO 0);
		B :		IN std_logic_vector (Nbit-1 DOWNTO 0);
		Cin :	IN std_logic;
		S :		OUT std_logic_vector (Nbit-1 DOWNTO 0);
		Cout:	OUT std_logic);
END P4adderN;

ARCHITECTURE StructureN OF P4adderN IS

SIGNAL Carry : std_logic_vector ((Nbit/4) DOWNTO 0); 

COMPONENT SparseTreeCarryGenNBM IS
GENERIC (Nbit: integer:=16 );
PORT ( 		
		A : 	IN std_logic_vector (Nbit-1 DOWNTO 0);
		B :		IN std_logic_vector (Nbit-1 DOWNTO 0);
		Cin : 	IN std_logic;
		Cout :	OUT std_logic_vector ((Nbit/4) DOWNTO 0));
END COMPONENT;

COMPONENT CarrySumNBM IS 
GENERIC (Nbit  :	integer := 4);
PORT (	
		A:	IN	std_logic_vector(Nbit-1 DOWNTO 0);
		B:	IN	std_logic_vector(Nbit-1 DOWNTO 0);
		Ci:	IN	std_logic_vector(Nbit/4-1 DOWNTO 0);
		S:	OUT	std_logic_vector(Nbit-1 DOWNTO 0));
END COMPONENT;

BEGIN

STCG: 	SparseTreeCarryGenNBM
		GENERIC MAP (Nbit => Nbit)
		PORT MAP (A, B, Cin, Carry);

CSN:	CarrySumNBM
		GENERIC MAP (Nbit => Nbit)
		PORT MAP (A, B, Carry(Nbit/4-1 DOWNTO 0), S);

Cout <= Carry (Nbit/4);

END StructureN;
