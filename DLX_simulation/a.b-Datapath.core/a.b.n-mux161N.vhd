library ieee;
use ieee.std_logic_1164.all;
use work.global.all;
use work.functions.all;

entity mux161N is
generic ( Nbit:	integer:=Nbit);
port (
		in15: in std_logic_vector ((Nbit-1) downto 0);
		in14: in std_logic_vector ((Nbit-1) downto 0);
		in13: in std_logic_vector ((Nbit-1) downto 0);
		in12: in std_logic_vector ((Nbit-1) downto 0);
		in11: in std_logic_vector ((Nbit-1) downto 0);
		in10: in std_logic_vector ((Nbit-1) downto 0);
		in9: in std_logic_vector ((Nbit-1) downto 0);
		in8: in std_logic_vector ((Nbit-1) downto 0);
		in7: in std_logic_vector ((Nbit-1) downto 0);
		in6: in std_logic_vector ((Nbit-1) downto 0);
		in5: in std_logic_vector ((Nbit-1) downto 0);
		in4: in std_logic_vector ((Nbit-1) downto 0);
		in3: in std_logic_vector ((Nbit-1) downto 0);
		in2: in std_logic_vector ((Nbit-1) downto 0);
		in1: in std_logic_vector ((Nbit-1) downto 0);
		in0: in std_logic_vector ((Nbit-1) downto 0);
		sel: in std_logic_vector (3 downto 0);
		Y: 	out std_logic_vector ((Nbit-1) downto 0));
end mux161N;

architecture structure of mux161N is

	type signalmatrix is array (8 downto 1) of std_logic_vector ((Nbit-1) downto 0);
	signal outmux: signalmatrix;
	signal outmux2: signalmatrix;
	signal outmux3: signalmatrix;


component mux21N is
generic (N : integer := Nbit);                  -- Number of bit
port (
    	in1 : in  std_logic_vector(N-1 downto 0);
   		in0 : in  std_logic_vector(N-1 downto 0);
   		S : in  std_logic;
    	U : out std_logic_vector(N-1 downto 0));
end component;

	begin
	

row1_1:		mux21N port map (in1,in0,sel(0),outmux(1));
row1_2:		mux21N port map (in3,in2,sel(0),outmux(2));
row1_3:		mux21N port map (in5,in4,sel(0),outmux(3));
row1_4:		mux21N port map (in7,in6,sel(0),outmux(4));
row1_5:		mux21N port map (in9,in8,sel(0),outmux(5));
row1_6:		mux21N port map (in11,in10,sel(0),outmux(6));
row1_7:		mux21N port map (in13,in12,sel(0),outmux(7));
row1_8:		mux21N port map (in15,in14,sel(0),outmux(8));

row2_1:		mux21N port map (outmux(2),outmux(1),sel(1),outmux2(1));
row2_2:		mux21N port map (outmux(4),outmux(3),sel(1),outmux2(2));
row2_3:		mux21N port map (outmux(6),outmux(5),sel(1),outmux2(3));
row2_4:		mux21N port map (outmux(8),outmux(7),sel(1),outmux2(4));

row3_1:		mux21N port map (outmux2(2),outmux2(1),sel(2),outmux3(1));
row3_2:		mux21N port map (outmux2(4),outmux2(3),sel(2),outmux3(2));

row4_1:		mux21N port map (outmux3(2),outmux3(1),sel(3),Y);

end structure;
			


