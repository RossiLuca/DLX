LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY CSBlockN is
GENERIC	(Nbit: integer := 4 );
PORT (
		A	: 	IN std_logic_vector(Nbit-1 downto 0);
		B	: 	IN std_logic_vector(Nbit-1 downto 0);
		Ci	:	IN std_logic;
		S	: 	OUT std_logic_vector(Nbit-1 downto 0);
		Cout:   OUT std_logic);
END CSBlockN;

ARCHITECTURE structure OF CSBlockN IS

SIGNAL sum_cin0 :std_logic_vector(Nbit downto 0);
SIGNAL sum_cin1 :std_logic_vector(Nbit downto 0);
SIGNAL sum	:std_logic_vector(Nbit downto 0);

COMPONENT RCAN IS 
GENERIC (Nbit: integer := 4);
PORT (	
		A:	IN	std_logic_vector(Nbit-1 downto 0);
		B:	IN	std_logic_vector(Nbit-1 downto 0);
		Ci:	IN	std_logic;
		S:	OUT	std_logic_vector(Nbit-1 downto 0);
		Co:	OUT	std_logic);
END COMPONENT;

COMPONENT mux21N is
GENERIC (N : integer := 6);
PORT (
    	in1 : IN  std_logic_vector(N-1 downto 0);
    	in0 : IN  std_logic_vector(N-1 downto 0);
    	S 	: IN  std_logic;
    	U :   OUT std_logic_vector(N-1 downto 0));
END COMPONENT;

BEGIN

	RCA_Cin_0 : RCAN
	GENERIC MAP (Nbit)
	PORT MAP (A,B,'0',sum_cin0(Nbit-1 downto 0),sum_cin0(Nbit));

	RCA_Cin_1 : RCAN
	GENERIC MAP (Nbit)
	PORT MAP (A,B,'1',sum_cin1(Nbit-1 downto 0),sum_cin1(Nbit));

	MUX : mux21N
	GENERIC MAP (Nbit+1)
	PORT MAP (sum_cin1,sum_cin0,Ci,sum);

	Cout <= sum(Nbit);
	S <= sum(Nbit-1 downto 0);
	

END structure;

 
		


		
