library ieee;
use ieee.std_logic_1164.all;

package global is

-------------general constants-------------------
	constant Nbit: 		integer:= 32;
	constant Nreg:		integer:= 32;


-------------CU constants-----------------------
	constant ADDR_REG_SIZE: integer:=5;
	constant IMM_SIZEI: 	integer:=16;
	constant IMM_SIZEJ:		integer:=26;
	constant CW_SIZE:		integer:=42;
	constant OP_CODE_SIZE: 	integer:=6;
	constant FUNC_SIZE:		integer:=11;
	constant NUM_SIG_SF:	integer:=6;
	constant NUM_SIG_SD:	integer:=10;
	constant NUM_SIG_SE:	integer:=14;
	constant NUM_SIG_SM:	integer:=9;
	constant NUM_SIG_SWB:	integer:=3;

--Signals for each Stage of pipe
--FS_Rst,FATCH_En,FATCHRstMux21_Sel,PCselMux41,IRAM_Rst
--DECODE_En,DECODE_Rst,RF_Rst,(RF_En),RF_RD1,RF_RD2,R1Mux21A_Sel,R2Mux21B_Sel,RWmux41WR_Sel,ImmMux21_Sel
--EXECUTE_En,EXECUTE_Rst,OPBMux41_Sel,OPAMux21_Sel,ALU_Sel,ALU_Unsign,ALU_Arith_logN,StatusMux81_Sel
--MEMORY_En,MEMORY_Rst,DATAMEM_En,DATAMEM_Rst,DATAMEM_Read_Wrn,DATAMEM_Word,DATAMEM_HalfWord,DATAMEM_Byte,DATAMEM_Unsign
--RF_WR,WBMux41_Sel

-------------Instruction Memory constants-------------
	constant RAM_DEPTH: 	integer :=30;
	constant I_SIZE:		integer:= 32;

-------------Data Memory constants---------------
	constant DATA_MEM_SIZE: integer:= 10;


------------ALU constants------------------------
	constant Nlogicfun:  integer := 3;  --number of bit necessary to encode the logical function of the ALU
    constant NALUop:	 integer := 4; --number of bit necessary to encode the ALU operations

----------- ALU function code
    constant ADDcode:   	std_logic_vector((NALUop-1) downto 0):= "0000";
    constant SUBcode:   	std_logic_vector((NALUop-1) downto 0):= "0001";
	constant MULcode:		std_logic_vector((NALUop-1) downto 0):= "0010";
 	constant NOTAcode: 		std_logic_vector((NALUop-1) downto 0):= "0011";
	constant NOTBcode: 		std_logic_vector((NALUop-1) downto 0):= "0100";
	constant ANDcode: 		std_logic_vector((NALUop-1) downto 0):= "0101";
	constant ORcode: 		std_logic_vector((NALUop-1) downto 0):= "0110";
	constant XORcode: 		std_logic_vector((NALUop-1) downto 0):= "0111";
	constant NANDcode: 		std_logic_vector((NALUop-1) downto 0):= "1000";
	constant NORcode: 		std_logic_vector((NALUop-1) downto 0):= "1001";
	constant XNORcode: 		std_logic_vector((NALUop-1) downto 0):= "1010";
    constant SHIFTLcode: 	std_logic_vector((NALUop-1) downto 0):= "1011";
   	constant SHIFTRcode: 	std_logic_vector((NALUop-1) downto 0):= "1100";
    constant ROTATELcode: 	std_logic_vector((NALUop-1) downto 0):=	"1101";
	constant ROTATERcode: 	std_logic_vector((NALUop-1) downto 0):=	"1110";

------------Possible ALU OP (Only for simulation)-----------------------
	TYPE aluOp IS (ADDop,SUBop,MULop,NOTAop,NOTBop,ANDop,ORop,XORop,NANDop,NORop,XNORop,SLLop,SRLop,ROLop,RORop,SRAop,OTHERop);

------------Possible Instructions (Only for simulation)-------------------
	TYPE Instruction IS (addr,addi,andr,andi,beqz,bnez,j,jal,jr,jalr,lw,lhw,lb,lhwu,lbu,nop,orr,ori,sger,sgei,sler,slei,sllr,slli,sner,snei,srlr,srli,subr,subi,sw,shw,sb,shwu,sbu,xorr,xori,addu,addui,seq,seqi,sgeu,sgeui,sgt,sgti,sgtu,sgtui,slt,slti,sltu,sltui,srax,srai,subu,subui,lhi,mult,rorx,rolx,roli,rori,OTHER,RESET);

---------------------------------------Instruction coding----------------------------------------------
-- R-Type instruction -> OPCODE field
	constant RTYPE : std_logic_vector(OP_CODE_SIZE-1 downto 0)	:= "000000";

-- R-Type instruction -> FUNC field
	constant RTYPE_NOP : 	std_logic_vector(FUNC_SIZE - 1 downto 0)		:=  "00000000000";    -- x00
	constant RTYPE_ROR : 	std_logic_vector(FUNC_SIZE - 1 downto 0)		:=  "00000000001";    -- x01
	constant RTYPE_SLL : 	std_logic_vector(FUNC_SIZE - 1 downto 0)		:=  "00000000100";    -- x04
	constant RTYPE_ROL : 	std_logic_vector(FUNC_SIZE - 1 downto 0)		:=  "00000000101";    -- x05
    constant RTYPE_SRL : 	std_logic_vector(FUNC_SIZE - 1 downto 0)		:=  "00000000110";    -- x06
	constant RTYPE_SRA : 	std_logic_vector(FUNC_SIZE - 1 downto 0) 		:=  "00000000111";    -- x07
    constant RTYPE_ADD :	std_logic_vector(FUNC_SIZE - 1 downto 0) 		:=  "00000100000";    -- x20
    constant RTYPE_ADDU: 	std_logic_vector(FUNC_SIZE - 1 downto 0) 		:=  "00000100001";    -- x21
    constant RTYPE_SUB : 	std_logic_vector(FUNC_SIZE - 1 downto 0) 		:=  "00000100010";    -- x22
    constant RTYPE_SUBU: 	std_logic_vector(FUNC_SIZE - 1 downto 0) 		:=  "00000100011";    -- x23
	constant RTYPE_AND : 	std_logic_vector(FUNC_SIZE - 1 downto 0) 		:=  "00000100100";    -- x24
    constant RTYPE_OR  : 	std_logic_vector(FUNC_SIZE - 1 downto 0) 		:=  "00000100101";    -- x25
    constant RTYPE_XOR :	std_logic_vector(FUNC_SIZE - 1 downto 0) 		:=  "00000100110";    -- x26
    constant RTYPE_SEQ : 	std_logic_vector(FUNC_SIZE - 1 downto 0) 		:=  "00000101000";    -- x28
	constant RTYPE_SNE : 	std_logic_vector(FUNC_SIZE - 1 downto 0) 		:=  "00000101001";    -- x29
    constant RTYPE_SLT : 	std_logic_vector(FUNC_SIZE - 1 downto 0) 		:=  "00000101010";    -- x2a
	constant RTYPE_SGT : 	std_logic_vector(FUNC_SIZE - 1 downto 0) 		:=  "00000101011";    -- x2b
    constant RTYPE_SLE : 	std_logic_vector(FUNC_SIZE - 1 downto 0) 		:=  "00000101100";    -- x2c
	constant RTYPE_SGE : 	std_logic_vector(FUNC_SIZE - 1 downto 0) 		:=  "00000101101";    -- x2d
    constant RTYPE_MOVI2S: 	std_logic_vector(FUNC_SIZE - 1 downto 0) 		:=  "00000110000";    -- x30
	constant RTYPE_MOVS2I: 	std_logic_vector(FUNC_SIZE - 1 downto 0) 		:=  "00000110001";    -- x31
   	constant RTYPE_MOVF  : 	std_logic_vector(FUNC_SIZE - 1 downto 0) 		:=  "00000110010";    -- x32
	constant RTYPE_MOVD  : 	std_logic_vector(FUNC_SIZE - 1 downto 0) 		:=  "00000110011";    -- x33
   	constant RTYPE_MOVFP2I: std_logic_vector(FUNC_SIZE - 1 downto 0) 		:=  "00000110100";    -- x34
	constant RTYPE_MOVI2FP: std_logic_vector(FUNC_SIZE - 1 downto 0) 		:=  "00000110101";    -- x35
   	constant RTYPE_MOVI2T: 	std_logic_vector(FUNC_SIZE - 1 downto 0) 		:=  "00000110110";    -- x36
	constant RTYPE_MOVT2I: 	std_logic_vector(FUNC_SIZE - 1 downto 0) 		:=  "00000110111";    -- x37
   	constant RTYPE_SLTU: 	std_logic_vector(FUNC_SIZE - 1 downto 0) 		:=  "00000111010";    -- x3a
	constant RTYPE_SGTU: 	std_logic_vector(FUNC_SIZE - 1 downto 0) 		:=  "00000111011";    -- x3b
   	constant RTYPE_SLEU: 	std_logic_vector(FUNC_SIZE - 1 downto 0) 		:=  "00000111100";    -- x3c
	constant RTYPE_SGEU: 	std_logic_vector(FUNC_SIZE - 1 downto 0) 		:=  "00000111101";    -- x3d
	constant RTYPE_MULT: 	std_logic_vector(FUNC_SIZE - 1 downto 0) 		:=  "00000001110";    -- x0e
		
-- J-Type instruction -> OPCODE field
    constant JTYPE_JABS 	: std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "000010";    -- x02
	constant JTYPE_JAL 		: std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "000011";    -- x03
	constant JTYPE_JR 		: std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "010010";    -- x12
	constant JTYPE_JALR 	: std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "010011";    -- x13

-- I-Type instructions -> OPCODE field
	constant ITYPE_ROLI 	: std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "111110";    -- x3e
	constant ITYPE_RORI 	: std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "111111";    -- x3f
	constant ITYPE_BEQZ 	: std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "000100";    -- x04
	constant ITYPE_BNEQZ 	: std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "000101";    -- x05
	constant ITYPE_BFPT 	: std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "000110";    -- x06
	constant ITYPE_BFPF 	: std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "000111";    -- x07
	constant ITYPE_ADDI 	: std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "001000";    -- x08
	constant ITYPE_ADDUI  	: std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "001001";    -- x09
	constant ITYPE_SUBI   	: std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "001010";    -- x0a
	constant ITYPE_SUBUI    : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "001011";    -- x0b
	constant ITYPE_ANDI     : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "001100";    -- x0c
	constant ITYPE_ORI      : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "001101";    -- x0d
	constant ITYPE_XORI     : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "001110";    -- x0e
	constant ITYPE_LHI   	: std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "001111";    -- x0f
	constant ITYPE_RFE 		: std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "010000";    -- x10
	constant ITYPE_TRAP 	: std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "010001";    -- x11
	constant ITYPE_SLLI 	: std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "010100";    -- x14
	constant ITYPE_NOP 		: std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "010101";    -- x15
	constant ITYPE_SRLI 	: std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "010110";    -- x16
	constant ITYPE_SRAI  	: std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "010111";    -- x17
	constant ITYPE_SEQI   	: std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "011000";    -- x18
	constant ITYPE_SNEI     : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "011001";    -- x19
	constant ITYPE_SLTI     : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "011010";    -- x1a
	constant ITYPE_SGTI     : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "011011";    -- x1b
	constant ITYPE_SLEI     : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "011100";    -- x1c
	constant ITYPE_SGEI   	: std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "011101";    -- x1d
	constant ITYPE_LB 		: std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "100000";    -- x20
	constant ITYPE_LH 		: std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "100001";    -- x21
	constant ITYPE_LW 		: std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "100011";    -- x23
	constant ITYPE_LBU 		: std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "100100";    -- x24
	constant ITYPE_LHU  	: std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "100101";    -- x25
	constant ITYPE_LF   	: std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "100110";    -- x26
	constant ITYPE_LD       : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "100111";    -- x27
	constant ITYPE_SB       : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "101000";    -- x28
	constant ITYPE_SH       : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "101001";    -- x29
	constant ITYPE_SW       : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "101011";    -- x2b
	constant ITYPE_SF   	: std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "101110";    -- x2e
	constant ITYPE_SD       : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "101111";    -- x2f
	constant ITYPE_ITLB     : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "111000";    -- x38
	constant ITYPE_SLTUI   	: std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "111010";    -- x3a
	constant ITYPE_SGTUI    : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "111011";    -- x3b
	constant ITYPE_SLEUI   	: std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "111100";    -- x3c
	constant ITYPE_SGEUI   	: std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "111101";    -- x3d

--------------------------------End Instruction Coding---------------------------------------------------------------

---------------------------------CW for FATCH stage -----------------------------------------------------------------

--FS_Rst,FATCH_En,FATCHRstMux21_Sel,PCselMux41,IRAM_Rst

	constant BNZ_FATCH	:std_logic_vector((NUM_SIG_SF-1) downto 0) := "011"&"00"&"0";
	constant BZ_FATCH	:std_logic_vector((NUM_SIG_SF-1) downto 0) := "011"&"00"&"0";
	constant J_FATCH	:std_logic_vector((NUM_SIG_SF-1) downto 0) := "011"&"01"&"0";
	constant NORM_FATCH	:std_logic_vector((NUM_SIG_SF-1) downto 0) := "010"&"00"&"0";
	constant RST_FATCH	:std_logic_vector((NUM_SIG_SF-1) downto 0) := "110"&"00"&"0";

---------------------------------End CW for FATCH stage---------------------------------------------------------------

---------------------------------CW for DECODE stage-----------------------------------------------------------------

--DECODE_En,DECODE_Rst,RF_Rst,(RF_En),RF_RD1,RF_RD2,R1Mux21A_Sel,R2Mux21B_Sel,RWmux41WR_Sel,ImmMux21_Sel

	constant DECODE_R	:std_logic_vector((NUM_SIG_SD-1) downto 0) := "1001100"&"00"&"0";
	constant DECODE_I	:std_logic_vector((NUM_SIG_SD-1) downto 0) := "1001000"&"01"&"0";
	constant DECODE_L	:std_logic_vector((NUM_SIG_SD-1) downto 0) := "1001100"&"01"&"0";
	constant DECODE_B	:std_logic_vector((NUM_SIG_SD-1) downto 0) := "0001000"&"00"&"0";
	constant DECODE_NOP	:std_logic_vector((NUM_SIG_SD-1) downto 0) := "1001111"&"10"&"0";
	constant DECODE_JABS:std_logic_vector((NUM_SIG_SD-1) downto 0) := "0000000"&"00"&"0";
	constant DECODE_JAL	:std_logic_vector((NUM_SIG_SD-1) downto 0) := "1000000"&"11"&"0";
	constant DECODE_JARL:std_logic_vector((NUM_SIG_SD-1) downto 0) := "1001000"&"11"&"0";
	constant DECODE_RST	:std_logic_vector((NUM_SIG_SD-1) downto 0) := "1110000"&"00"&"0";

---------------------------------End CW for DECODE stage---------------------------------------------------------------

---------------------------------CW for EXECUTE stage-----------------------------------------------------------------

--EXECUTE_En,EXECUTE_Rst,OPBMux41_Sel,OPAMux21_Sel,ALU_Sel,ALU_Unsign,ALU_Arith_logN,StatusMux81_Sel

	constant EXECUTE_R			:std_logic_vector(4 downto 0) := "10"&"00"&"0";
	constant EXECUTE_I			:std_logic_vector(4 downto 0) := "10"&"01"&"0";
	constant EXECUTE_B			:std_logic_vector(4 downto 0) := "00"&"00"&"0";
	constant EXECUTE_LHI		:std_logic_vector(4 downto 0) := "10"&"10"&"0";
	constant EXECUTE_JAL		:std_logic_vector(4 downto 0) := "10"&"10"&"1";
	constant EXECUTE_JALR		:std_logic_vector(4 downto 0) := "10"&"11"&"1";
	constant EXECUTE_RST		:std_logic_vector(4 downto 0) := "11"&"00"&"0";
	constant EXECUTE_NOSTATUS	:std_logic_vector(2 downto 0) := "000";
	constant AeqB_FLAG			:std_logic_vector(2 downto 0) := "111";
	constant AneqB_FLAG			:std_logic_vector(2 downto 0) := "110";
	constant AgB_FLAG			:std_logic_vector(2 downto 0) := "101";
	constant AlB_FLAG			:std_logic_vector(2 downto 0) := "100";
	constant AgeqB_FLAG			:std_logic_vector(2 downto 0) := "011";
	constant AleqB_FLAG			:std_logic_vector(2 downto 0) := "010";
	constant SIGNED_OP			:std_logic := '0';
	constant UNSIGNED_OP		:std_logic := '1';
	constant ARITM				:std_logic := '1';
	constant LOGIC				:std_logic := '0';
	

---------------------------------End CW for EXECUTE stage---------------------------------------------------------------

---------------------------------CW for MEMORY stage-----------------------------------------------------------------

--MEMORY_En,MEMORY_Rst,DATAMEM_En,DATAMEM_Rst,DATAMEM_Read_Wrn,DATAMEM_Word,DATAMEM_HalfWord,DATAMEM_Byte,DATAMEM_Unsign

	constant MEM_NOOP		:std_logic_vector((NUM_SIG_SM-1)downto 0)  := "100000000";
	constant MEM_LW			:std_logic_vector((NUM_SIG_SM-1) downto 0) := "101011000";
	constant MEM_LHW		:std_logic_vector((NUM_SIG_SM-1) downto 0) := "101010100";
	constant MEM_LB			:std_logic_vector((NUM_SIG_SM-1) downto 0) := "101010010";
	constant MEM_LBU		:std_logic_vector((NUM_SIG_SM-1) downto 0) := "101010011";
	constant MEM_LHWU		:std_logic_vector((NUM_SIG_SM-1) downto 0) := "101010101";
	constant MEM_SW			:std_logic_vector((NUM_SIG_SM-1) downto 0) := "101001000";
	constant MEM_SHW		:std_logic_vector((NUM_SIG_SM-1) downto 0) := "101000100";
	constant MEM_SB			:std_logic_vector((NUM_SIG_SM-1) downto 0) := "101000010";
	constant MEM_SBU		:std_logic_vector((NUM_SIG_SM-1) downto 0) := "101000011";
	constant MEM_SHWU		:std_logic_vector((NUM_SIG_SM-1) downto 0) := "101000101";
	constant MEM_NOTEN		:std_logic_vector((NUM_SIG_SM-1) downto 0) := "000000000";
	constant MEM_RST		:std_logic_vector((NUM_SIG_SM-1) downto 0) := "110100000";

---------------------------------End CW for MEMORY stage---------------------------------------------------------------

---------------------------------CW for WRITE BACK stage-----------------------------------------------------------------

--RF_WR,WBMux41_Sel

	constant WB_ALUR		:std_logic_vector((NUM_SIG_SWB-1)downto 0)  := "1"&"10";
	constant WB_MEMR		:std_logic_vector((NUM_SIG_SWB-1) downto 0) := "1"&"11";
	constant WB_STATUSR		:std_logic_vector((NUM_SIG_SWB-1) downto 0) := "1"&"01";
	constant WB_NO			:std_logic_vector((NUM_SIG_SWB-1) downto 0) := "0"&"00";

---------------------------------End CW for WRITE BACK stage------------------------------------------------------------

--------------------------------RESET_CW--------------------------------------------------------------------------------

constant RESET_CW :std_logic_vector((CW_SIZE-1) downto 0) :=	 						RST_FATCH & DECODE_RST & EXECUTE_RST & ADDcode & SIGNED_OP & LOGIC & EXECUTE_NOSTATUS & MEM_RST & WB_NO;

--------------------------------CW for RTYPE instructions------------------------------------------------------------
 
constant CW_RTYPE_ADD: std_logic_vector((CW_SIZE-1) downto 0):=							NORM_FATCH & DECODE_R & EXECUTE_R & ADDcode & SIGNED_OP & LOGIC & EXECUTE_NOSTATUS & MEM_NOOP & WB_ALUR;

constant CW_RTYPE_AND: std_logic_vector((CW_SIZE-1) downto 0):=							NORM_FATCH & DECODE_R & EXECUTE_R & ANDcode & SIGNED_OP & LOGIC & EXECUTE_NOSTATUS & MEM_NOOP & WB_ALUR;

constant CW_RTYPE_OR: std_logic_vector((CW_SIZE-1) downto 0):=							NORM_FATCH & DECODE_R & EXECUTE_R & ORcode & SIGNED_OP & LOGIC & EXECUTE_NOSTATUS & MEM_NOOP & WB_ALUR;

constant CW_RTYPE_SGE: std_logic_vector((CW_SIZE-1) downto 0):=							NORM_FATCH & DECODE_R & EXECUTE_R & SUBcode & SIGNED_OP & LOGIC & AgeqB_FLAG & MEM_NOOP & WB_STATUSR;

constant CW_RTYPE_SLE: std_logic_vector((CW_SIZE-1) downto 0):=							NORM_FATCH & DECODE_R & EXECUTE_R & SUBcode & SIGNED_OP & LOGIC & AleqB_FLAG & MEM_NOOP & WB_STATUSR;

constant CW_RTYPE_SLL: std_logic_vector((CW_SIZE-1) downto 0):=							NORM_FATCH & DECODE_R & EXECUTE_R & SHIFTLcode & SIGNED_OP & LOGIC & EXECUTE_NOSTATUS & MEM_NOOP & WB_ALUR;

constant CW_RTYPE_SNE: std_logic_vector((CW_SIZE-1) downto 0):=							NORM_FATCH & DECODE_R & EXECUTE_R & SUBcode & SIGNED_OP & LOGIC & AneqB_FLAG & MEM_NOOP & WB_STATUSR;

constant CW_RTYPE_SRL: std_logic_vector((CW_SIZE-1) downto 0):=							NORM_FATCH & DECODE_R & EXECUTE_R & SHIFTRcode & SIGNED_OP & LOGIC & EXECUTE_NOSTATUS & MEM_NOOP & WB_ALUR;

constant CW_RTYPE_SUB: std_logic_vector((CW_SIZE-1) downto 0):=							NORM_FATCH & DECODE_R & EXECUTE_R & SUBcode & SIGNED_OP & LOGIC & EXECUTE_NOSTATUS & MEM_NOOP & WB_ALUR;

constant CW_RTYPE_XOR: std_logic_vector((CW_SIZE-1) downto 0):=							NORM_FATCH & DECODE_R & EXECUTE_R & XORcode & SIGNED_OP & LOGIC & EXECUTE_NOSTATUS & MEM_NOOP & WB_ALUR;

constant CW_RTYPE_ADDU: std_logic_vector((CW_SIZE-1) downto 0):=						NORM_FATCH & DECODE_R & EXECUTE_R & ADDcode & UNSIGNED_OP & LOGIC & EXECUTE_NOSTATUS & MEM_NOOP & WB_ALUR;

constant CW_RTYPE_SEQ: std_logic_vector((CW_SIZE-1) downto 0):=							NORM_FATCH & DECODE_R & EXECUTE_R & SUBcode & SIGNED_OP & LOGIC & AeqB_FLAG & MEM_NOOP & WB_STATUSR;

constant CW_RTYPE_SGEU: std_logic_vector((CW_SIZE-1) downto 0):=						NORM_FATCH & DECODE_R & EXECUTE_R & SUBcode & UNSIGNED_OP & LOGIC & AgeqB_FLAG & MEM_NOOP & WB_STATUSR;

constant CW_RTYPE_SGT: std_logic_vector((CW_SIZE-1) downto 0):=						    NORM_FATCH & DECODE_R & EXECUTE_R & SUBcode & SIGNED_OP & LOGIC & AgB_FLAG & MEM_NOOP & WB_STATUSR;

constant CW_RTYPE_SGTU: std_logic_vector((CW_SIZE-1) downto 0):=						NORM_FATCH & DECODE_R & EXECUTE_R & SUBcode & UNSIGNED_OP & LOGIC & AgB_FLAG & MEM_NOOP & WB_STATUSR;

constant CW_RTYPE_SLT: std_logic_vector((CW_SIZE-1) downto 0):=						    NORM_FATCH & DECODE_R & EXECUTE_R & SUBcode & SIGNED_OP & LOGIC & AlB_FLAG & MEM_NOOP & WB_STATUSR;

constant CW_RTYPE_SLTU: std_logic_vector((CW_SIZE-1) downto 0):=						NORM_FATCH & DECODE_R & EXECUTE_R & SUBcode & UNSIGNED_OP & LOGIC & AlB_FLAG & MEM_NOOP & WB_STATUSR;

constant CW_RTYPE_SRA: std_logic_vector((CW_SIZE-1) downto 0):=							NORM_FATCH & DECODE_R & EXECUTE_R & SHIFTRcode & SIGNED_OP & ARITM & EXECUTE_NOSTATUS & MEM_NOOP & WB_ALUR;

constant CW_RTYPE_SUBU: std_logic_vector((CW_SIZE-1) downto 0):=						NORM_FATCH & DECODE_R & EXECUTE_R & SUBcode & UNSIGNED_OP & LOGIC & EXECUTE_NOSTATUS & MEM_NOOP & WB_ALUR;

constant CW_RTYPE_MULT: std_logic_vector((CW_SIZE-1) downto 0):=						NORM_FATCH & DECODE_R & EXECUTE_R & MULcode & SIGNED_OP & LOGIC & EXECUTE_NOSTATUS & MEM_NOOP & WB_ALUR;

constant CW_RTYPE_ROL: std_logic_vector((CW_SIZE-1) downto 0):=							NORM_FATCH & DECODE_R & EXECUTE_R & ROTATELcode & SIGNED_OP & LOGIC & EXECUTE_NOSTATUS & MEM_NOOP & WB_ALUR;

constant CW_RTYPE_ROR: std_logic_vector((CW_SIZE-1) downto 0):=							NORM_FATCH & DECODE_R & EXECUTE_R & ROTATERcode & SIGNED_OP & LOGIC & EXECUTE_NOSTATUS & MEM_NOOP & WB_ALUR;

--------------------------------End CW for RTYPE instructions--------------------------------.------------------------

-------------------------------CW for ITYPE instructions--------------------------------------------------------------

constant CW_ITYPE_ADDI:std_logic_vector((CW_SIZE-1) downto 0):=							 NORM_FATCH & DECODE_I & EXECUTE_I & ADDcode & SIGNED_OP & LOGIC & EXECUTE_NOSTATUS & MEM_NOOP & WB_ALUR;

constant CW_ITYPE_ANDI:std_logic_vector((CW_SIZE-1) downto 0):=							 NORM_FATCH & DECODE_I & EXECUTE_I & ANDcode & SIGNED_OP & LOGIC & EXECUTE_NOSTATUS & MEM_NOOP & WB_ALUR;

constant CW_ITYPE_BEQZ:std_logic_vector((CW_SIZE-1) downto 0):=							 BZ_FATCH & DECODE_B & EXECUTE_B & ADDcode & SIGNED_OP & LOGIC & EXECUTE_NOSTATUS & MEM_NOTEN & WB_NO;

constant CW_ITYPE_BNEQZ:std_logic_vector((CW_SIZE-1) downto 0):=						 BNZ_FATCH & DECODE_B & EXECUTE_B & ADDcode & SIGNED_OP & LOGIC & EXECUTE_NOSTATUS & MEM_NOTEN & WB_NO;

constant CW_ITYPE_LW:std_logic_vector((CW_SIZE-1) downto 0):=							 NORM_FATCH & DECODE_L & EXECUTE_I & ADDcode & SIGNED_OP & LOGIC & EXECUTE_NOSTATUS & MEM_LW & WB_MEMR;

constant CW_ITYPE_LHW:std_logic_vector((CW_SIZE-1) downto 0):=							 NORM_FATCH & DECODE_L & EXECUTE_I & ADDcode & SIGNED_OP & LOGIC & EXECUTE_NOSTATUS & MEM_LHW & WB_MEMR;

constant CW_ITYPE_LB:std_logic_vector((CW_SIZE-1) downto 0):=							 NORM_FATCH & DECODE_L & EXECUTE_I & ADDcode & SIGNED_OP & LOGIC & EXECUTE_NOSTATUS & MEM_LB & WB_MEMR;

constant CW_ITYPE_LHWU:std_logic_vector((CW_SIZE-1) downto 0):=							 NORM_FATCH & DECODE_L & EXECUTE_I & ADDcode & SIGNED_OP & LOGIC & EXECUTE_NOSTATUS & MEM_LHWU & WB_MEMR;

constant CW_ITYPE_LBU:std_logic_vector((CW_SIZE-1) downto 0):=							 NORM_FATCH & DECODE_L & EXECUTE_I & ADDcode & SIGNED_OP & LOGIC & EXECUTE_NOSTATUS & MEM_LBU & WB_MEMR;

constant CW_ITYPE_NOP:std_logic_vector((CW_SIZE-1) downto 0):=							 NORM_FATCH & DECODE_NOP & EXECUTE_R & ANDcode & SIGNED_OP & LOGIC & EXECUTE_NOSTATUS & MEM_NOOP & WB_ALUR;

constant CW_ITYPE_ORI:std_logic_vector((CW_SIZE-1) downto 0):=							 NORM_FATCH & DECODE_I & EXECUTE_I & ORcode & SIGNED_OP & LOGIC & EXECUTE_NOSTATUS & MEM_NOOP & WB_ALUR;

constant CW_ITYPE_SGEI:std_logic_vector((CW_SIZE-1) downto 0):=							 NORM_FATCH & DECODE_I & EXECUTE_I & SUBcode & SIGNED_OP & LOGIC & AgeqB_FLAG & MEM_NOOP & WB_STATUSR;

constant CW_ITYPE_SLEI:std_logic_vector((CW_SIZE-1) downto 0):=							 NORM_FATCH & DECODE_I & EXECUTE_I & SUBcode & SIGNED_OP & LOGIC & AleqB_FLAG & MEM_NOOP & WB_STATUSR;

constant CW_ITYPE_SLLI:std_logic_vector((CW_SIZE-1) downto 0):=							 NORM_FATCH & DECODE_I & EXECUTE_I & SHIFTLcode & SIGNED_OP & LOGIC & EXECUTE_NOSTATUS & MEM_NOOP & WB_ALUR;

constant CW_ITYPE_SNEI:std_logic_vector((CW_SIZE-1) downto 0):=							 NORM_FATCH & DECODE_I & EXECUTE_I & SUBcode & SIGNED_OP & LOGIC & AneqB_FLAG & MEM_NOOP & WB_STATUSR;

constant CW_ITYPE_SRLI:std_logic_vector((CW_SIZE-1) downto 0):=							 NORM_FATCH & DECODE_I & EXECUTE_I & SHIFTRcode & SIGNED_OP & LOGIC & EXECUTE_NOSTATUS & MEM_NOOP & WB_ALUR;

constant CW_ITYPE_SUBI:std_logic_vector((CW_SIZE-1) downto 0):=							 NORM_FATCH & DECODE_I & EXECUTE_I & SUBcode & SIGNED_OP & LOGIC & EXECUTE_NOSTATUS & MEM_NOOP & WB_ALUR;

constant CW_ITYPE_SW:std_logic_vector((CW_SIZE-1) downto 0):=							 NORM_FATCH & DECODE_R & EXECUTE_I & ADDcode & SIGNED_OP & LOGIC & EXECUTE_NOSTATUS & MEM_SW & WB_NO;

constant CW_ITYPE_SHW:std_logic_vector((CW_SIZE-1) downto 0):=							 NORM_FATCH & DECODE_R & EXECUTE_I & ADDcode & SIGNED_OP & LOGIC & EXECUTE_NOSTATUS & MEM_SHW & WB_NO;

constant CW_ITYPE_SB:std_logic_vector((CW_SIZE-1) downto 0):=							 NORM_FATCH & DECODE_R & EXECUTE_I & ADDcode & SIGNED_OP & LOGIC & EXECUTE_NOSTATUS & MEM_SB & WB_NO;

constant CW_ITYPE_SHWU:std_logic_vector((CW_SIZE-1) downto 0):=							 NORM_FATCH & DECODE_R & EXECUTE_I & ADDcode & SIGNED_OP & LOGIC & EXECUTE_NOSTATUS & MEM_SHWU & WB_NO;

constant CW_ITYPE_SBU:std_logic_vector((CW_SIZE-1) downto 0):=							 NORM_FATCH & DECODE_R & EXECUTE_I & ADDcode & SIGNED_OP & LOGIC & EXECUTE_NOSTATUS & MEM_SBU & WB_NO;

constant CW_ITYPE_XORI:std_logic_vector((CW_SIZE-1) downto 0):=							 NORM_FATCH & DECODE_I & EXECUTE_I & XORcode & SIGNED_OP & LOGIC & EXECUTE_NOSTATUS & MEM_NOOP & WB_ALUR;

constant CW_ITYPE_ADDUI:std_logic_vector((CW_SIZE-1) downto 0):=						 NORM_FATCH & DECODE_I & EXECUTE_I & ADDcode & UNSIGNED_OP & LOGIC & EXECUTE_NOSTATUS & MEM_NOOP & WB_ALUR;

constant CW_ITYPE_SEQI:std_logic_vector((CW_SIZE-1) downto 0):=							 NORM_FATCH & DECODE_I & EXECUTE_I & SUBcode & SIGNED_OP & LOGIC & AeqB_FLAG & MEM_NOOP & WB_STATUSR;

constant CW_ITYPE_SGEUI:std_logic_vector((CW_SIZE-1) downto 0):=						 NORM_FATCH & DECODE_I & EXECUTE_I & SUBcode & UNSIGNED_OP & LOGIC & AgeqB_FLAG & MEM_NOOP & WB_STATUSR;

constant CW_ITYPE_SGTI:std_logic_vector((CW_SIZE-1) downto 0):=						     NORM_FATCH & DECODE_I & EXECUTE_I & SUBcode & SIGNED_OP & LOGIC & AgB_FLAG & MEM_NOOP & WB_STATUSR;

constant CW_ITYPE_SGTUI:std_logic_vector((CW_SIZE-1) downto 0):=						 NORM_FATCH & DECODE_I & EXECUTE_I & SUBcode & UNSIGNED_OP & LOGIC & AgB_FLAG & MEM_NOOP & WB_STATUSR;

constant CW_ITYPE_SLTI:std_logic_vector((CW_SIZE-1) downto 0):=						     NORM_FATCH & DECODE_I & EXECUTE_I & SUBcode & SIGNED_OP & LOGIC & AlB_FLAG & MEM_NOOP & WB_STATUSR;

constant CW_ITYPE_SLTUI:std_logic_vector((CW_SIZE-1) downto 0):=						 NORM_FATCH & DECODE_I & EXECUTE_I & SUBcode & UNSIGNED_OP & LOGIC & AlB_FLAG & MEM_NOOP & WB_STATUSR;

constant CW_ITYPE_SRAI:std_logic_vector((CW_SIZE-1) downto 0):=							 NORM_FATCH & DECODE_I & EXECUTE_I & SHIFTRcode & SIGNED_OP & ARITM & EXECUTE_NOSTATUS & MEM_NOOP & WB_ALUR;

constant CW_ITYPE_SUBUI:std_logic_vector((CW_SIZE-1) downto 0):=						 NORM_FATCH & DECODE_I & EXECUTE_I & SUBcode & UNSIGNED_OP & LOGIC & EXECUTE_NOSTATUS & MEM_NOOP & WB_ALUR;

constant CW_ITYPE_LHI:std_logic_vector((CW_SIZE-1) downto 0):=						 	 NORM_FATCH & DECODE_I & EXECUTE_LHI & ADDcode & UNSIGNED_OP & LOGIC & EXECUTE_NOSTATUS & MEM_NOOP & WB_ALUR;

constant CW_ITYPE_ROLI:std_logic_vector((CW_SIZE-1) downto 0):=							 NORM_FATCH & DECODE_I & EXECUTE_I & ROTATELcode & SIGNED_OP & LOGIC & EXECUTE_NOSTATUS & MEM_NOOP & WB_ALUR;

constant CW_ITYPE_RORI:std_logic_vector((CW_SIZE-1) downto 0):=							 NORM_FATCH & DECODE_I & EXECUTE_I & ROTATERcode & SIGNED_OP & LOGIC & EXECUTE_NOSTATUS & MEM_NOOP & WB_ALUR;

-------------------------------End CW for ITYPE instructions----------------------------------------------------------


-------------------------------CW for JTYPE instructions--------------------------------------------------------------

constant CW_JTYPE_JABS:std_logic_vector((CW_SIZE-1) downto 0):= 							J_FATCH & DECODE_JABS & EXECUTE_B & ADDcode & SIGNED_OP & LOGIC & EXECUTE_NOSTATUS & MEM_NOTEN & WB_NO;

constant CW_JTYPE_JAL: std_logic_vector((CW_SIZE-1) downto 0):= 							J_FATCH & DECODE_JAL & EXECUTE_JAL & ADDcode & SIGNED_OP & LOGIC & EXECUTE_NOSTATUS & MEM_NOOP & WB_ALUR;

constant CW_JTYPE_JR:std_logic_vector((CW_SIZE-1) downto 0):= 								BNZ_FATCH & DECODE_B & EXECUTE_B & ADDcode & SIGNED_OP & LOGIC & EXECUTE_NOSTATUS & MEM_NOTEN & WB_NO;

constant CW_JTYPE_JALR:std_logic_vector((CW_SIZE-1) downto 0):= 							BNZ_FATCH & DECODE_JARL & EXECUTE_JALR & ADDcode & SIGNED_OP & LOGIC & EXECUTE_NOSTATUS & MEM_NOOP & WB_ALUR;

-------------------------------End CW for JTYPE instructions-----------------------------------------------------------


end global;
