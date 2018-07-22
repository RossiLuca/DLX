library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.global.all;
use work.functions.all;

entity DLX is
	port(
		Clk : in std_logic;
		Rst : in std_logic);
end DLX;

architecture Structure of DLX is

signal Inst:  std_logic_vector((I_SIZE-1) downto 0);
----Fatch Stage---------------------------
signal FS_Rst: std_logic;
signal FATCHRstMux21_Sel: std_logic;
signal FATCH_En: std_logic;
signal PCMux41_Sel: std_logic_vector(1 downto 0);
signal Jump: std_logic;
signal BranchInst: std_logic;
signal IRAM_Rst:std_logic;
signal StoreInst: std_logic;
signal JumpRInst: std_logic;
signal LHIInst: std_logic;
----Decode Stage----------------------------
signal DECODE_Rst: std_logic;
signal DECODE_En: std_logic;
signal BrNZ:  std_logic;
signal BrZ :  std_logic;
----RF-------
signal RF_Rst : std_logic;
signal RF_RD1 : std_logic;
signal RF_RD2 : std_logic;
signal R1Mux21A_Sel : std_logic;
signal R2Mux21B_Sel : std_logic;
signal RWMux41WR_Sel : std_logic_vector(1 downto 0);
----ImmMux21---------
signal ImmMux21_Sel :  std_logic;
---Execute Stage-----------------------------
signal EXECUTE_Rst :  std_logic;
signal EXECUTE_En :  std_logic;
----OPAMux21----
signal OPAMux21_Sel : std_logic;
----OPBMux21----
signal OPBMux41_Sel : std_logic_vector(1 downto 0);
----ALU---------
signal ALU_Sel : std_logic_vector ((NALUop-1) downto 0);
signal ALU_Unsign : std_logic;
signal ALU_Arith_logN : std_logic;
--StatusMux81----
signal StatusMux81_sel : std_logic_vector (2 downto 0);
------Memory Stage-----------------------
signal MEMORY_Rst : std_logic;
signal	MEMORY_En : std_logic;
---Data Memory------
signal DATAMEM_En : std_logic;
signal	DATAMEM_Rst : std_logic;
signal DATAMEM_Read_Wrn : std_logic;
signal DATAMEM_Word : std_logic;
signal DATAMEM_HalfWord : std_logic;
signal DATAMEM_Byte : std_logic;
signal DATAMEM_Unsign : std_logic;
------Write Back Stage--------------------
signal WBMux41_Sel : std_logic_vector(1 downto 0);
signal RF_WR : std_logic;

component datapath is 
	generic ( 	
			Nbit: integer := Nbit;
			
			---Instruction Memory constants------
			RAM_DEPTH: integer:=RAM_DEPTH;
			I_SIZE: integer:= I_SIZE;
			
			---Data Memory constants-------
			DATA_MEM_SIZE: integer:= DATA_MEM_SIZE;
			
			---ALU constants---------------
			Nlogicfun: integer:= Nlogicfun;
			NALUop:	integer:= NALUop);
	port (		
			Rst: in std_logic;
			Clk: in std_logic;
			Inst: out std_logic_vector((I_SIZE-1) downto 0);
			BrNZ: out std_logic;
			BrZ : out std_logic;
			BranchInst: in std_logic;
			StoreInst:	in std_logic;
			JumpRInst: in std_logic;
			LHIInst: in std_logic;
			
			----Fatch Stage---------------------------
			FS_Rst:  in std_logic;
			FATCHRstMux21_Sel: in std_logic;
			FATCH_En:   in std_logic;

			PCMux41_Sel: 	in std_logic_vector(1 downto 0);
			Jump:	  	in std_logic;
			
			-----IRAM-----
			IRAM_Rst: in std_logic;
			
			----Decode Stage----------------------------
			DECODE_Rst:  in std_logic;
			DECODE_En:   in std_logic;

			----RF-------
			RF_Rst		: in std_logic;
			RF_RD1		: in std_logic;
			RF_RD2		: in std_logic;
			R1Mux21A_Sel	: in std_logic;
			R2Mux21B_Sel	: in std_logic;
			RWMux41WR_Sel	:in std_logic_vector(1 downto 0);
			
			----ImmMux21---------
			ImmMux21_Sel: in std_logic;
			
			---Execute Stage-----------------------------
			EXECUTE_Rst:  in std_logic;
			EXECUTE_En:   in std_logic;

			----OPAMux21----
			OPAMux21_Sel: in std_logic;
			
			----OPBMux21----
			OPBMux41_Sel: in std_logic_vector(1 downto 0);
			
			----ALU---------
			ALU_Sel: 	in std_logic_vector ((NALUop-1) downto 0);
			ALU_Unsign: 	in std_logic;
			ALU_Arith_logN: in std_logic;

			--StatusMux81----
			StatusMux81_sel: in std_logic_vector (2 downto 0);

			------Memory Stage-----------------------
			MEMORY_Rst:  in std_logic;
			MEMORY_En:   in std_logic;
			
			---Data Memory------
			DATAMEM_En	: in std_logic;
			DATAMEM_Rst	: in std_logic;
			DATAMEM_Read_Wrn: in std_logic;
			DATAMEM_Word	: in std_logic;
			DATAMEM_HalfWord: in std_logic;
			DATAMEM_Byte	: in std_logic;
			DATAMEM_Unsign	: in std_logic;

			------Write Back Stage--------------------
			RF_WR		: in std_logic;
			WBMux41_Sel	: in std_logic_vector(1 downto 0));

end component;

component CU_HW is
	generic ( 
			FUNC_SIZE	:     integer := FUNC_SIZE;  	-- Func Field Size for R-Type Ops
    			OP_CODE_SIZE	:     integer := OP_CODE_SIZE;  	-- Op Code Size
    			NALUop		:     integer := NALUop;  		-- ALU Op Code Word Size
    			I_SIZE		:     integer := I_SIZE;  		-- Instruction Register Size    
    			CW_SIZE		:     integer := CW_SIZE); 		-- Control Word Size
	port (		
			Clk	: in std_logic;
			Rst	: in std_logic; -- reset active high
			Inst	: in std_logic_vector ((I_SIZE-1) downto 0); ---instruction
			BrNZ: in std_logic;
			BrZ : in std_logic;
			BranchInst: out std_logic;
			StoreInst:	out std_logic;
			JumpRInst: out std_logic;
			LHIInst: out std_logic;
			
			----Fatch Stage---------------------------
			FS_Rst:  out std_logic;
			FATCHRstMux21_Sel: out std_logic;
			FATCH_En:   out std_logic;
			PCMux41_Sel: out std_logic_vector(1 downto 0);
			Jump:	    out std_logic;
			
			-----IRAM-----
			IRAM_Rst: out std_logic;

			----Decode Stage----------------------------
			DECODE_Rst:  out std_logic;
			DECODE_En:   out std_logic;

			----RF-------
			RF_Rst	: 	out std_logic;
			RF_RD1	: 	out std_logic;
			RF_RD2	: 	out std_logic;
			R1Mux21A_Sel: 	out std_logic;
			R2Mux21B_Sel: 	out std_logic;
			RWMux41WR_Sel:	out std_logic_vector(1 downto 0);

			----ImmMux21----------
			ImmMux21_Sel: out std_logic;
						
			---Execute Stage-----------------------------
			EXECUTE_Rst:  out std_logic;
			EXECUTE_En:   out std_logic;

			----OPAMux21----
			OPAMux21_Sel: out std_logic;
			
			----OPBMux21----
			OPBMux41_Sel: out std_logic_vector(1 downto 0);
			
			----ALU---------
			ALU_Sel: 	out std_logic_vector ((NALUop-1) downto 0);
			ALU_Unsign: 	out std_logic;
			ALU_Arith_logN: out std_logic;

			--StatusMux81----
			StatusMux81_sel: out std_logic_vector (2 downto 0);

			------Memory Stage-----------------------
			MEMORY_Rst:  out std_logic;
			MEMORY_En:   out std_logic;
			
			---Data Memory------
			DATAMEM_En	: out std_logic;
			DATAMEM_Rst	: out std_logic;
			DATAMEM_Read_Wrn: out std_logic;
			DATAMEM_Word	: out std_logic;
			DATAMEM_HalfWord: out std_logic;
			DATAMEM_Byte	: out std_logic;
			DATAMEM_Unsign	: out std_logic;

			------Write Back Stage--------------------
			RF_WR	: out std_logic;
			
			--WBMux41---
			WBMux41_Sel:	out std_logic_vector(1 downto 0));
end component;

begin

datap:	datapath port map
	(	Rst => Rst,
		Clk => Clk,
		Inst => Inst,
		BrNZ => BrNZ,
		BrZ => BrZ,
		BranchInst => BranchInst,
		StoreInst => StoreInst,
		JumpRInst => JumpRInst,
		LHIInst => LHIInst,
		FS_Rst => FS_Rst,
		FATCHRstMux21_Sel => FATCHRstMux21_Sel,
		FATCH_En => FATCH_En,
		PCMux41_Sel => PCMux41_Sel,
		Jump => Jump,
		IRAM_Rst => IRAM_Rst,
		DECODE_Rst => DECODE_Rst,
		DECODE_En => DECODE_En,
		RF_Rst => RF_Rst,	
		RF_RD1 => RF_RD1,
		RF_RD2 => RF_RD2,
		R1Mux21A_Sel => R1Mux21A_Sel,
		R2Mux21B_Sel => R2Mux21B_Sel,
		RWMux41WR_Sel => RWMux41WR_Sel,
		ImmMux21_Sel => ImmMux21_Sel,
		EXECUTE_Rst => EXECUTE_Rst,
		EXECUTE_En => EXECUTE_En,
		OPAMux21_Sel => OPAMux21_Sel,
		OPBMux41_Sel => OPBMux41_Sel,
		ALU_Sel => ALU_Sel,
		ALU_Unsign => ALU_Unsign,
		ALU_Arith_logN => ALU_Arith_logN,
		StatusMux81_sel => StatusMux81_sel,
		MEMORY_Rst => MEMORY_Rst,
		MEMORY_En => MEMORY_En,
		DATAMEM_En => DATAMEM_En,
		DATAMEM_Rst => DATAMEM_Rst,
		DATAMEM_Read_Wrn => DATAMEM_Read_Wrn,
		DATAMEM_Word => DATAMEM_Word,
		DATAMEM_HalfWord => DATAMEM_HalfWord,
		DATAMEM_Byte => DATAMEM_Byte,
		DATAMEM_Unsign => DATAMEM_Unsign,
		RF_WR => RF_WR,
		WBMux41_Sel => WBMux41_Sel);	

CU:	CU_HW port map (	
		Clk => Clk,
		Rst => Rst,
		Inst => Inst,
		BrNZ => BrNZ,
		BrZ => BrZ,
		BranchInst => BranchInst,
		StoreInst => StoreInst,
		JumpRInst => JumpRInst,
		LHIInst => LHIInst,
		FS_Rst => FS_Rst,
		FATCHRstMux21_Sel => FATCHRstMux21_Sel,
		FATCH_En => FATCH_En,
		PCMux41_Sel => PCMux41_Sel,
		Jump => Jump,
		IRAM_Rst => IRAM_Rst,
		DECODE_Rst => DECODE_Rst,
		DECODE_En => DECODE_En,
		RF_Rst => RF_Rst,	
		RF_RD1 => RF_RD1,
		RF_RD2 => RF_RD2,
		R1Mux21A_Sel => R1Mux21A_Sel,
		R2Mux21B_Sel => R2Mux21B_Sel,
		RWMux41WR_Sel => RWMux41WR_Sel,
		ImmMux21_Sel => ImmMux21_Sel,
		EXECUTE_Rst => EXECUTE_Rst,
		EXECUTE_En => EXECUTE_En,
		OPAMux21_Sel => OPAMux21_Sel,
		OPBMux41_Sel => OPBMux41_Sel,
		ALU_Sel => ALU_Sel,
		ALU_Unsign => ALU_Unsign,
		ALU_Arith_logN => ALU_Arith_logN,
		StatusMux81_sel => StatusMux81_sel,
		MEMORY_Rst => MEMORY_Rst,
		MEMORY_En => MEMORY_En,
		DATAMEM_En => DATAMEM_En,
		DATAMEM_Rst => DATAMEM_Rst,
		DATAMEM_Read_Wrn => DATAMEM_Read_Wrn,
		DATAMEM_Word => DATAMEM_Word,
		DATAMEM_HalfWord => DATAMEM_HalfWord,
		DATAMEM_Byte => DATAMEM_Byte,
		DATAMEM_Unsign => DATAMEM_Unsign,
		RF_WR => RF_WR,
		WBMux41_Sel => WBMux41_Sel);

end Structure;
