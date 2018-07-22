LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE WORK.functions.all;

ENTITY SparseTreeCarryGenNBM IS
GENERIC (Nbit: integer:=16 );
PORT ( 
		A : 	IN std_logic_vector (Nbit-1 downto 0);
		B :	IN std_logic_vector (Nbit-1 downto 0);
		Cin : IN std_logic;
		Cout :	OUT std_logic_vector ((Nbit/4) downto 0));
END SparseTreeCarryGenNBM;

ARCHITECTURE Struct OF SparseTreeCarryGenNBM IS

TYPE SignalVector IS ARRAY (log2_N(Nbit) DOWNTO 0) OF std_logic_vector(1 to Nbit);
SIGNAL prop : SignalVector;
SIGNAL gen : SignalVector;


COMPONENT G IS
PORT (
		G1: 	IN std_logic;
		P1: 	IN std_logic;
		G2: 	IN std_logic;
		Gout: 	OUT std_logic);
END COMPONENT;

COMPONENT PG IS
PORT (
		G1: 	IN std_logic;
		P1: 	IN std_logic;
		G2: 	IN std_logic;
		P2: 	IN std_logic;
		Gout:	OUT std_logic;
		Pout: 	OUT std_logic);
END COMPONENT;

COMPONENT PGblock IS 
PORT (	
		A :	IN std_logic;
		B :	IN std_logic;
		G :	OUT std_logic;
		P :	OUT std_logic);
END COMPONENT;

BEGIN
	
rowgen:	FOR row IN 0 TO log2_N(Nbit) GENERATE
	row0: 	IF row=0 GENERATE
		el0: FOR I IN 1 TO Nbit GENERATE 
			PGB: PGblock PORT MAP ( A(i-1), B(i-1), gen(row)(i), prop(row)(i));
		END GENERATE;	
	END GENERATE;
		
	row1_2: IF row < 3 and row /= 0 GENERATE
		row1_2:FOR I IN 1 TO Nbit/2**row GENERATE
			G_12: IF I=1 GENERATE
				G1_2: G PORT MAP (gen(row-1)(2**(row)),prop(row-1)(2**(row)),gen(row-1)(2**(row)-row),gen(row)(2**row));
			END GENERATE;
			PG_12: IF I>1 GENERATE
				PG1_2: PG PORT MAP (gen(row-1)(i*2**row),prop(row-1)(i*2**row),gen(row-1)(i*2**(row)-2**(row-1)),prop(row-1)(i*2**(row)-2**(row-1)),gen(row)(i*2**row),prop(row)(i*2**row));
			END GENERATE;
		END GENERATE;
	END GENERATE;
		
	row3: IF row = 3 GENERATE
		el3:FOR I IN 1 TO Nbit/4 GENERATE
			W_3: 	IF (I mod 2)=1 GENERATE
					gen(row)(i*2**(row-1)) <= gen(row-1)(i*2**(row-1));
					prop(row)(i*2**(row-1)) <= prop(row-1)(i*2**(row-1));
				END GENERATE;
			G_3:	IF (I=2) GENERATE
					G3: G PORT MAP (gen(row-1)(i*2**(row-1)),prop(row-1)(i*2**(row-1)),gen(row-1)(i*2**(row-1)-2**(row-1)),gen(row)(i*2**(row-1)));
				END GENERATE;
			PG_3:	IF (((I mod 2)=0) and (I > 2)) GENERATE
				PG3: PG PORT MAP (gen(row-1)(i*2**(row-1)),prop(row-1)(i*2**(row-1)),gen(row-1)(i*2**(row-1)-2**(row-1)),prop(row-1)(i*2**(row-1)-2**(row-1)),gen(row)(i*2**(row-1)),prop(row)(i*2**(row-1)));
				END GENERATE;
		END GENERATE;
	END GENERATE;
		
	row3e: IF row > 3 GENERATE
		el3_e:FOR I IN 0 TO Nbit/4-1 GENERATE
			W_3e:	IF ((I rem (2**(row-2)))<((2**(row-2))/2)) GENERATE
					gen(row)((i+1)*4) <= gen(row-1)((i+1)*4);
					prop(row)((i+1)*4) <= prop(row-1)((i+1)*4);
				END GENERATE;
				
			G_3e:	IF (((I rem (2**(row-2)))>=((2**(row-2))/2)) and (I < 2**(row-2))) GENERATE
					G3_E: G PORT MAP (gen(row-1)((i+1)*4),prop(row-1)((i+1)*4),gen(row-1)((i+1)*4-((i+1)-2**(row-3))*4),gen(row)((i+1)*4));
				END GENERATE;
				
			PG_3e:	IF (((I rem (2**(row-2)))>=((2**(row-2))/2)) and (I > 2**(row-2))) GENERATE
					PG3_E: PG PORT MAP (gen(row-1)((i+1)*4),prop(row-1)((i+1)*4),gen(row-1)((i+1)*4-((i+1)-2**(row-3)-(4*(i/(2**(row-2)))*(2**(row-4))))*4),prop(row-1)((i+1)*4-((i+1)-2**(row-3)-(4*(i/(2**(row-2)))*(2**(row-4))))*4),gen(row)((i+1)*4),prop(row)((i+1)*4));
				END GENERATE;
		     END GENERATE;
	       END GENERATE;
END GENERATE;

outgen:	FOR I IN 0 TO Nbit GENERATE
	Cout_0:	IF i=0 GENERATE
			Cout(0) <= Cin;
		END GENERATE;
	Cout_ot:IF (((i mod 4)=0) and (i /= 0)) GENERATE
			Cout(i/4) <= gen(log2_N(Nbit))(i);
		END GENERATE;
END GENERATE;

END Struct;
			
