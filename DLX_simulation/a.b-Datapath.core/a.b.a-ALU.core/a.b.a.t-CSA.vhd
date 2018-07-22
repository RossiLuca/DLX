library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.global.all;

entity CSA is 
generic(N:integer:= Nbit);         
port(                     
    	A       : in  std_logic_vector(N-1 downto 0); 
		B		: in  std_logic_vector(N-1 downto 0); 
    	C   	: in  std_logic_vector(N-1 downto 0); 
    	sum_out : out std_logic_vector(N-1 downto 0); 
    	cout    : out std_logic_vector(N-1 downto 0)); 
end CSA;

architecture struct of CSA is
signal ov: std_logic_vector(Nbit downto 0);

component fa is 
Port (		
		A:	In	std_logic;
		B:	In	std_logic;
		Ci:	In	std_logic;
		S:	Out	std_logic;
		Co:	Out	std_logic);
end component fa;
  
begin 
	ov(0) <= '0';
	
	stage0: for I in 0 to N-1 generate
			st0: fa port map(A(I), B(I), C(I) , sum_out(I), ov(I+1));
			end generate stage0;

	cout <= ov(N-1 downto 0);

end  struct;
