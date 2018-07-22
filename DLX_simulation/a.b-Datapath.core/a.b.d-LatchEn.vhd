library IEEE;
use IEEE.std_logic_1164.all;
use work.global.all;

entity LatchEn is
 
	Generic (Nbit : integer := Nbit);
	Port (
			A: 	in std_logic_vector (Nbit-1 downto 0);
			Clk: 	in std_logic;
			Reset: 	in std_logic;
			EN:	in std_logic;
			U : 	out std_logic_vector (Nbit-1 downto 0));
end LatchEn;


architecture Behavior of LatchEn is

begin
	
LATCH:	process (EN,Clk,Reset,A)
		begin
			if (Reset='1') then
				U <= (others => '0');
			else
				if (Clk='1') then
					if (EN='1') then
						U <= A;
					end if;
				end if;
			end if;
		end process LATCH;

end Behavior;

