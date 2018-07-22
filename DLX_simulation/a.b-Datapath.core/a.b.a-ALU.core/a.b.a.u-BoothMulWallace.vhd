library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.global.all;

entity BoothMulWallace is
	generic (Nbit : integer := Nbit );
  	port(        
			a   : in  std_logic_vector(Nbit/2-1 downto 0);
			b	: in  std_logic_vector(Nbit/2-1 downto 0);
    		p	: out std_logic_vector(Nbit-1 downto 0));
end BoothMulWallace;

architecture struct of BoothMulWallace is

signal zero : std_logic_vector(Nbit-1 downto 0) := (others => '0');

subtype ADDR is natural range 0 to Nbit/2-1; -- using natural type
subtype ADDR1 is natural range 0 to 4; -- using natural type
subtype ADDR2 is natural range 0 to 2;
subtype ADDR3 is natural range 0 to 1;

type init0 is array(ADDR) of std_logic_vector(Nbit-1 downto 0);
type first_o is array(ADDR1) of std_logic_vector(Nbit-1 downto 0);
type first_co is array(ADDR1) of std_logic_vector(Nbit-1 downto 0);
type second_o is array(ADDR2) of std_logic_vector(Nbit-1 downto 0);
type second_co is array(ADDR2) of std_logic_vector(Nbit-1 downto 0);
type third_o is array(ADDR3) of std_logic_vector(Nbit-1 downto 0);
type third_co is array(ADDR3) of std_logic_vector(Nbit-1 downto 0);
type fourth_o is array(ADDR3) of std_logic_vector(Nbit-1 downto 0);
type fourth_co is array(ADDR3) of std_logic_vector(Nbit-1 downto 0);
signal init: init0:=(others=>(others => '0')); 
signal first_out : first_o;
signal first_cout : first_co;
signal second_out : second_o;
signal second_cout : second_co;
signal third_out : third_o;
signal third_cout : third_co;
signal fourth_out : fourth_o;
signal fourth_cout : fourth_co;
signal fifth_out: std_logic_vector(Nbit-1 downto 0);
signal fifth_cout: std_logic_vector(Nbit-1 downto 0);
signal sixth_out: std_logic_vector(Nbit-1 downto 0);--to RCA
signal sixth_cout: std_logic_vector(Nbit-1 downto 0);
signal a_i, b_i: std_logic_vector(Nbit/2-1 downto 0);

component CSA is
generic(N:integer:=Nbit);          
 port(                     
		A		: in  std_logic_vector(Nbit-1 downto 0); 
		B		: in  std_logic_vector(Nbit-1 downto 0); 
		C		: in  std_logic_vector(Nbit-1 downto 0); 
		sum_out : out std_logic_vector(Nbit-1 downto 0); 
		cout    : out std_logic_vector(Nbit-1 downto 0)); 
end component;

component P4adderN is
generic (Nbit : integer := Nbit );
port	( 	
			A :		in std_logic_vector (Nbit-1 downto 0);
			B :		in std_logic_vector (Nbit-1 downto 0);
			Cin : 	in std_logic;
			S :		out std_logic_vector (Nbit-1 downto 0);
			Cout:	out std_logic);
end component;

begin

	process(a, b, a_i, b_i)
	begin
		if((a(Nbit/2-1) = '1') and (b(Nbit/2-1) = '1')) then
			a_i <= std_logic_vector(unsigned(not(a)) + 1);
			b_i <= std_logic_vector(unsigned(not(b)) + 1);
		else
			if(b(Nbit/2-1) = '1' and (a(Nbit/2-1) = '0')) then
				a_i <= b;
				b_i <= a;
			else
				a_i <= a;
				b_i <= b;
			end if;
		end if;
		for I in 0 to Nbit/2-1 loop
			if(b_i(I)='1') then
				init(I)(Nbit/2-1+I downto I) <= a_i;
				if(a_i(Nbit/2-1) = '1') then
					init(I)(Nbit-1 downto Nbit/2+I) <= (others=>'1');
				else
					init(I)(Nbit-1 downto Nbit/2+I) <= (others=>'0');
				end if;
			else
				init(I) <= zero;
			end if;
		end loop; 
	end process;

	CSA0: CSA port map(init(0), init(1), init(2) , first_out(0), first_cout(0));
	CSA1: CSA port map(init(3), init(4), init(5) , first_out(1), first_cout(1));
	CSA2: CSA port map(init(6), init(7), init(8) , first_out(2), first_cout(2));
	CSA3: CSA port map(init(9), init(10), init(11) , first_out(3), first_cout(3));
	CSA4: CSA port map(init(12), init(13), init(14) , first_out(4), first_cout(4));
	CSA5: CSA port map(first_out(0), first_cout(0), first_out(1) , second_out(0), second_cout(0));
	CSA6: CSA port map(first_cout(1), first_out(2), first_cout(2) , second_out(1), second_cout(1));
	CSA7: CSA port map(first_out(3), first_cout(3), first_out(4) , second_out(2), second_cout(2));
	CSA8: CSA port map(second_out(0), second_cout(0), second_out(1), third_out(0), third_cout(0));
	CSA9: CSA port map(second_cout(1), second_out(2), second_cout(2), third_out(1), third_cout(1));
	CSA10: CSA port map(third_out(0), third_cout(0), third_out(1), fourth_out(0), fourth_cout(0));
	CSA11: CSA port map(third_cout(1), first_cout(4), init(15), fourth_out(1), fourth_cout(1));
	CSA12: CSA port map(fourth_out(0), fourth_cout(0), fourth_out(1), fifth_out, fifth_cout);
	CSA13: CSA port map(fifth_out, fifth_cout, fourth_cout(1), sixth_out, sixth_cout);
	P4A14: P4adderN port map(sixth_out, sixth_cout, '0', p, open);
	
end struct;
