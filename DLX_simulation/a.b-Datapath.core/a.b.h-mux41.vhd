library ieee;
use ieee.std_logic_1164.all;
use work.global.all;
use work.functions.all;

entity mux41 is
port (
		in3: in std_logic;
		in2: in std_logic;
		in1: in std_logic;
		in0: in std_logic;
		sel: in std_logic_vector(1 downto 0);
		Y: out std_logic);
end mux41;

architecture structure of mux41 is

	type signalmatrix is array (2 downto 1) of std_logic;
	signal outmux: signalmatrix;


component MUX21 is                
Port (	
		in1:	In	std_logic; --in1 when s=1
		in0:	In	std_logic; --in0 when s=0
		S:	In	std_logic;
		Y:	Out	std_logic);
end component;

begin
	

row1_1:		MUX21 port map (in1,in0,sel(0),outmux(1));
row1_2:		MUX21 port map (in3,in2,sel(0),outmux(2));

row2_1:		MUX21 port map (outmux(2),outmux(1),sel(1),Y);

end structure;
