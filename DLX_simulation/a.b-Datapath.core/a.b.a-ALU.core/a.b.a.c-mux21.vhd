library IEEE;
use IEEE.std_logic_1164.all; --  libreria IEEE con definizione tipi standard logic

entity MUX21 is
	Port (	in1:	In	std_logic; --in1 when s=1
		in0:	In	std_logic; --in0 when s=0
		S:	In	std_logic;
		Y:	Out	std_logic);
end MUX21;

architecture STRUCTURAL of MUX21 is

begin

mux:	process (in1,in0,S)
			begin
				if (S ='1') then
					Y <= in1;
				else
					Y <= in0;
				end if;
		end process mux;

end STRUCTURAL;
