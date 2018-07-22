library IEEE;
use IEEE.std_logic_1164.all;
use work.global.all;

entity RegEn is
	Generic (Nbit : integer := Nbit);
	Port (
			A: 	in std_logic_vector (Nbit-1 downto 0);
			Clk: 	in std_logic;
			Reset: 	in std_logic;
			EN:	in std_logic;
			U : 	out std_logic_vector (Nbit-1 downto 0));
end RegEn;


architecture Structure of RegEn is

component FD_EN is
	Port (	
			D:	In	std_logic;
			Clk:	In	std_logic;
			RESET:	In	std_logic;
			EN:	In	std_logic;
			Q:	Out	std_logic);
end component;

begin

	G1: for i in 0 to Nbit-1 generate
		FDS: FD_EN port map ( A(i), Clk, Reset, EN, U(i));
	end generate;

end Structure;

