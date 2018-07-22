library ieee;
use ieee.std_logic_1164.all;
use work.global.all;

entity signExtension is 
	generic (	Nbitin: integer:= 16;
				Nbitout: integer:= Nbit);
	port (		
				A		: in std_logic_vector((Nbitin-1) downto 0);	
				Aextended	: out std_logic_vector((Nbitout-1) downto 0));
end signExtension;

architecture Structure of signExtension is

begin	

		Aextended (Nbitin-1 downto 0) <= A;
		Aextended (Nbitout-1 downto Nbitin) <=(others =>(A(Nbitin-1)));
		
end Structure;
