library ieee;
use ieee.std_logic_1164.all;
use work.global.all;
use work.functions.all;

entity tb_DLX is
end tb_DLX;

architecture TEST of tb_DLX is

signal Clk_i: std_logic;
signal Rst_i: std_logic;

component DLX is
	port(
		Clk : in std_logic;
		Rst : in std_logic);
end component;

begin
	
DUT:	DLX port map (Clk_i,Rst_i);


ClkProc: 	process
		begin
			Clk_i <= '1';
			wait for 1.5 ns;
			Clk_i <= '0';
			wait for 1.5 ns;

		end process ClkProc;

			Rst_i <= '1', '0' after  2 ns;
end TEST;
