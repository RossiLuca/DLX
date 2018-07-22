library ieee;
use ieee.std_logic_1164.all;
use work.functions.all;


entity Comp is
generic ( Nbit: integer:= 32);
port (
		signA	: in std_logic;
		signB	: in std_logic;
		Diff	: in std_logic_vector ((Nbit-1) downto 0);
		Carry	: in std_logic;
		unsign	: in std_logic;
		AgB		: out std_logic;
		AeqB	: out std_logic;
		AnoteqB : out std_logic;
		AlB		: out std_logic;
		AgeqB	: out std_logic;
		AleqB	: out std_logic);
end Comp;

architecture structure of Comp is

	signal Z: std_logic;
	signal Temp: std_logic_vector ((Nbit-1) downto 0);
	signal sign_cntrl: std_logic;
	
begin
		Temp(0) <= Diff (0);
		
Temp_g:	for i in 1 to (Nbit-1) generate
			Temp(i) <= Temp(i-1) or Diff(i);
		end generate;
		
		Z <= not Temp(Nbit-1);
		sign_cntrl <= (signA xor signB) and (not unsign); 
		AgB <= (Carry and ( not Z))xor sign_cntrl;
		AgeqB <= Carry xor sign_cntrl;
		AlB <= (not Carry) xor sign_cntrl;
		AleqB <= ((not Carry) or (Z)) xor sign_cntrl;
		AeqB <=  Z;
		AnoteqB <= not Z;
		
end structure;
