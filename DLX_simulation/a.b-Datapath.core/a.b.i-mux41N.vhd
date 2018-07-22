library ieee;
use ieee.std_logic_1164.all;
use work.global.all;
use work.functions.all;

entity mux41N is
generic ( Nbit:	integer:=Nbit);
port (
		in3: in std_logic_vector ((Nbit-1) downto 0);
		in2: in std_logic_vector ((Nbit-1) downto 0);
		in1: in std_logic_vector ((Nbit-1) downto 0);
		in0: in std_logic_vector ((Nbit-1) downto 0);
		sel: in std_logic_vector (1 downto 0);
		Y: out std_logic_vector ((Nbit-1) downto 0));
end mux41N;

architecture structure of mux41N is

	type signalmatrix is array (2 downto 1) of std_logic_vector ((Nbit-1) downto 0);
	signal outmux: signalmatrix;


component mux21N is
generic (N : integer := Nbit);                  -- Number of bit
port (
    	in1 : in  std_logic_vector(N-1 downto 0);
   		in0 : in  std_logic_vector(N-1 downto 0);
   		S : in  std_logic;
    	U : out std_logic_vector(N-1 downto 0));

end component;

begin
	
row1_1:		mux21N port map (in1,in0,sel(0),outmux(1));
row1_2:		mux21N port map (in3,in2,sel(0),outmux(2));

row2_1:		mux21N port map (outmux(2),outmux(1),sel(1),Y);

end structure;
