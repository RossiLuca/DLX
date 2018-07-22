library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.global.all;
use work.functions.all;

entity DataMemory is
	generic (Nbit: integer:= Nbit;
		 DATA_MEM_SIZE: integer:= DATA_MEM_SIZE);
	port (
		DataIn 	: in std_logic_vector ((Nbit-1) downto 0);
		Addr	: in std_logic_vector ((DATA_MEM_SIZE-1) downto 0);
		En	: in std_logic;
		Clk	: in std_logic;
		Rst	: in std_logic;
		Read_Wrn: in std_logic;
		Word	: in std_logic;
		HalfWord: in std_logic;
		Byte	: in std_logic;
		Unsign	: in std_logic;
		DataOut	: out std_logic_vector ((Nbit-1) downto 0));
end DataMemory;

architecture Behavior of DataMemory is

type memory is array ( 0 to 2**(DATA_MEM_SIZE)-1) of std_logic_vector(7 downto 0);
signal Data: memory;

	begin


MemProc:process (DataIn,Addr,Clk,Rst,Read_Wrn,Word,HalfWord,Byte,Unsign,En)
	begin
	if (Rst = '1') then
			DataOut <= (others => '0');
			Data <= (others =>( others => '0'));
	else	
		if (En = '1') then
			if (Read_Wrn = '1') then -- read from memory
				if (Byte = '1') then
					DataOut(7 downto 0) <= Data(to_integer(unsigned(Addr)));
					if (Unsign = '1') then
						DataOut(Nbit-1 downto 8) <= (others => '0');
					else
					    DataOut(Nbit-1 downto 8) <= (others =>(Data(to_integer(unsigned(Addr)))(7)));
					end if;
				end if;
				if (HalfWord = '1') then
					DataOut(15 downto 8) <= Data(to_integer(unsigned(Addr)));
					DataOut(7 downto 0) <= Data(to_integer(unsigned(Addr)+1));
					if (Unsign = '1') then
						DataOut(Nbit-1 downto 16) <= (others => '0');
					else
						DataOut(Nbit-1 downto 16) <= (others =>(Data(to_integer(unsigned(Addr)+1))(7)));
					end if;
				end if;
				if (Word = '1') then
					DataOut((Nbit-1) downto 24)<= Data(to_integer(unsigned(Addr)));
					DataOut(23 downto 16)<= Data(to_integer(unsigned(Addr)+1));
					DataOut(15 downto 8) <= Data(to_integer(unsigned(Addr)+2));
					DataOut(7 downto 0) <= Data(to_integer(unsigned(Addr)+3));
				end if;
			end if;
		end if;
		if (Clk'EVENT and Clk='1') then
		    if (En = '1') then
			 if (Read_Wrn = '0') then -- write in memory
				if (Byte = '1') then
					Data(to_integer(unsigned(Addr)))<= DataIn(7 downto 0);
				end if;
				if (HalfWord = '1') then
					Data(to_integer(unsigned(Addr)))<= DataIn(15 downto 8);
					Data(to_integer(unsigned(Addr)+1))<= DataIn(7 downto 0);
				end if;
				if (Word = '1') then
					Data(to_integer(unsigned(Addr)))<= DataIn((Nbit-1) downto 24);
					Data(to_integer(unsigned(Addr)+1))<= DataIn(23 downto 16);
					Data(to_integer(unsigned(Addr)+2))<= DataIn(15 downto 8);
					Data(to_integer(unsigned(Addr)+3))<= DataIn(7 downto 0);
				end if;
				end if;
			end if;
		end if;
	end if;			
	end process MemProc;

end Behavior;
