library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;
use work.global.all;
use work.functions.all;

entity register_file is
generic (
	Nbit: integer := Nbit);
port ( 
	CLK: 		IN std_logic;
    	RESET:	 	IN std_logic;
	ENABLE: 	IN std_logic;
	RD1: 		IN std_logic;
	RD2: 		IN std_logic;
	WR: 		IN std_logic;
	ADD_WR: 	IN std_logic_vector(log2_N(Nreg)-1 downto 0);
	ADD_RD1: 	IN std_logic_vector(log2_N(Nreg)-1 downto 0);
	ADD_RD2: 	IN std_logic_vector(log2_N(Nreg)-1 downto 0);
	DATAIN: 	IN std_logic_vector(Nbit-1 downto 0);
   	OUT1: 		OUT std_logic_vector(Nbit-1 downto 0);
	OUT2: 		OUT std_logic_vector(Nbit-1 downto 0));
end register_file;

architecture Behavior of register_file is
-- suggested structures
subtype REG_ADDR is natural range 0 to Nreg-1; -- using natural type
type REG_ARRAY is array(REG_ADDR) of std_logic_vector(Nbit-1 downto 0); 
signal REGISTERS : REG_ARRAY; 

	
begin 

	REGISTERS(0)<=(others => '0');

-- write your RF code 
	PROCESS (CLK,RESET,ENABLE,RD1,RD2,ADD_RD1,ADD_RD2)
	BEGIN	
		IF (RESET = '1') THEN
				REGISTERS <= (OTHERS => (OTHERS => '0'));
				OUT1 <= (OTHERS => 'Z');
				OUT2 <= (OTHERS => 'Z');
		ELSE
			IF (ENABLE = '1') THEN
					IF (RD1 = '1') THEN
						OUT1 <= REGISTERS(to_integer(unsigned(ADD_RD1)));
					END IF;
					IF (RD2 = '1') THEN
						OUT2 <= REGISTERS(to_integer(unsigned(ADD_RD2)));
					END IF;
			ELSE	--WHEN ENABLE '0' HIGH IMPEDANCE
					OUT1 <= (OTHERS => 'Z');
					OUT2 <= (OTHERS => 'Z');
			END IF;
			IF (CLK'EVENT AND CLK = '1') THEN
				IF (ENABLE = '1') THEN
					IF (WR = '1') THEN
						REGISTERS(to_integer(unsigned(ADD_WR))) <= DATAIN;
						--SIMULTANEOU R/W
						IF ADD_WR = ADD_RD1 THEN
							OUT1 <= DATAIN;
						END IF;
						IF ADD_WR = ADD_RD2 THEN
							OUT2 <= DATAIN;
						END IF;
					END IF;
				ELSE--WHEN ENABLE '0' HIGH IMPEDANCE
					OUT1 <= (OTHERS => 'Z');
					OUT2 <= (OTHERS => 'Z');
				END IF;
			END IF;
		END IF;
	END PROCESS;
end Behavior;

----


