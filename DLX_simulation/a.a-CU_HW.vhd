library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use work.global.all;

entity CU_HW is
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

			RF_WR	: out std_logic;
			
			--WBMux41---
			WBMux41_Sel:	out std_logic_vector(1 downto 0));
end CU_HW;

architecture CU_HW_RTL of CU_HW is
	
	signal IR: Instruction;

	signal aluOpCod: aluOp;
	
	signal IR_OPCODE : std_logic_vector(OP_CODE_SIZE -1 downto 0);  -- OpCode part of IR
  	signal IR_FUNC	 : std_logic_vector(FUNC_SIZE-1 downto 0);   -- Func part of IR when Rtype
 	signal CW   	 : std_logic_vector(CW_SIZE - 1 downto 0); -- full control word
	signal Jump_In	 : std_logic; -- for signal when inst is jump
	signal JumpR_In	 : std_logic; -- for signal when inst is jumpR
	signal BranchZ_In : std_logic; -- for signal when inst is branch
	signal BranchNZ_In : std_logic; -- for signal when inst is branch
	signal Branch_In	: std_logic;
 	signal CWSF : std_logic_vector(CW_SIZE-1 downto 0); -- control word of the fatch stage
  	signal CWSD : std_logic_vector(CW_SIZE-1-NUM_SIG_SF downto 0); -- control word of the decode stage
  	signal CWSE : std_logic_vector(CW_SIZE-1-NUM_SIG_SF-NUM_SIG_SD downto 0); -- control word of the execute stage
	signal CWSM : std_logic_vector(CW_SIZE-1-NUM_SIG_SF-NUM_SIG_SD-NUM_SIG_SE downto 0); -- control word of the memory back stage
  	signal CWSWB : std_logic_vector(NUM_SIG_SWB-1 downto 0); -- control word of the write back stage
	


begin
	IR_OPCODE <= Inst(31 downto 26); 	--op code of the instruction
	IR_FUNC <=   Inst(10 downto 0);    	--function code

	-- FATCH stage signals
	FS_Rst				<= CWSF(41); -- reset to fatch stage
	FATCH_En 			<= CWSF(40); -- enables the fatch stage registers
	FATCHRstMux21_Sel 	<= CWSF(39); -- 1 reset of the stage if branch or jump 0 FS_Rst
	PCMux41_Sel			<= CWSF(38 downto 37); --1 1 Beqz 10 Bneqz 01 Jump 00 '0'
	IRAM_Rst			<= CWSF(36); -- reset of IRAM
					
	-- DECODE stage signals
	DECODE_En  			<= CWSD(35); -- eanbles the decode stage registers
	DECODE_Rst  		<= CWSD(34); -- reset the decode stage registers
	RF_Rst   			<= CWSD(33); -- reset the register file
	RF_RD1 				<= CWSD(32); -- read on port 1 of register file
	RF_RD2				<= CWSD(31); -- read on port 2 of register file
	R1Mux21A_Sel 		<= CWSD(30); -- (1 AddrR1=R0 0 AddrR1=AddR1)
	R2Mux21B_Sel 		<= CWSD(29); -- (1 AddrR2=R0 0 AddrR2=AddR2)
	RWMux41WR_Sel 		<= CWSD(28 downto 27);-- (11 AddrWR=R31 10 AddrWR=R0 01 AddrWR=AddrR2 00 AddrWR=AddrR3)
	ImmMux21_Sel		<= CWSD(26); --(1 Imm26 0 Imm16)
				
	-- EXECUTE stage signals
	EXECUTE_En  		<= CWSE(25); -- enables the execute stage registers
	EXECUTE_Rst  		<= CWSE(24); -- resets the execute stage registers
	OPBMux41_Sel   		<= CWSE(23 downto 22); -- (11=4 10=0 01=Imm 00=B)
	OPAMux21_Sel  		<= CWSE(21); -- (1=PC_ret 0=A)
	ALU_Sel  			<= CWSE(20 downto 17); -- selection signals for the ALU operation
	ALU_Unsign 			<= CWSE(16); -- execute an unsigned operation in the ALU
	ALU_Arith_logN  	<= CWSE(15); -- (1 artithmetic shift 0 logical shift)
	StatusMux81_Sel 	<= CWSE(14 downto 12); -- select the flag of the ALU that we want to propagate
	
	-- MEMORY stage signals
	MEMORY_En			<= CWSM(11); -- enables the memory stage registers
	MEMORY_Rst			<= CWSM(10); -- reset the memory stage registers
	DATAMEM_En			<= CWSM(9); -- enables the data memory
	DATAMEM_Rst			<= CWSM(8); -- reset the data memory
	DATAMEM_Read_Wrn	<= CWSM(7); -- (1 read from the memory o write to the memory)
	DATAMEM_Word		<= CWSM(6); -- parallelism of the memory operation is 32 bit
	DATAMEM_HalfWord	<= CWSM(5); -- parallelism of the memory operation is 16 bit
	DATAMEM_Byte		<= CWSM(4); -- parallelism of the memory operation is 8 bit
	DATAMEM_Unsign		<= CWSM(3); -- the number that we want store or read is unsigned

	-- WRITE BACK stage signals
	RF_WR			<= CWSWB(2);
	WBMux41_Sel		<= CWSWB(1 downto 0); -- (11=Memory_data 10=ALU_data 01=Status_data 00='0')

	
			
	-- this process is used to split the control word for the diffrent stage of the pipeline
	CW_PIPE : process (Clk,Rst,IR_OPCODE,IR_FUNC) --process to shift the CW to the stage
			begin
				if (Clk = '0' and Clk'EVENT) then
						CWSF <= CW;
						CWSD <= CWSF(CW_SIZE-1-NUM_SIG_SF downto 0);
						CWSE <= CWSD(CW_SIZE-1-NUM_SIG_SF-NUM_SIG_SD downto 0);
						CWSM <= CWSE(CW_SIZE-1-NUM_SIG_SF-NUM_SIG_SD-NUM_SIG_SE downto 0);
						CWSWB<= CWSM(NUM_SIG_SWB-1 downto 0);
				end if;

	if (Clk = '1' and Clk'EVENT) then					
	-- this case is used to determine which is the right opCode for the ALU based on function and operation code
	-- ALU opcode (ADDcode=00, SUBcode=01, ANDcode=10, ORcode=11)
	-- N.B. : when IR_OPCODE and IR_FUNC are 'Z' conv_integer function returns 0 so the CU execute a NOP instruction
		if (Rst = '1') then -- synchronous active high reset
						CW <= RESET_CW;
						CWSF <= RESET_CW(CW_SIZE-1 downto 0);
						CWSD <= RESET_CW(CW_SIZE-1-NUM_SIG_SF downto 0);
						CWSE <= RESET_CW(CW_SIZE-1-NUM_SIG_SF-NUM_SIG_SD downto 0);
						CWSM <= RESET_CW(CW_SIZE-1-NUM_SIG_SF-NUM_SIG_SD-NUM_SIG_SE downto 0);
						CWSWB <= RESET_CW(NUM_SIG_SWB-1 downto 0);	
						Jump <= '0';
						StoreInst <= '0';
						JumpRInst <= '0';
						BranchZ_In <= '0';
						BranchNZ_In <= '0';
		else
					if (Branch_In='1') then -- eliminate the effect of CW if branch occurs
						CWSF <= (others => '0');
					end if;
					Branch_In <= '0';
					BranchInst <= '0';
					Jump <= '0';
					JumpRInst <= '0';
					Jump_In <= '0';
					JumpR_In <= '0';
					StoreInst <= '0';
					LHIInst <= '0';
					case conv_integer(unsigned(IR_OPCODE)) is
					when conv_integer(unsigned(RTYPE)) =>
						case conv_integer(unsigned(IR_FUNC)) is -- if RTYPE instruction then watch function code
							when conv_integer(unsigned(RTYPE_ADD)) =>
								CW <= CW_RTYPE_ADD;
								aluOpCod <= ADDop; -- only for a clear view on modelsim
								IR <= addr; -- only for a clear view on modelsim
							when conv_integer(unsigned(RTYPE_AND)) =>
								CW <= CW_RTYPE_AND;
								aluOpCod <= ANDop;
								IR <= andr;
							when conv_integer(unsigned(RTYPE_OR)) =>
								CW <= CW_RTYPE_OR;
								aluOpCod <= ORop;
								IR <= orr;
							when conv_integer(unsigned(RTYPE_SGE)) =>
								CW <= CW_RTYPE_SGE;
								aluOpCod <= SUBop;
								IR <= sger;
							when conv_integer(unsigned(RTYPE_SLE)) =>
								CW <= CW_RTYPE_SLE;
								aluOpCod <= SUBop;
								IR <= sler;
							when conv_integer(unsigned(RTYPE_SLL)) =>
								CW <= CW_RTYPE_SLL;
								aluOpCod <= SLLop;
								IR <= sllr;
							when conv_integer(unsigned(RTYPE_SNE)) =>
								CW <= CW_RTYPE_SNE;
								aluOpCod <= SUBop;
								IR <= sner;
							when conv_integer(unsigned(RTYPE_SRL)) =>
								CW <= CW_RTYPE_SRL;
								aluOpCod <= SRLop;
								IR <= srlr;
							when conv_integer(unsigned(RTYPE_SUB)) =>
								CW <= CW_RTYPE_SUB;
								aluOpCod <= SUBop;
								IR <= subr;
							when conv_integer(unsigned(RTYPE_XOR)) =>
								CW <= CW_RTYPE_XOR;
								aluOpCod <= XORop;
								IR <= xorr;
							when conv_integer(unsigned(RTYPE_ADDU)) =>
								CW <= CW_RTYPE_ADDU;
								aluOpCod <= ADDop;
								IR <= addu;
							when conv_integer(unsigned(RTYPE_SEQ)) =>
								CW <= CW_RTYPE_SEQ;
								aluOpCod <= SUBop;
								IR <= seq;
							when conv_integer(unsigned(RTYPE_SGEU)) =>
								CW <= CW_RTYPE_SGEU;
								aluOpCod <= SUBop;
								IR <= sgeu;
							when conv_integer(unsigned(RTYPE_SGT)) =>
								CW <= CW_RTYPE_SGT;
								aluOpCod <= SUBop;
								IR <= sgt;
							when conv_integer(unsigned(RTYPE_SGTU)) =>
								CW <= CW_RTYPE_SGTU;
								aluOpCod <= SUBop;
								IR <= sgtu;
							when conv_integer(unsigned(RTYPE_SLT)) =>
								CW <= CW_RTYPE_SLT;
								aluOpCod <= SUBop;
								IR <= slt;
							when conv_integer(unsigned(RTYPE_SLTU)) =>
								CW <= CW_RTYPE_SLTU;
								aluOpCod <= SUBop;
								IR <= sltu;
							when conv_integer(unsigned(RTYPE_SRA)) =>
								CW <= CW_RTYPE_SRA;
								aluOpCod <= SRAop;
								IR <= srax;
							when conv_integer(unsigned(RTYPE_SUBU)) =>
								CW <= CW_RTYPE_SUBU;
								aluOpCod <= SUBop;
								IR <= subu;
							when conv_integer(unsigned(RTYPE_MULT)) =>
								CW <= CW_RTYPE_MULT;
								aluOpCod <= MULop;
								IR <= mult;
							when conv_integer(unsigned(RTYPE_ROL)) =>
								CW <= CW_RTYPE_ROL;
								aluOpCod <= ROLop;
								IR <= rolx;
							when conv_integer(unsigned(RTYPE_ROR)) =>
								CW <= CW_RTYPE_ROR;
								aluOpCod <= RORop;
								IR <= rorx;
							when others =>
								CW <= (others => 'Z');
								aluOpCod <= OTHERop;
								IR <= OTHER;
						end case;
					-- JTYPE instructions 
					when conv_integer(unsigned(JTYPE_JABS)) =>
						CW <= CW_JTYPE_JABS;
						Jump <= '1';
						Jump_In <= '1';
						aluOpCod <= ADDop;
						IR <= j;
					when conv_integer(unsigned(JTYPE_JAL)) =>
						CW <= CW_JTYPE_JAL;
						Jump <= '1';
						Jump_In <= '1';
						aluOpCod <= ADDop;
						IR <= jal;
					when conv_integer(unsigned(JTYPE_JR)) =>
						CW <= CW_JTYPE_JR;
						BranchInst <= '1';
						JumpR_In <= '1';
						JumpRInst <= '1';
						aluOpCod <= ADDop;
						IR <= jr;
					when conv_integer(unsigned(JTYPE_JALR)) =>
						CW <= CW_JTYPE_JALR;
						BranchInst <= '1';
						JumpR_In <= '1';
						JumpRInst <= '1';
						aluOpCod <= ADDop;
						IR <= jalr;
					---ITYPE instructions
					when conv_integer(unsigned(ITYPE_ADDI)) =>
						CW <= CW_ITYPE_ADDI;
						aluOpCod <= ADDop;
						IR <= addi;
					when conv_integer(unsigned(ITYPE_ANDI)) =>
						CW <= CW_ITYPE_ANDI;
						aluOpCod <= ANDop;
						IR <= andi;
					when conv_integer(unsigned(ITYPE_BEQZ)) =>
						BranchZ_In <= '1';
						BranchInst <= '1';
						CW <= CW_ITYPE_BEQZ;
						aluOpCod <= ADDop;
						IR <= beqz;
					when conv_integer(unsigned(ITYPE_BNEQZ)) =>
						BranchNZ_In <= '1';
						BranchInst <= '1';
						CW <= CW_ITYPE_BNEQZ;
						aluOpCod <= ADDop;
						IR <= bnez;
					when conv_integer(unsigned(ITYPE_LW)) =>
						CW <= CW_ITYPE_LW;
						aluOpCod <= ADDop;
						IR <= lw;
						StoreInst <= '1';
					when conv_integer(unsigned(ITYPE_LH)) =>
						CW <= CW_ITYPE_LHW;
						aluOpCod <= ADDop;
						IR <= lhw;
						StoreInst <= '1';
					when conv_integer(unsigned(ITYPE_LB)) =>
						CW <= CW_ITYPE_LB;
						aluOpCod <= ADDop;
						IR <= lb;
						StoreInst <= '1';
					when conv_integer(unsigned(ITYPE_LHU)) =>
						CW <= CW_ITYPE_LHWU;
						aluOpCod <= ADDop;
						IR <= lhwu;
						StoreInst <= '1';
					when conv_integer(unsigned(ITYPE_LBU)) =>
						CW <= CW_ITYPE_LBU;
						aluOpCod <= ADDop;
						IR <= lbu;
						StoreInst <= '1';
					when conv_integer(unsigned(ITYPE_NOP)) =>
						CW <= CW_ITYPE_NOP;
						aluOpCod <= ANDop;
						IR <= nop;
					when conv_integer(unsigned(ITYPE_ORI)) =>
						CW <= CW_ITYPE_ORI;
						aluOpCod <= ORop;
						IR <= ori;
					when conv_integer(unsigned(ITYPE_SGEI)) =>
						CW <= CW_ITYPE_SGEI;
						aluOpCod <= SUBop;
						IR <= sgei;
					when conv_integer(unsigned(ITYPE_SLEI)) =>
						CW <= CW_ITYPE_SLEI;
						aluOpCod <= SUBop;
						IR <= slei;
					when conv_integer(unsigned(ITYPE_SLLI)) =>
						CW <= CW_ITYPE_SLLI;
						aluOpCod <= SLLop;
						IR <= slli;
					when conv_integer(unsigned(ITYPE_SNEI)) =>
						CW <= CW_ITYPE_SNEI;
						aluOpCod <= SUBop;
						IR <= snei;
					when conv_integer(unsigned(ITYPE_SRLI)) =>
						CW <= CW_ITYPE_SRLI;
						aluOpCod <= SRLop;
						IR <= srli;
					when conv_integer(unsigned(ITYPE_SUBI)) =>
						CW <= CW_ITYPE_SUBI;
						aluOpCod <= SUBop;
						IR <= subi;
					when conv_integer(unsigned(ITYPE_SW)) =>
						CW <= CW_ITYPE_SW;
						aluOpCod <= ADDop;
						StoreInst <= '1';
						IR <= sw;
					when conv_integer(unsigned(ITYPE_SH)) =>
						CW <= CW_ITYPE_SHW;
						aluOpCod <= ADDop;
						StoreInst <= '1';
						IR <= shw;
					when conv_integer(unsigned(ITYPE_SB)) =>
						CW <= CW_ITYPE_SB;
						aluOpCod <= ADDop;
						StoreInst <= '1';
						IR <= sb;
					when conv_integer(unsigned(ITYPE_XORI)) =>
						CW <= CW_ITYPE_XORI;
						aluOpCod <= XORop;
						IR <= xori;
					when conv_integer(unsigned(ITYPE_ADDUI)) =>
						CW <= CW_ITYPE_ADDUI;
						aluOpCod <= ADDop;
						IR <= addui;
					when conv_integer(unsigned(ITYPE_SEQI)) =>
						CW <= CW_ITYPE_SEQI;
						aluOpCod <= SUBop;
						IR <= seqi;
					when conv_integer(unsigned(ITYPE_SGEUI)) =>
						CW <= CW_ITYPE_SGEUI;
						aluOpCod <= SUBop;
						IR <= sgeui;
					when conv_integer(unsigned(ITYPE_SGTI)) =>
						CW <= CW_ITYPE_SGTI;
						aluOpCod <= SUBop;
						IR <= sgti;
					when conv_integer(unsigned(ITYPE_SGTUI)) =>
						CW <= CW_ITYPE_SGTUI;
						aluOpCod <= SUBop;
						IR <= sgtui;
					when conv_integer(unsigned(ITYPE_SLTI)) =>
						CW <= CW_ITYPE_SLTI;
						aluOpCod <= SUBop;
						IR <= slti;
					when conv_integer(unsigned(ITYPE_SLTUI)) =>
						CW <= CW_ITYPE_SLTUI;
						aluOpCod <= SUBop;
						IR <= sltui;
					when conv_integer(unsigned(ITYPE_SRAI)) =>
						CW <= CW_ITYPE_SRAI;
						aluOpCod <= SRAop;
						IR <= srai;
					when conv_integer(unsigned(ITYPE_SUBUI)) =>
						CW <= CW_ITYPE_SUBUI;
						aluOpCod <= SUBop;
						IR <= subui;
					when conv_integer(unsigned(ITYPE_LHI)) =>
						CW <= CW_ITYPE_LHI;
						aluOpCod <= ADDop;
						LHIInst <= '1';
						IR <= lhi;
					when conv_integer(unsigned(ITYPE_ROLI)) =>
						CW <= CW_ITYPE_ROLI;
						aluOpCod <= ROLop;
						IR <= roli;
					when conv_integer(unsigned(ITYPE_RORI)) =>
						CW <= CW_ITYPE_RORI;
						aluOpCod <= RORop;
						IR <= rori;
					when others =>
						CW <= (others => 'Z');
						aluOpCod <= OTHERop;
						IR <= OTHER;
				end case;
				--------------------------------------------------
				--CW(37) and CW(38) are two bit of selection of a multiplexer that determine if the next instruction will be affected by a jump or a branch
					if (JumpR_In='1') then
						CW(38) <= '0'; 
						CW(37) <= '1';
						JumpR_In <= '0';
						JumpRInst <= '0';
						BranchInst <= '0';
					end if;
					if (BranchZ_In='1') then
						CW(38) <= '1'; 
						CW(37) <= '0';
						BranchZ_In <= '0';
						BranchInst <= '0';
					end if;
					if (BranchNZ_In='1') then
						CW(38) <= '1'; 
						CW(37) <= '1';
						BranchNZ_In <= '0';
						BranchInst <= '0';
					end if;
				------------------------------------------------------------
		end if;
	end if;
end process CW_PIPE;
				
	
end CU_HW_RTL;
