library ieee;
use ieee.std_logic_1164.all;
use work.global.all;

entity zerotest is
	generic (Nbit: integer:=Nbit);
	port (	A: in std_logic_vector((Nbit-1) downto 0);
		zero: out std_logic);
end zerotest;

architecture Structure of zerotest is

signal Temp: std_logic_vector ((Nbit-1) downto 0);

begin
		Temp(0) <= A (0);
Temp_g:		for i in 1 to (Nbit-1) generate
			Temp(i) <= Temp(i-1) or A(i);
		end generate;
		zero <= not Temp(Nbit-1);
end Structure;
