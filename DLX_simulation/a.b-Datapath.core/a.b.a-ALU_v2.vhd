library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use work.global.all;
use work.functions.all;

entity ALU_v2 is
generic (Nbit: integer:= Nbit);
port (
        A:          in std_logic_vector ((Nbit-1) downto 0);
		B:          in std_logic_vector ((Nbit-1) downto 0);
		ALUsel:     in std_logic_vector ((NALUop-1) downto 0);
		unsign:	    in std_logic;
		arith_logN:  in std_logic;
		ALUout:     out std_logic_vector ((Nbit-1) downto 0);
        AeqB:       out std_logic;
        AnoteqB:    out std_logic;
        AgB:        out std_logic;
        AlB:        out std_logic;
        AgeqB:      out std_logic;
        AleqB:      out std_logic);
end ALU_v2;

architecture Structure of ALU_v2 is

signal sumnsub: std_logic;
signal Carry:   std_logic;
signal AgBout:   std_logic;
signal AlBout:   std_logic;
signal AeqBout:   std_logic;
signal AnoteqBout:   std_logic;
signal AgeqBout:   std_logic;
signal AleqBout:   std_logic;
signal enMUL:   std_logic;
signal enADDSUB:    std_logic;
signal enLOGIC: std_logic;
signal enSHIFTER: std_logic;
signal Shift_Rotaten: std_logic;
signal Right_LeftN: std_logic;
signal complete: std_logic;
signal Binshift: std_logic_vector(4 downto 0);
signal AinMUL: std_logic_vector ((Nbit/2-1) downto 0);
signal BinMUL: std_logic_vector ((Nbit/2-1) downto 0);
signal AinADDSUB: std_logic_vector ((Nbit-1) downto 0);
signal BinADDSUB: std_logic_vector ((Nbit-1) downto 0);
signal AinLOGIC: std_logic_vector ((Nbit-1) downto 0);
signal BinLOGIC: std_logic_vector ((Nbit-1) downto 0);
signal AinSHIFTER: std_logic_vector ((Nbit-1) downto 0);
signal BinSHIFTER: std_logic_vector ((Nbit-1) downto 0);
signal MULout: std_logic_vector ((Nbit-1) downto 0);
signal ADDSUBout: std_logic_vector ((Nbit-1) downto 0);
signal SHIFTERout: std_logic_vector ((Nbit-1) downto 0);
signal notAout: std_logic_vector ((Nbit-1) downto 0);
signal notBout: std_logic_vector ((Nbit-1) downto 0);
signal AandBout: std_logic_vector ((Nbit-1) downto 0);
signal AorBout: std_logic_vector ((Nbit-1) downto 0);
signal AxorBout: std_logic_vector ((Nbit-1) downto 0);
signal AnandBout: std_logic_vector ((Nbit-1) downto 0);
signal AnorBout: std_logic_vector ((Nbit-1) downto 0);
signal AxnorBout: std_logic_vector ((Nbit-1) downto 0);

component bidir_shift_rot_N_interface is
generic (Nbit: integer := Nbit); 
port (
		data_in		:	in std_logic_vector(Nbit-1 downto 0);
		moves		:	in std_logic_vector(log2_N(Nbit)-1 downto 0);
		tot		:	in std_logic;
		shift_rotN	:	in std_logic;
		right_leftN	:	in std_logic;
		arith_logN	:	in std_logic;
		data_out	: 	out std_logic_vector(Nbit-1 downto 0));
end component;

component AddSubN is
generic (Nbit : integer := Nbit );
port	( 	
			A       :		in std_logic_vector (Nbit-1 DOWNTO 0);
            B       :		in std_logic_vector (Nbit-1 DOWNTO 0);
            addnsub :       in std_logic;
            S       :		out std_logic_vector (Nbit-1 DOWNTO 0);
            Cout    :		out std_logic);
end component;

component Comp is
generic ( Nbit: integer:= 32);
port (
		signA	: in std_logic;
        signB	: in std_logic;
        Diff	: in std_logic_vector ((Nbit-1) downto 0);
        Carry	: in std_logic;
	    unsign	: in std_logic;
        AgB     : out std_logic;
        AeqB	: out std_logic;
        AnoteqB : out std_logic;
        AlB     : out std_logic;
        AgeqB	: out std_logic;
        AleqB	: out std_logic);
end component;

component LogicFun_v2 is
generic (Nbit :integer := Nbit);
port (
        A:      in	std_logic_vector((Nbit-1) downto 0);
        B:      in	std_logic_vector((Nbit-1) downto 0);
        notA:   out std_logic_vector((Nbit-1) downto 0);
        notB:   out std_logic_vector((Nbit-1) downto 0);
        AandB:  out std_logic_vector((Nbit-1) downto 0);
        AorB:   out std_logic_vector((Nbit-1) downto 0);
        AxorB:  out std_logic_vector((Nbit-1) downto 0);
        AnandB: out std_logic_vector((Nbit-1) downto 0);
        AnorB:  out std_logic_vector((Nbit-1) downto 0);
        AxnorB: out std_logic_vector((Nbit-1) downto 0));
end component;

component BoothMulWallace is
generic (Nbit : 	integer := Nbit );
port (        
    	a   : in  std_logic_vector(Nbit/2-1 downto 0);
		b	: in  std_logic_vector(Nbit/2-1 downto 0);
    	p	: out std_logic_vector(Nbit-1 downto 0));
end component;
	
begin

        AeqB <= AeqBout;
        AnoteqB <= AnoteqBout;
        AgB <= AgBout;
        AlB <= AlBout;
        AgeqB <= AgeqBout;
        AleqB <= AleqBout;

inputgenMUL:   	for i in 0 to (Nbit/2-1) generate
                	AinMUL(i) <= A(i) and enMUL;
                	BinMUL(i) <= B(i) and enMUL;
				end generate;

inputgen:   for i in 0 to (Nbit-1) generate
                AinADDSUB(i) <= A(i) and enADDSUB;
                BinADDSUB(i) <= B(i) and enADDSUB;
                AinSHIFTER(i) <= A(i) and enSHIFTER;
                BinSHIFTER(i) <= B(i) and enSHIFTER;
                AinLOGIC(i) <= A(i) and enLOGIC;
                BinLOGIC(i) <= B(i) and enLOGIC;
            end generate;

MUL:		BoothMulWallace port map (AinMUL,BinMUL,MULout);

ADDSUB:     AddSubN port map (AinADDSUB,BinADDSUB,sumnsub,ADDSUBout,Carry);

COMPLog:	Comp port map (AinADDSUB(Nbit-1),BinADDSUB(Nbit-1),ADDSUBout,Carry,unsign,AgBout,AeqBout,AnoteqBout,AlBout,AgeqBout,AleqBout);

LOGICunit:  LogicFun_v2 port map (AinLOGIC,BinLOGIC,notAout,notBout,AandBout,AorBout,AxorBout,AnandBout,AnorBout,AxnorBout);

SHIFTER:  	bidir_shift_rot_N_interface port map (AinSHIFTER,BinSHIFT,complete,Shift_Rotaten,Right_LeftN,arith_logN,SHIFTERout);

move_num:	process (BinSHIFTER, ALUsel)
			begin
				if (((ALUsel = "1011")and(conv_integer(unsigned(BinSHIFTER)) > 31))or((ALUsel = "1100")and(conv_integer(unsigned(BinSHIFTER)) > 31))) then
					Binshift <= "00000";
					complete <= '1';
				else
					Binshift <= BinSHIFTER(log2_N(Nbit)-1 downto 0);
					complete <= '0';
				end if;
			end process;

OUTgen:     process (A,B,ALUsel,ADDSUBout,sumnsub,SHIFTERout,MULout, notAout,notBout,AandBout,AorBout,AxorBout,AnandBout,AnorBout,AxnorBout)
            begin
                case (conv_integer(unsigned(ALUsel))) is
                        when (conv_integer(unsigned(ADDcode))) =>
                                ALUout <= ADDSUBout;
                                sumnsub <= '0';
                                enADDSUB <='1';
                                enMUL <=  '0';
                                enLOGIC <= '0';
								enSHIFTER <= '0';
                                Shift_Rotaten <= '0';
								Right_LeftN <= '0';
                        when (conv_integer(unsigned(SUBcode))) =>
                                ALUout <= ADDSUBout;
                                sumnsub <= '1';
                                enADDSUB <='1';
                                enMUL <=  '0';
                                enLOGIC <= '0';
								enSHIFTER <= '0';
                                Shift_Rotaten <= '0';
								Right_LeftN <= '0';
                        when (conv_integer(unsigned(MULcode))) =>
                                ALUout<= MULout;
                                enADDSUB <='0';
                                enMUL <=  '1';
                                enLOGIC <= '0';
								enSHIFTER <= '0';
                                Shift_Rotaten <= '0';
								Right_LeftN <= '0';
                        when (conv_integer(unsigned(NOTAcode))) =>
                                ALUout <= notAout;
                                sumnsub <= '0';
                                enADDSUB <='0';
                                enMUL <=  '0';
                                enLOGIC <= '1';
								enSHIFTER <= '0';
                                Shift_Rotaten <= '0';
								Right_LeftN <= '0';
                        when (conv_integer(unsigned(NOTBcode))) =>
                                ALUout <= notBout;
                                sumnsub <= '0';
                                enADDSUB <='0';
                                enMUL <=  '0';
                                enLOGIC <= '1';
								enSHIFTER <= '0';
                                Shift_Rotaten <= '0';
								Right_LeftN <= '0';
                        when (conv_integer(unsigned(ANDcode))) =>
                                ALUout <= AandBout;
                                sumnsub <= '0';
                                enADDSUB <='0';
                                enMUL <=  '0';
                                enLOGIC <= '1';
								enSHIFTER <= '0';
                                Shift_Rotaten <= '0';
								Right_LeftN <= '0';
                        when (conv_integer(unsigned(ORcode))) =>
                                ALUout <= AorBout;
                                sumnsub <= '0';
                                enADDSUB <='0';
                                enMUL <=  '0';
                                enLOGIC <= '1';
								enSHIFTER <= '0';
                                Shift_Rotaten <= '0';
								Right_LeftN <= '0';
                        when (conv_integer(unsigned(XORcode))) =>
                                ALUout <= AxorBout;
                                sumnsub <= '0';
                                enADDSUB <='0';
                                enMUL <=  '0';
                                enLOGIC <= '1';
								enSHIFTER <= '0';
                                Shift_Rotaten <= '0';
								Right_LeftN <= '0';
                        when (conv_integer(unsigned(NANDcode))) =>
                                ALUout <= AnandBout;
                                sumnsub <= '0';
                                enADDSUB <='0';
                                enMUL <=  '0';
                                enLOGIC <= '1';
								enSHIFTER <= '0';
                                Shift_Rotaten <= '0';
								Right_LeftN <= '0';
                        when (conv_integer(unsigned(NORcode))) =>
                                ALUout <= AnorBout;
                                sumnsub <= '0';
                                enADDSUB <='0';
                                enMUL <=  '0';
                                enLOGIC <= '1';
								enSHIFTER <= '0';
                                Shift_Rotaten <= '0';
								Right_LeftN <= '0';
                        when (conv_integer(unsigned(XNORcode))) =>
                                ALUout <= AxnorBout;
                                sumnsub <= '0';
                                enADDSUB <='0';
                                enMUL <=  '0';
                                enLOGIC <= '1';
								enSHIFTER <= '0';
                                Shift_Rotaten <= '0';
								Right_LeftN <= '0';
                        when (conv_integer(unsigned(SHIFTLcode))) =>
                                ALUout <= SHIFTERout;
                                sumnsub <= '0';
                                enADDSUB <='0';
                                enMUL <=  '0';
                                enLOGIC <= '0';
								enSHIFTER <= '1';
                                Shift_Rotaten <= '1';
								Right_LeftN <= '0';
						when (conv_integer(unsigned(SHIFTRcode))) =>
                                ALUout <= SHIFTERout;
                                sumnsub <= '0';
                                enADDSUB <='0';
                                enMUL <=  '0';
                                enLOGIC <= '0';
								enSHIFTER <= '1';
                                Shift_Rotaten <= '1';
								Right_LeftN <= '1';
                        when (conv_integer(unsigned(ROTATELcode))) =>
                                ALUout <= SHIFTERout;
                                sumnsub <= '0';
                                enADDSUB <='0';
                                enMUL <=  '0';
                                enLOGIC <= '0';
								enSHIFTER <= '1';
                                Shift_Rotaten <= '0';
								Right_LeftN <= '0';
						when (conv_integer(unsigned(ROTATERcode))) =>
                                ALUout <= SHIFTERout;
                                sumnsub <= '0';
                                enADDSUB <='0';
                                enMUL <=  '0';
                                enLOGIC <= '0';
								enSHIFTER <= '1';
                                Shift_Rotaten <= '0';
								Right_LeftN <= '1';
                        when others =>
                                ALUout <= ADDSUBout;
                                sumnsub <= '0';
                                enADDSUB <='1';
                                enMUL <=  '0';
                                enLOGIC <= '0';
                                enSHIFTER <= '0';
								Shift_Rotaten <= '0';
								Right_LeftN <= '0';
                end case;
            end process OUTgen;

end Structure;


