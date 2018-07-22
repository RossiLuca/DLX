library ieee;
use ieee.std_logic_1164.all;
use work.global.all;

entity LogicFun_v2 is
generic (Nbit :integer := Nbit);
port (
		A: in	std_logic_vector((Nbit-1) downto 0);
		B: in	std_logic_vector((Nbit-1) downto 0);
		notA: out std_logic_vector((Nbit-1) downto 0);
		notB: out std_logic_vector((Nbit-1) downto 0);
		AandB: out std_logic_vector((Nbit-1) downto 0);
		AorB: out std_logic_vector((Nbit-1) downto 0);
		AxorB: out std_logic_vector((Nbit-1) downto 0);
		AnandB: out std_logic_vector((Nbit-1) downto 0);
		AnorB: out std_logic_vector((Nbit-1) downto 0);
		AxnorB: out std_logic_vector((Nbit-1) downto 0));
end LogicFun_v2;

architecture Structure of LogicFun_v2 is

begin

notAf:		for i in 0 to (Nbit-1) generate
			notA(i) <= not A(i);
			end generate;

notBf:		for i in 0 to (Nbit-1) generate
			notB(i) <= not B(i);
			end generate;

AandBf:		for i in 0 to (Nbit-1) generate
			AandB(i) <= A(i) and B(i);
			end generate;

Aorf:		for i in 0 to (Nbit-1) generate
			AorB(i) <= A(i) or B(i);
			end generate;

AxorBf:		for i in 0 to (Nbit-1) generate
			AxorB(i) <= A(i) xor B(i);
			end generate;

AnandBf:	for i in 0 to (Nbit-1) generate
			AnandB(i) <= A(i) nand B(i);
			end generate;

AnorBf:		for i in 0 to (Nbit-1) generate
			AnorB(i) <= A(i) nor B(i);
			end generate;

AxnorBf:	for i in 0 to (Nbit-1) generate
			AxnorB(i) <= A(i) xnor B(i);
			end generate;


end Structure;
