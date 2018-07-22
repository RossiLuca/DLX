library ieee;
use ieee.std_logic_1164.all;
use work.global.all;
use work.functions.all;

entity mux81 is
port (
		in7: in std_logic;
		in6: in std_logic;
		in5: in std_logic;
		in4: in std_logic;
		in3: in std_logic;
		in2: in std_logic;
		in1: in std_logic;
		in0: in std_logic;
		sel: in std_logic_vector (2 downto 0);
		Y: out std_logic);
end mux81;

architecture structure of mux81 is

	type signalmatrix is array (6 downto 1) of std_logic;
	signal outmux: signalmatrix;
	signal outmux2: signalmatrix;

component MUX21 is
port (
    	in1 : in  std_logic;
   		in0 : in  std_logic;
   		S : in  std_logic;
    	Y : out std_logic);
end component;

begin
	
row1_1:		MUX21 port map (in1,in0,sel(0),outmux(1));
row1_2:		MUX21 port map (in3,in2,sel(0),outmux(2));
row1_3:		MUX21 port map (in5,in4,sel(0),outmux(3));
row1_4:		MUX21 port map (in7,in6,sel(0),outmux(4));

row2_1:		MUX21 port map (outmux(2),outmux(1),sel(1),outmux2(1));
row2_2:		MUX21 port map (outmux(4),outmux(3),sel(1),outmux2(2));

row3_1:		MUX21 port map (outmux2(2),outmux2(1),sel(2),Y);

end structure;
