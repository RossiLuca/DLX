library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.global.all;
use work.functions.all;

entity datapath is
	generic ( 	Nbit: integer := Nbit;
			---Instruction Memory constants------
			RAM_DEPTH: integer:=RAM_DEPTH;
			I_SIZE: integer:= I_SIZE;
			---Data Memory constants-------
			DATA_MEM_SIZE: integer:= DATA_MEM_SIZE;
			---ALU constants---------------
			Nlogicfun: integer:= Nlogicfun;
			NALUop:	integer:= NALUop);
	port (
			Rst: 	in std_logic;
			Clk: 	in std_logic;
			Inst: 	out std_logic_vector((I_SIZE-1) downto 0);
			BrNZ: 	out std_logic;
			BrZ : 	out std_logic;
			BranchInst: in std_logic;
			StoreInst: in std_logic;
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

end datapath;

architecture Structure of datapath is

----Stage signals-----------
signal FATCH_Rst: std_logic;

----------------------------------FATCH STAGE SIGNALS--------------------------------
----storeFF signals----------
signal StoreInstDel: std_logic;
signal NStoreInstDel: std_logic;
signal StoreInstEX: std_logic;
signal StoreInstMEM: std_logic;
----PC signals--------------
signal PC_Rst: std_logic;
signal PC_En: std_logic;
signal PC_New: std_logic_vector((RAM_DEPTH+1) downto 0);
--signal PC_In: std_logic_vector((RAM_DEPTH+1) downto 0);
signal PC_Datapath: std_logic_vector((RAM_DEPTH+1) downto 0);
signal PC_Now: std_logic_vector((RAM_DEPTH+1) downto 0);
signal PC_Actual: std_logic_vector((RAM_DEPTH+1) downto 0);
signal PC_Inst: std_logic_vector((RAM_DEPTH-1) downto 0);
signal PC_Next: std_logic_vector((RAM_DEPTH+1) downto 0);
signal PC_Up: std_logic_vector((RAM_DEPTH+1) downto 0);
signal PC_Branch: std_logic_vector((RAM_DEPTH+1) downto 0);
signal PC_BranchAdd: std_logic_vector((RAM_DEPTH+1) downto 0);
signal Four: std_logic_vector((RAM_DEPTH+1) downto 0):="00000000000000000000000000000100";
signal One:  std_logic_vector((RAM_DEPTH+1) downto 0):="00000000000000000000000000000001";
signal Thirtyone: std_logic_vector((ADDR_REG_SIZE-1) downto 0):="11111";
signal PCMux_Sel: std_logic;
signal PC_Branch_Del: std_logic_vector((RAM_DEPTH+1) downto 0);
signal JumpAddr: std_logic_vector((RAM_DEPTH+1) downto 0);
signal Branch_DO: std_logic;
signal JRInst: std_logic;
signal JRInst_Del: std_logic;
signal Jump_DO : std_logic;
signal FATCHRst_DO: std_logic;
-----LHIInst Signals----------------
signal LHIInst_DEC: std_logic;
signal LHIInst_EXE: std_logic;
signal LHI_Num: std_logic_vector ((Nbit-1) downto 0);
-----IRAM Signals----------------
--signal IRAM_Rst: std_logic;
signal IRAM_Addr: std_logic_vector((RAM_DEPTH-1) downto 0);
signal Addr_IRAM: std_logic_vector((RAM_DEPTH-1) downto 0);
-----IRREG Signals---------------
signal IRReg_Rst: std_logic;
signal IRReg_En: std_logic;
signal New_Inst: std_logic_vector((I_SIZE-1) downto 0);
signal IRReg_Out: std_logic_vector((I_SIZE-1) downto 0);
signal IRReg_0_Out: std_logic_vector((I_SIZE-1) downto 0);
----NPCReg signals---------------
signal NPCReg_En: std_logic;
signal NPCReg_Rst: std_logic;
signal NPCReg_Out: std_logic_vector((RAM_DEPTH+1) downto 0);
--signal NPCReg_0_Out: std_logic_vector((RAM_DEPTH+1) downto 0);
signal PC_Ret_Del: std_logic_vector((RAM_DEPTH+1) downto 0);

--------------------------------DECODE STAGE SIGNALS----------------------------------
----RF signals-------------------
signal RF_AddrR1: std_logic_vector((ADDR_REG_SIZE-1) downto 0);
signal RF_AddrWR: std_logic_vector((ADDR_REG_SIZE-1) downto 0);
signal RF_AddrR2: std_logic_vector((ADDR_REG_SIZE-1) downto 0);
signal RF_AddrR3: std_logic_vector((ADDR_REG_SIZE-1) downto 0);
signal RF_AddrRD1: std_logic_vector((ADDR_REG_SIZE-1) downto 0);
signal RF_AddrRD2: std_logic_vector((ADDR_REG_SIZE-1) downto 0);
signal RF_AddrWRR3: std_logic_vector((ADDR_REG_SIZE-1) downto 0);
signal RF_DataIn: std_logic_vector((Nbit-1) downto 0);
signal RF_Out1: std_logic_vector((Nbit-1) downto 0);
signal RF_Out2: std_logic_vector((Nbit-1) downto 0);
------Decode stage signals-----------
signal BranchZ: std_logic;
signal BranchNZ: std_logic;
-----signExtension-----------------
signal ImmediateI: std_logic_vector((IMM_SIZEI-1) downto 0);
signal ImmediateI_ex: std_logic_vector((Nbit-1) downto 0);
signal ImmediateIop_ex: std_logic_vector ((Nbit-1) downto 0);
signal ImmediateJ: std_logic_vector((IMM_SIZEJ-1) downto 0);
signal ImmediateJ_ex: std_logic_vector((Nbit-1) downto 0);
-----AReg Signals------------------
signal AReg_En: std_logic;
signal AReg_Rst: std_logic;
-----BReg Signals------------------
signal BReg_En: std_logic;
signal BReg_Rst: std_logic;
-----ImmMux21 Signals----------------
signal Immediate: std_logic_vector ((Nbit-1) downto 0);
-----ImmReg Signals------------------
signal ImmReg_En: std_logic;
signal ImmReg_Rst: std_logic;
-----RFWRAddrID Signals--------------
signal RFWRAddrID_En: std_logic;
signal RFWRAddrID_Rst: std_logic;
-----PCRetReg Signals-----------------
signal PCRetReg_En: std_logic;
signal PCRetReg_Rst: std_logic;

-----------------------------EXECUTE STAGE SIGNALS-------------------------------------
-----StatusRegEX Signals--------------
signal StatusRegEX_En: std_logic;
signal StatusRegEX_Rst: std_logic;
-----ALU signals--------------------
signal ALU_opA: std_logic_vector ((Nbit-1) downto 0);
signal ALU_opB: std_logic_vector ((Nbit-1) downto 0);
signal ALU_opImm: std_logic_vector ((Nbit-1) downto 0);
signal ALU_Out: std_logic_vector ((Nbit-1) downto 0);
signal ALU_Op1: std_logic_vector ((Nbit-1) downto 0);
signal Op1: std_logic_vector ((Nbit-1) downto 0);
signal Op2: std_logic_vector ((Nbit-1) downto 0);
signal PC_Ret: std_logic_vector ((Nbit-1) downto 0);
signal ALUReg_Out: std_logic_vector ((Nbit-1) downto 0);
signal ALU_AeqB:  std_logic;
signal ALU_AnoteqB: std_logic;
signal ALU_AgB: std_logic;
signal ALU_AlB: std_logic;
signal ALU_AgeqB: std_logic;
signal ALU_AleqB: std_logic;
signal Status: std_logic;
signal StatusMEM: std_logic;
signal StatusWB: std_logic;
-----ALUReg signals--------------------
signal ALUReg_Rst: std_logic;
signal ALUReg_En: std_logic;
-----DMEMAddrReg signals---------------
signal DMEMAddrReg_Rst: std_logic;
signal DMEMAddrReg_En: std_logic;
-----RFWRAddrEX signals----------------
signal RFWRAddrEX_Rst: std_logic;
signal RFWRAddrEX_En: std_logic;
-----Execution stage signals-----------
signal RF_WrAddr_EX: std_logic_vector((ADDR_REG_SIZE-1) downto 0);

------------------------------MEMORY STAGE SIGNALS------------------------------------
-----Data memory signals---------------
signal MEM_Addr: std_logic_vector ((Nbit-1) downto 0);
signal MEM_DataIn: std_logic_vector ((Nbit-1) downto 0);
signal MEM_DataOut: std_logic_vector ((Nbit-1) downto 0);
signal RF_WrAddr_MEM: std_logic_vector((ADDR_REG_SIZE-1) downto 0);
signal Data_MEM_Addr: std_logic_vector ((Nbit-1) downto 0);
signal Data_MEM_DataIn: std_logic_vector ((Nbit-1) downto 0);
-----StatusRegMEM signals--------------
signal StatusRegMEM_Rst: std_logic;
signal StatusRegMEM_En: std_logic;
-----LMDReg signals--------------------
signal LMDReg_Rst: std_logic;
signal LMDReg_En: std_logic;
-----WBReg signals---------------------
signal WBReg_Rst: std_logic;
signal WBReg_En: std_logic;
-----RFWRAddrMEM signals---------------
signal RFWRAddrMEM_Rst: std_logic;
signal RFWRAddrMEM_En: std_logic;

-----------------------------WRITE BACK STAGE SIGNALS----------------------------------
-----Write Back signals-----------------
signal WB_ALU: std_logic_vector ((Nbit-1) downto 0);
signal WB_MEM: std_logic_vector ((Nbit-1) downto 0);
signal WB_Status: std_logic_vector ((Nbit-1) downto 0);
signal WB_Zero: std_logic_vector((Nbit-1) downto 0):=(others => '0');
signal RF_WrAddr_WB: std_logic_vector((ADDR_REG_SIZE-1) downto 0);

component MUX21 is
port (	
		in1:	In	std_logic; --in1 when s=1
		in0:	In	std_logic; --in0 when s=0
		S:		In	std_logic;
		Y:		Out	std_logic);
end component;

component mux41 is
port (
		in3: 	in std_logic; --11
		in2: 	in std_logic; --10
		in1: 	in std_logic; --01
		in0: 	in std_logic; --00
		sel: 	in std_logic_vector(1 downto 0);
		Y: 		out std_logic);
end component;

component mux81 is
port (
		in7: 	in std_logic;
		in6: 	in std_logic;
		in5: 	in std_logic;
		in4: 	in std_logic;
		in3: 	in std_logic;
		in2: 	in std_logic;
		in1: 	in std_logic;
		in0: 	in std_logic;
		sel: 	in std_logic_vector (2 downto 0);
		Y:		out std_logic);
end component;

component mux21N is
generic (N : integer := Nbit);
port (
    	in1 : 	in  std_logic_vector(n-1 downto 0);
   		in0 :	in  std_logic_vector(n-1 downto 0);
   		S : 	in  std_logic;
    	U : 	out std_logic_vector(n-1 downto 0));
end component;

component mux41N is
generic ( Nbit:	integer:=Nbit);
port (
		in3: 	in std_logic_vector ((Nbit-1) downto 0);
		in2: 	in std_logic_vector ((Nbit-1) downto 0);
		in1: 	in std_logic_vector ((Nbit-1) downto 0);
		in0: 	in std_logic_vector ((Nbit-1) downto 0);
		sel:	in std_logic_vector (1 downto 0);
		Y: 		out std_logic_vector ((Nbit-1) downto 0));
end component;

component mux81N is
generic ( Nbit:	integer:=Nbit);
port (
		in7: 	in std_logic_vector ((Nbit-1) downto 0);
		in6: 	in std_logic_vector ((Nbit-1) downto 0);
		in5: 	in std_logic_vector ((Nbit-1) downto 0);
		in4: 	in std_logic_vector ((Nbit-1) downto 0);
		in3: 	in std_logic_vector ((Nbit-1) downto 0);
		in2: 	in std_logic_vector ((Nbit-1) downto 0);
		in1: 	in std_logic_vector ((Nbit-1) downto 0);
		in0: 	in std_logic_vector ((Nbit-1) downto 0);
		sel: 	in std_logic_vector (2 downto 0);
		Y: 		out std_logic_vector ((Nbit-1) downto 0));
end component;

component PC is
generic (RAM_DEPTH: integer := RAM_DEPTH);
port(
		PC_In	: 	in std_logic_vector ((RAM_DEPTH+1) downto 0);
		En	: 		in std_logic;
		Clk	: 		in std_logic;
		Res	: 		in std_logic;
		PC_DATAP: 	out std_logic_vector ((RAM_DEPTH+1) downto 0);
		PC_IRAM	: 	out std_logic_vector ((RAM_DEPTH-1) downto 0));
end component;

component AddSubN is
generic (Nbit : 	integer := 32 );
port(   
		A       :		in std_logic_vector (Nbit-1 DOWNTO 0);
        B       :		in std_logic_vector (Nbit-1 DOWNTO 0);
        addnsub :       in std_logic;
        S       :		out std_logic_vector (Nbit-1 DOWNTO 0);
        Cout    :		out std_logic);
end component;

component IRAM is
generic (	RAM_DEPTH : integer := RAM_DEPTH;
			I_SIZE : integer := I_SIZE);
port (
   		Rst  : in  std_logic;
    	Addr : in  std_logic_vector(RAM_DEPTH - 1 downto 0);
		Dout : out std_logic_vector(I_SIZE - 1 downto 0)
    );
end component;

component FD_EN is
port (	
		D:		In	std_logic;
		Clk:	In	std_logic;
		RESET:	In	std_logic;
		EN:		In	std_logic;
		Q:		out	std_logic);
end component;

component RegEn is
generic (Nbit : integer := Nbit);
port (
		A: 		in std_logic_vector (Nbit-1 downto 0);
		Clk: 	in std_logic;
		Reset: 	in std_logic;
		EN:		in std_logic;
		U : 	out std_logic_vector (Nbit-1 downto 0));
end component;

component RegEn_FE is
generic ( Nbit : integer := Nbit);
port (
		A: 		in std_logic_vector (Nbit-1 downto 0);
		Clk: 	in std_logic;
		Reset: 	in std_logic;
		EN:		in std_logic;
		U : 	out std_logic_vector (Nbit-1 downto 0));
end component;

component LatchEn is
generic ( Nbit : integer := Nbit);
port (
		A: 		in std_logic_vector (Nbit-1 downto 0);
		Clk: 	in std_logic;
		Reset: 	in std_logic;
		EN:		in std_logic;
		U : 	out std_logic_vector (Nbit-1 downto 0));
end component;

component register_file is
generic (Nbit: integer := Nbit);
port (
		CLK: 		in std_logic;
   		RESET:	 	in std_logic;
		ENABLE: 	in std_logic;
		RD1: 		in std_logic;
		RD2: 		in std_logic;
		WR: 		in std_logic;
		ADD_WR: 	in std_logic_vector(log2_N(Nbit)-2 downto 0);
		ADD_RD1: 	in std_logic_vector(log2_N(Nbit)-2 downto 0);
		ADD_RD2: 	in std_logic_vector(log2_N(Nbit)-2 downto 0);
		DATAIN: 	in std_logic_vector(Nbit-1 downto 0);
   		OUT1: 		out std_logic_vector(Nbit-1 downto 0);
		OUT2: 		out std_logic_vector(Nbit-1 downto 0));
end component;

component ALU_v2 is
generic (Nbit: integer:= Nbit);
port (
       	A:          in std_logic_vector ((Nbit-1) downto 0);
		B:          in std_logic_vector ((Nbit-1) downto 0);
		ALUsel:     in std_logic_vector ((NALUop-1) downto 0);
		unsign:	    in std_logic;
		arith_logN: in std_logic;
		ALUout:     out std_logic_vector ((Nbit-1) downto 0);
        AeqB:       out std_logic;
        AnoteqB:    out std_logic;
        AgB:        out std_logic;
        AlB:        out std_logic;
        AgeqB:      out std_logic;
        AleqB:      out std_logic);
end component;

component DataMemory is
generic (Nbit: integer:= Nbit;
		 DATA_MEM_SIZE: integer:= DATA_MEM_SIZE);
port (
		DataIn 	: in std_logic_vector ((Nbit-1) downto 0);
		Addr	: in std_logic_vector ((DATA_MEM_SIZE-1) downto 0);
		En		: in std_logic;
		Clk		: in std_logic;
		Rst		: in std_logic;
		Read_Wrn: in std_logic;
		Word	: in std_logic;
		HalfWord: in std_logic;
		Byte	: in std_logic;
		Unsign	: in std_logic;
		DataOut	: out std_logic_vector ((Nbit-1) downto 0));
end component;

component signExtension is
generic (	Nbitin: integer:= 11;
			Nbitout: integer:= Nbit);
port (	
		A			: in std_logic_vector((Nbitin-1) downto 0);
		Aextended	: out std_logic_vector((Nbitout-1) downto 0));
end component;

component zerotest is
generic (Nbit: integer:=Nbit);
port (	
		A: 		in std_logic_vector((Nbit-1) downto 0);
		zero: 	out std_logic);
end component;


begin

		---- FATCH Stage---------
		PC_En <= FATCH_En;
		PC_Rst<= Rst;
		NPCReg_En <= FATCH_En;
		NPCReg_Rst<= FATCH_Rst;
		IRReg_En <= FATCH_En;
		IRReg_Rst<= FATCH_Rst;
		Inst <= New_Inst;
		JRInst <= JumpRInst;
		FATCHRst_DO <= Branch_DO or JRInst_Del;
		----- DECODE Stage-------
		AReg_En <= DECODE_En;
		AReg_Rst <= DECODE_Rst;
		BReg_En <= DECODE_En;
		BReg_Rst <= DECODE_Rst;
		ImmReg_En <= DECODE_En;
		ImmReg_Rst <= DECODE_Rst;
		PCRetReg_Rst <= DECODE_Rst;
		PCRetReg_En <= DECODE_En;
		RFWRAddrID_En <= DECODE_En;
		RFWRAddrID_Rst <= DECODE_Rst;
		BranchNZ <= not BranchZ;
		BrNZ <= BranchNZ;
		BrZ <= BranchZ;
		RF_AddrR1 <= IRReg_Out(25 downto 21);
		RF_AddrR2 <= IRReg_Out(20 downto 16);
		RF_AddrR3 <= IRReg_Out(15 downto 11);
		ImmediateJ <= IRReg_0_Out(25 downto 0);
		ImmediateI <= IRReg_0_Out(15 downto 0);
		Branch_DO <= PCMux_Sel;
		NStoreInstDel <= not StoreInstDel;
		-----EXECUTE Stage---------
		ALUReg_En <= EXECUTE_En;
		ALUReg_Rst <= EXECUTE_Rst;
		DMEMAddrReg_En <=EXECUTE_En;
		DMEMAddrReg_Rst <= EXECUTE_Rst;
		RFWRAddrEX_En <= EXECUTE_En;
		RFWRAddrEX_Rst <= EXECUTE_Rst;
		StatusRegEX_En <= EXECUTE_En;
		StatusRegEX_Rst <= EXECUTE_Rst;
		LHI_Num ((Nbit-1) downto 16) <= ALU_opImm (15 downto 0);
		LHI_Num (15 downto 0) <= (others => '0');
		-----MEMORY STAGE---------------
		LMDReg_En <= MEMORY_En;
		LMDReg_Rst <= MEMORY_Rst;
		WBReg_En <= MEMORY_En;
		WBReg_Rst <= MEMORY_Rst;
		RFWRAddrMEM_En <= MEMORY_En;
		RFWRAddrMEM_Rst <= MEMORY_Rst;
		StatusRegMEM_En <= MEMORY_En;
		StatusRegMEM_Rst <= MEMORY_Rst;
		MEM_DataIn <= ALUReg_Out;
		----WRITE BACK STAGE-------------
		RF_AddrWR <= RF_WrAddr_WB;
		WB_Status(0)<=StatusWB;
		WB_Status(Nbit-1 downto 1)<= (others => '0');

-------------------Fetch Stage--------------------
BrPCNextMux21: 		mux21N generic map (RAM_DEPTH+2) port map(PC_Up,PC_Next,Branch_DO,PC_New);
PCinst:				PC port map(PC_New,PC_En,Clk,Rst,PC_Datapath,PC_Inst);
BrPCAddMux21:		mux21N generic map (RAM_DEPTH+2) port map (PC_Branch_Del,PC_Datapath,Branch_DO,PC_Now);
JumpSel: 			mux21 port map ('1',Jump,JRInst_Del,Jump_DO);
JmPCAddMux21: 		mux21N generic map (RAM_DEPTH+2) port map (PC_Branch,PC_Now,Jump_DO,PC_Actual);
PCAdd:				AddSubN port map(PC_Actual,Four,'0',PC_Up,open);
jumpRFF:			FD_EN port map(JRInst,Clk,'0','1',JRInst_Del); 
PCMux41sel:			mux41 port map(BranchNZ,BranchZ,'0','0',PCMux41_Sel,PCMux_Sel);
FATCHRstMux21:		MUX21 port map('1',Rst,FATCHRst_DO,FATCH_Rst);
BranchReg:			RegEn generic map (RAM_DEPTH+2) port map (PC_Branch,Clk,'0','1',PC_Branch_Del);
BrAddrMux21:		mux21N generic map (RAM_DEPTH+2) port map (PC_Branch_Del,PC_Branch,Branch_DO,JumpAddr);
PCMux21:			mux21N generic map(RAM_DEPTH+2) port map(JumpAddr,PC_Up,PCMux_Sel,PC_Next);
AddrIRAMMux21: 		mux21N generic map (RAM_DEPTH) port map(PC_Next(RAM_DEPTH+1 downto 2),PC_Inst,Branch_DO,IRAM_Addr);
JmAddrIRAMMux21:	mux21N generic map (RAM_DEPTH) port map(PC_Branch(RAM_DEPTH+1 downto 2),IRAM_Addr,Jump_DO,Addr_IRAM); 
IRAMinst:			IRAM port map(Rst,Addr_IRAM,New_Inst);
------------------IF/ID Stage------------------------
StoreFF:			FD_EN port map(StoreInst,Clk,FATCH_Rst,'1',StoreInstDel); 
NPCReg:				RegEn generic map (RAM_DEPTH+2) port map(PC_Next,Clk,'0',NPCReg_En,NPCReg_Out);
IRReg_0:			RegEn generic map (I_SIZE) port map(New_Inst,Clk,Rst,IRReg_En,IRReg_0_Out);
IRReg_1:			RegEn generic map (I_SIZE) port map(IRReg_0_Out,Clk,IRReg_Rst,IRReg_En,IRReg_Out);
LHIFFIF:			FD_EN port map(LHIInst,Clk,FATCH_Rst,'1',LHIInst_DEC); 
------------------Decode Stage------------------------
R1Mux21A:			mux21N generic map (ADDR_REG_SIZE) port map((others =>'0'),RF_AddrR1,R1Mux21A_Sel,RF_AddrRD1);
R2Mux21B:			mux21N generic map (ADDR_REG_SIZE) port map((others =>'0'),RF_AddrR2,R2Mux21B_Sel,RF_AddrRD2);
RWMux41WR:			mux41N generic map (ADDR_REG_SIZE) port map(Thirtyone,(others =>'0'),RF_AddrR2,RF_AddrR3,RWMux41WR_Sel,RF_AddrWRR3);
RF:					register_file port map(Clk,Rst,'1',RF_RD1,RF_RD2,RF_WR,RF_AddrWR,RF_AddrRD1,RF_AddrRD2,RF_DataIn,RF_Out1,RF_Out2);
signex16I:			signExtension generic map (IMM_SIZEI,Nbit) port map (IRReg_Out(15 downto 0),ImmediateIop_ex);
signex16:			signExtension generic map (IMM_SIZEI,Nbit) port map (ImmediateI,ImmediateI_ex);
signex26:			signExtension generic map (IMM_SIZEJ,Nbit) port map (ImmediateJ,ImmediateJ_ex);
BranchAdd:			AddSubN port map (NPCReg_Out,immediate,'0',PC_BranchAdd,open);
JRMux21:			mux21N generic map (RAM_DEPTH+2) port map(RF_Out1,PC_BranchAdd,JRInst_Del,PC_Branch);
zero:				zerotest port map(RF_Out1,BranchZ);
ImmMux21:			mux21N port map (ImmediateJ_ex,ImmediateI_ex,Jump,Immediate);
--------------------ID/EX Stage----------------------
StoreFFEX:			FD_EN port map(StoreInstDel,Clk,DECODE_Rst,'1',StoreInstEX); 
AReg:				RegEn port map(RF_Out1,Clk,AReg_Rst,AReg_En,ALU_opA);
BReg:				RegEn port map(RF_Out2,Clk,BReg_Rst,BReg_En,ALU_opB);
ImmReg:				RegEn port map(ImmediateIop_ex,Clk,ImmReg_Rst,ImmReg_En,ALU_opImm);
RFWRAddrID:			RegEn generic map (ADDR_REG_SIZE) port map(RF_AddrWRR3,Clk,RFWRAddrID_Rst,RFWRAddrID_En,RF_WrAddr_EX);
DelPCRetReg:		RegEn generic map (RAM_DEPTH+2) port map(NPCReg_Out,Clk,PCRetReg_Rst,'1',PC_Ret_Del); 
PCRetReg:			RegEn generic map (RAM_DEPTH+2) port map(PC_Ret_Del,Clk,PCRetReg_Rst,PCRetReg_En,PC_Ret);
LHIFFID:			FD_EN port map(LHIInst_DEC,Clk,DECODE_Rst,'1',LHIInst_EXE);
--------------------Execute Stage----------------------
OPAMux21:			mux21N port map(PC_Ret,ALU_opA,OPAMux21_Sel,ALU_Op1);
OPBMux41:			mux41N port map(Four,(others => '0'),ALU_opImm,ALU_opB,OPBMux41_Sel,Op2);
OPALHIMux21:		mux21N port map(LHI_Num,ALU_Op1,LHIInst_EXE,Op1);
ALU:				ALU_v2 port map(Op1,Op2,ALU_Sel,ALU_Unsign,ALU_Arith_logN,ALU_Out,ALU_AeqB,ALU_AnoteqB,ALU_AgB,ALU_AlB,ALU_AgeqB,ALU_AleqB);
StatusMux81:		mux81 port map(ALU_AeqB,ALU_AnoteqB,ALU_AgB,ALU_AlB,ALU_AgeqB,ALU_AleqB,'0','0',StatusMux81_Sel,Status);
-------------------EX/MEM Stage----------------------
StoreFFMEM:			FD_EN port map(StoreInstEX,Clk,EXECUTE_Rst,'1',StoreInstMEM); 
ALUReg:				RegEn port map(ALU_Out,Clk,ALUReg_Rst,ALUReg_En,ALUReg_Out);
DMEMAddrReg:		RegEn port map(ALU_opB,Clk,DMEMAddrReg_Rst,DMEMAddrReg_En,MEM_Addr); 
RFWRAddrEX:			RegEn generic map (ADDR_REG_SIZE) port map(RF_WrAddr_EX,Clk,RFWRAddrEX_Rst,RFWRAddrEX_En,RF_WrAddr_MEM);
StatusRegEX:		FD_EN port map(Status,Clk,StatusRegEX_Rst,StatusRegEX_En,StatusMEM);
--------------------Memory Stage------------------
SDATAMux21:			mux21N  port map(MEM_Addr,MEM_DataIn,StoreInstMEM,Data_MEM_DataIn); 
SADDMux21:			mux21N  port map(MEM_DataIn,MEM_Addr,StoreInstMEM,Data_MEM_Addr); 
DataMem:			DataMemory port map (Data_MEM_DataIn,Data_MEM_Addr((DATA_MEM_SIZE-1) downto 0),DATAMEM_En,Clk,DATAMEM_Rst,DATAMEM_Read_Wrn,DATAMEM_Word,DATAMEM_HalfWord,DATAMEM_Byte,DATAMEM_Unsign,MEM_DataOut);
-------------------MEM/WB Stage--------------------
LMDReg:				RegEn port map(MEM_DataOut,Clk,LMDReg_Rst,LMDReg_En,WB_MEM);
WBReg:				RegEn port map(ALUReg_Out,Clk,WBReg_Rst,WBReg_En,WB_ALU);
RFWRAddrMEM:  		RegEn generic map (ADDR_REG_SIZE) port map(RF_WrAddr_MEM,Clk,RFWRAddrMEM_Rst,RFWRAddrMEM_En,RF_WrAddr_WB);
StatusRegMEM:		FD_EN port map(StatusMEM,Clk,StatusRegMEM_Rst,StatusRegMEM_En,StatusWB);
-------------------Write Back Stage-----------------
WBMux41:			mux41N port map(WB_MEM,WB_ALU,WB_Status,WB_Zero,WBMux41_Sel,RF_DataIn);

end Structure;
