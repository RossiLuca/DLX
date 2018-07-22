library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;
use work.global.all;
use work.functions.all;

ENTITY bidir_shift_rot_N_interface IS
generic (
	Nbit: integer := Nbit); 
PORT (
	data_in		:	IN STD_LOGIC_VECTOR(Nbit-1 downto 0);
	moves		:	IN STD_LOGIC_VECTOR(log2_N(Nbit)-1 downto 0);
	tot		:	IN STD_LOGIC;
	shift_rotN	:	IN STD_LOGIC;
	right_leftN	:	IN STD_LOGIC;
	arith_logN	:	IN STD_LOGIC;
	data_out	: 	OUT STD_LOGIC_VECTOR(Nbit-1 downto 0));
END bidir_shift_rot_N_interface;

ARCHITECTURE struct OF bidir_shift_rot_N_interface IS
  
COMPONENT bidir_shift_rot_N IS
	generic (
	Nbit: integer := Nbit); 
PORT (
	data_in		:	IN STD_LOGIC_VECTOR(Nbit-1 downto 0);
	sel			:	IN STD_LOGIC_VECTOR(log2_N(Nbit)-1 downto 0);
	shift		:	IN STD_LOGIC_VECTOR(Nbit-1 downto 0);
	dx			:	IN STD_LOGIC;
	arith_logN	:	IN STD_LOGIC;
	data_out	: 	OUT STD_LOGIC_VECTOR(Nbit-1 downto 0));
END COMPONENT;

signal move : integer range 0 to 16;
signal move0 : integer range 0 to 31;
signal selt	: std_logic_vector(log2_N(Nbit)-1 downto 0);
signal shiftt	: std_logic_vector(Nbit-1 downto 0);
signal r_l	: std_logic;

BEGIN

move0 <= to_integer(unsigned(moves));

	process(data_in, shift_rotN, right_leftN, move0)
	begin
		if(right_leftN = '1') then
			if(move0 > 16) then
				move <= 32-move0;
				r_l <= '0';
			else
				move <= move0;
				r_l <= '1';
			end if;
		end if;
		if(right_leftN = '0') then
			if(move0>15) then
				move <= 32-move0;
				r_l <= '1';
			else
				move <= move0;
				r_l <= '0';
			end if;
		end if;
	end process;
	
	process(move, r_l)
	begin
		if(r_l = '1') then
			case move is
				when 0 => selt <= "00000";
			 	when 1 => selt <= "00001";
				when 2 => selt <= "00010";
				when 3 => selt <= "00011";
				when 4 => selt <= "00100";
				when 5 => selt <= "00101";
				when 6 => selt <= "00110";
				when 7 => selt <= "00111";
				when 8 => selt <= "01000";
				when 9 => selt <= "01001";
				when 10 => selt <= "01010";
				when 11 => selt <= "01011";
				when 12 => selt <= "01100";
				when 13 => selt <= "01101";
				when 14 => selt <= "01110";
				when 15 => selt <= "01111";
				when 16 => selt <= "10000";
			end case;
		end if;
		if(r_l = '0') then
			case move is
			 	when 0 => selt <= "00000";
				when 1 => selt <= "11111";
				when 2 => selt <= "11110";
				when 3 => selt <= "11101";
				when 4 => selt <= "11100";
				when 5 => selt <= "11011";
				when 6 => selt <= "11010";
				when 7 => selt <= "11001";
				when 8 => selt <= "11000";
				when 9 => selt <= "10111";
				when 10 => selt <= "10110";
				when 11 => selt <= "10101";
				when 12 => selt <= "10100";
				when 13 => selt <= "10011";
				when 14 => selt <= "10010";
				when 15 => selt <= "10001";
				when 16 => selt <= "10000";
			end case;
		end if;
	end process;

	process (move, shift_rotN, right_leftN, tot)
	begin
		if (shift_rotN = '1') then
			if (right_leftN = '1') then
				case move0 is
					when 0 => shiftt <= "00000000000000000000000000000000";
					when 1 => shiftt <= "10000000000000000000000000000000";
					when 2 => shiftt <= "11000000000000000000000000000000";
					when 3 => shiftt <= "11100000000000000000000000000000";
					when 4 => shiftt <= "11110000000000000000000000000000";
					when 5 => shiftt <= "11111000000000000000000000000000";
					when 6 => shiftt <= "11111100000000000000000000000000";
					when 7 => shiftt <= "11111110000000000000000000000000";
					when 8 => shiftt <= "11111111000000000000000000000000";
					when 9 => shiftt <= "11111111100000000000000000000000";
					when 10 => shiftt <= "11111111110000000000000000000000";
					when 11 => shiftt <= "11111111111000000000000000000000";
					when 12 => shiftt <= "11111111111100000000000000000000";
					when 13 => shiftt <= "11111111111110000000000000000000";
					when 14 => shiftt <= "11111111111111000000000000000000";
					when 15 => shiftt <= "11111111111111100000000000000000";
					when 16 => shiftt <= "11111111111111110000000000000000";
					when 17 => shiftt <= "11111111111111111000000000000000";
					when 18 => shiftt <= "11111111111111111100000000000000";
					when 19 => shiftt <= "11111111111111111110000000000000";
					when 20 => shiftt <= "11111111111111111111000000000000";
					when 21 => shiftt <= "11111111111111111111100000000000";
					when 22 => shiftt <= "11111111111111111111110000000000";
					when 23 => shiftt <= "11111111111111111111111000000000";
					when 24 => shiftt <= "11111111111111111111111100000000";
					when 25 => shiftt <= "11111111111111111111111110000000";
					when 26 => shiftt <= "11111111111111111111111111000000";
					when 27 => shiftt <= "11111111111111111111111111100000";
					when 28 => shiftt <= "11111111111111111111111111110000";
					when 29 => shiftt <= "11111111111111111111111111111000";
					when 30 => shiftt <= "11111111111111111111111111111100";
					when 31 => shiftt <= "11111111111111111111111111111110";
				end case;				 
			end if;
			
			if (right_leftN='0') then
				case move0 is
					when 0 => shiftt <= "00000000000000000000000000000000";
					when 1 => shiftt <= "00000000000000000000000000000001";
					when 2 => shiftt <= "00000000000000000000000000000011";
					when 3 => shiftt <= "00000000000000000000000000000111";
					when 4 => shiftt <= "00000000000000000000000000001111";
					when 5 => shiftt <= "00000000000000000000000000011111";
					when 6 => shiftt <= "00000000000000000000000000111111";
					when 7 => shiftt <= "00000000000000000000000001111111";
					when 8 => shiftt <= "00000000000000000000000011111111";
					when 9 => shiftt <= "00000000000000000000000111111111";
					when 10 => shiftt <= "00000000000000000000001111111111";
					when 11 => shiftt <= "00000000000000000000011111111111";
					when 12 => shiftt <= "00000000000000000000111111111111";
					when 13 => shiftt <= "00000000000000000001111111111111";
					when 14 => shiftt <= "00000000000000000011111111111111";
					when 15 => shiftt <= "00000000000000000111111111111111";
					when 16 => shiftt <= "00000000000000001111111111111111";
					when 17 => shiftt <= "00000000000000011111111111111111";
					when 18 => shiftt <= "00000000000000111111111111111111";
					when 19 => shiftt <= "00000000000001111111111111111111";
					when 20 => shiftt <= "00000000000011111111111111111111";
					when 21 => shiftt <= "00000000000111111111111111111111";
					when 22 => shiftt <= "00000000001111111111111111111111";
					when 23 => shiftt <= "00000000011111111111111111111111";
					when 24 => shiftt <= "00000000111111111111111111111111";
					when 25 => shiftt <= "00000001111111111111111111111111";
					when 26 => shiftt <= "00000011111111111111111111111111";
					when 27 => shiftt <= "00000111111111111111111111111111";
					when 28 => shiftt <= "00001111111111111111111111111111";
					when 29 => shiftt <= "00011111111111111111111111111111";
					when 30 => shiftt <= "00111111111111111111111111111111";
					when 31 => shiftt <= "01111111111111111111111111111111";
			 	end case;
			end if;
			if (tot ='1' and shift_rotN = '1') then
				shiftt <= (others => '1');
			end if;
		else
			shiftt <= "00000000000000000000000000000000";	
		end if;
	end process;
	
	bidir1: bidir_shift_rot_N PORT MAP (data_in, selt, shiftt, right_leftN, arith_logN, data_out);
	
END struct;
