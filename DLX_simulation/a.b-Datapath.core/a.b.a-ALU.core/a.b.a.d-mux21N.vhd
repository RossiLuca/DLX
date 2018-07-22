library ieee;
use ieee.std_logic_1164.all;
use work.global.all;

entity mux21N is
  generic (N : integer := Nbit);                  -- Number of bit
  port (
    		in1 : in  std_logic_vector(n-1 downto 0);
			in0 : in  std_logic_vector(n-1 downto 0);
			S : in  std_logic;
    		U : out std_logic_vector(n-1 downto 0));

end mux21N;


architecture structure of mux21N is

component MUX21
  Port (	in1:	In	std_logic; --in1 when s=1
			in0:	In	std_logic; --in0 when s=0
			S:	In	std_logic;
			Y:	Out	std_logic);
end component;

begin  -- structure

  G1: for i in 0 to n-1 generate
		muxes : MUX21 port map ( in1(i), in0(i) ,S ,U(i));
  end generate;
  

end structure;
