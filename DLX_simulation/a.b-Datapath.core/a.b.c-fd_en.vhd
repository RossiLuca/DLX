library IEEE;
use IEEE.std_logic_1164.all; 

entity FD_EN is
	Port (	D:	In	std_logic;
		Clk:	In	std_logic;
		RESET:	In	std_logic;
		EN:	In	std_logic;
		Q:	Out	std_logic);
end FD_EN;


architecture Behavior of FD_EN is -- flip flop D with syncronous reset and enable

begin

PSYNCH: process(Clk,RESET,EN)
			begin
				if Clk'event and Clk='1' then -- positive edge triggered:
					if RESET='1' then -- active high reset 
						Q <= '0'; 
					else
						if EN='1' then  -- input is written on output
							Q <= D;
						end if;
					end if;
				end if;
		end process;

end Behavior;

