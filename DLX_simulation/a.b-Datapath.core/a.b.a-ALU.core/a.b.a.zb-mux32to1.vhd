LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE work.functions.all;

ENTITY mux32to1 IS
	PORT (	
			A0, A1, A2, A3, A4, A5, A6, A7			: IN	STD_LOGIC;
			A8, A9, A10, A11, A12, A13, A14, A15	: IN	STD_LOGIC;
			A16, A17, A18, A19, A20, A21, A22, A23	: IN	STD_LOGIC;
			A24, A25, A26, A27, A28, A29, A30, A31	: IN	STD_LOGIC;
			s	: IN	STD_LOGIC_VECTOR(5-1 downto 0);
			F	: OUT	STD_LOGIC);
END mux32to1;

ARCHITECTURE Structure OF mux32to1 IS

COMPONENT Mux2to1
	PORT (	
			x1	: IN STD_LOGIC;
			x2	: IN STD_LOGIC;
			s	: IN STD_LOGIC;
			f	: OUT STD_LOGIC);
END COMPONENT;


SIGNAL U: std_logic_vector(32-1-2 downto 0);

BEGIN
		Mux1: Mux2to1 PORT MAP (A0, A1, s(0), U(0));
		Mux2: Mux2to1 PORT MAP (A2, A3, s(0), U(1));
		Mux3: Mux2to1 PORT MAP (A4, A5, s(0), U(2));
		Mux4: Mux2to1 PORT MAP (A6, A7, s(0), U(3));
		Mux5: Mux2to1 PORT MAP (A8, A9, s(0), U(4));
		Mux6: Mux2to1 PORT MAP (A10, A11, s(0), U(5));
		Mux7: Mux2to1 PORT MAP (A12, A13, s(0), U(6));
		Mux8: Mux2to1 PORT MAP (A14, A15, s(0), U(7));
		Mux9: Mux2to1 PORT MAP (A16, A17, s(0), U(8));
		Mux10: Mux2to1 PORT MAP (A18, A19, s(0), U(9));
		Mux11: Mux2to1 PORT MAP (A20, A21, s(0), U(10));
		Mux12: Mux2to1 PORT MAP (A22, A23, s(0), U(11));
		Mux13: Mux2to1 PORT MAP (A24, A25, s(0), U(12));
		Mux14: Mux2to1 PORT MAP (A26, A27, s(0), U(13));
		Mux15: Mux2to1 PORT MAP (A28, A29, s(0), U(14));
		Mux16: Mux2to1 PORT MAP (A30, A31, s(0), U(15));
		Mux17: Mux2to1 PORT MAP (U(0), U(1), s(1), U(16));
		Mux18: Mux2to1 PORT MAP (U(2), U(3), s(1), U(17));
		Mux19: Mux2to1 PORT MAP (U(4), U(5), s(1), U(18));
		Mux20: Mux2to1 PORT MAP (U(6), U(7), s(1), U(19));
		Mux21: Mux2to1 PORT MAP (U(8), U(9), s(1), U(20));
		Mux22: Mux2to1 PORT MAP (U(10), U(11), s(1), U(21));
		Mux23: Mux2to1 PORT MAP (U(12), U(13), s(1), U(22));
		Mux24: Mux2to1 PORT MAP (U(14), U(15), s(1), U(23));
		Mux25: Mux2to1 PORT MAP (U(16), U(17), s(2), U(24));
		Mux26: Mux2to1 PORT MAP (U(18), U(19), s(2), U(25));
		Mux27: Mux2to1 PORT MAP (U(20), U(21), s(2), U(26));
		Mux28: Mux2to1 PORT MAP (U(22), U(23), s(2), U(27));
		Mux29: Mux2to1 PORT MAP (U(24), U(25), s(3), U(28));
		Mux30: Mux2to1 PORT MAP (U(26), U(27), s(3), U(29));
		Mux31: Mux2to1 PORT MAP (U(28), U(29), s(4), F);
END Structure;
