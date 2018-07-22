library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.global.all;
use work.functions.all;

entity PC is
	generic (RAM_DEPTH: integer := RAM_DEPTH);
	port(
			PC_In	: in std_logic_vector ((RAM_DEPTH+1) downto 0);
			En	: in std_logic;
			Clk	: in std_logic;
			Res	: in std_logic;
			PC_DATAP: out std_logic_vector ((RAM_DEPTH+1) downto 0);
			PC_IRAM	: out std_logic_vector ((RAM_DEPTH-1) downto 0));
end PC;

architecture Behavior of PC is

begin
	
PCProc:		process (Clk,Res,PC_In,En)
			begin
				if (Res = '1') then
					PC_DATAP <= (others => '0');
					PC_IRAM <= (others => '0');
				elsif (Clk'EVENT and Clk = '1') then
					PC_DATAP <= std_logic_vector(unsigned(PC_In));
					PC_IRAM <= std_logic_vector(unsigned(PC_In((RAM_DEPTH+1) downto 2)));
				end if;
			end process PCProc;
			
end Behavior;
