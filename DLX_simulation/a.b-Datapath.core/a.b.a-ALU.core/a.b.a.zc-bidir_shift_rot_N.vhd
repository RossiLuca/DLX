LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_signed.all;
USE work.global.all;
USE work.functions.all;

ENTITY bidir_shift_rot_N IS
generic (
	Nbit: integer := Nbit); 
PORT (
	data_in		:	IN STD_LOGIC_VECTOR(Nbit-1 downto 0);
	sel			:	IN STD_LOGIC_VECTOR(log2_N(Nbit)-1 downto 0);
	shift		:	IN STD_LOGIC_VECTOR(Nbit-1 downto 0);
	dx			:	IN STD_LOGIC;
	arith_logN	:	IN STD_LOGIC;
	data_out	: 	OUT STD_LOGIC_VECTOR(Nbit-1 downto 0));
END bidir_shift_rot_N;

	-- data_in			:	00000
	-- right_rot1	:	00001
	-- right_rot2	:	00010
	-- right_rot3	:	00011
	-- right_rot4	:	00100
	-- right_rot5	:	00101
	-- right_rot6	: 	00110
	-- right_rot7	: 	00111
	-- right_rot8	:	01000
	-- right_rot9	:	01001
	-- right_rot10	:	01010
	-- right_rot11	:	01011
	-- right_rot12	:	01100
	-- right_rot13	: 	01101
	-- right_rot14	: 	01110
	-- right_rot15	: 	01111
	-- right_rot16	: 	10000
	-- right_rot1	:	10001
	-- right_rot2	:	10010
	-- right_rot3	:	10011
	-- right_rot4	:	10100
	-- right_rot5	:	10101
	-- right_rot6	: 	10110
	-- right_rot7	: 	10111
	-- right_rot8	:	11000
	-- right_rot9	:	11001
	-- right_rot10	:	11010
	-- right_rot11	:	11011
	-- right_rot12	:	11100
	-- right_rot13	: 	11101
	-- right_rot14	: 	11110
	-- right_rot15	: 	11111
	
ARCHITECTURE struct OF bidir_shift_rot_N IS
  
COMPONENT Mux2to1 IS
	PORT (	x1	: IN STD_LOGIC;
			x2	: IN STD_LOGIC;
			s 	: IN STD_LOGIC;
			f 	: OUT STD_LOGIC);
END COMPONENT;  
  
COMPONENT mux32to1 IS
	PORT (	A0, A1, A2, A3, A4, A5, A6, A7			: IN	STD_LOGIC;
			A8, A9, A10, A11, A12, A13, A14, A15	: IN	STD_LOGIC;
			A16, A17, A18, A19, A20, A21, A22, A23	: IN	STD_LOGIC;
			A24, A25, A26, A27, A28, A29, A30, A31	: IN	STD_LOGIC;
			s	: IN	STD_LOGIC_VECTOR(5-1 downto 0);
			F	: OUT	STD_LOGIC);
END COMPONENT;

SIGNAL muxout: STD_LOGIC_VECTOR(Nbit-1 downto 0);
SIGNAL dffout_t: STD_LOGIC_VECTOR(2*Nbit-1 downto 0);
SIGNAL dffout_tt: STD_LOGIC_VECTOR(2*Nbit-1 downto 0);
SIGNAL U: STD_LOGIC_VECTOR(Nbit-1 downto 0);
SIGNAL data: STD_LOGIC;

BEGIN

	stages: FOR I IN Nbit/2 TO Nbit+Nbit/2-1 GENERATE
		
		muxes: mux32to1 PORT MAP (data_in(I-Nbit/2), dffout_tt(I+1), dffout_tt(I+2), dffout_tt(I+3), dffout_tt(I+4), dffout_tt(I+5),
									dffout_tt(I+6), dffout_tt(I+7), dffout_tt(I+8), dffout_tt(I+9), dffout_tt(I+10),
									dffout_tt(I+11), dffout_tt(I+12), dffout_tt(I+13), dffout_tt(I+14), dffout_tt(I+15),
									dffout_tt(I+16), dffout_tt(I-15), dffout_tt(I-14), dffout_tt(I-13), dffout_tt(I-12),
									dffout_tt(I-11), dffout_tt(I-10), dffout_tt(I-9), dffout_tt(I-8), dffout_tt(I-7),
									dffout_tt(I-6), dffout_tt(I-5), dffout_tt(I-4), dffout_tt(I-3), dffout_tt(I-2),
									dffout_tt(I-1), sel, muxout(I-Nbit/2));
		data <= data_in(Nbit-1) and dx and arith_logN;
		mpxs: Mux2to1 PORT MAP (muxout(I-Nbit/2), data, shift(I-Nbit/2), U(I-Nbit/2));
		dffout_t(I) <= data_in(I-Nbit/2);
	END GENERATE;
	dffout_tt(2*Nbit-1 downto Nbit+Nbit/2) <= dffout_t(Nbit-1 downto Nbit/2);
	dffout_tt(Nbit/2-1 downto 0) <= dffout_t(Nbit+Nbit/2-1 downto Nbit);
	dffout_tt(Nbit+Nbit/2-1 downto Nbit/2) <= dffout_t(Nbit+Nbit/2-1 downto Nbit/2);

	data_out <= U;
  
END struct;
