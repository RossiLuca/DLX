library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use work.functions.all;
use work.global.all;

entity ALU_v1 is
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
end ALU_v1;

architecture Structure of ALU_v1 is

signal sumnsub: std_logic;
signal Carry:   std_logic;
signal AgBout:   std_logic;
signal AlBout:   std_logic;
signal AeqBout:   std_logic;
signal AnoteqBout:   std_logic;
signal AgeqBout:   std_logic;
signal AleqBout:   std_logic;
signal Right_LeftN: std_logic;
signal Binshift: std_logic_vector(4 downto 0);
signal Shift_Rotaten: std_logic;
signal complete: std_logic;
signal comSHIFTER: std_logic_vector(1 downto 0);
signal MULout: std_logic_vector ((Nbit-1) downto 0);
signal SHIFTERout: std_logic_vector ((Nbit-1) downto 0);
signal ADDSUBout: std_logic_vector ((Nbit-1) downto 0);
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
		tot			:	in std_logic;
		shift_rotN	:	in std_logic;
		right_leftN	:	in std_logic;
		arith_logN	:	in std_logic;
		data_out	: 	out std_logic_vector(Nbit-1 downto 0));
end component;


component AddSubN is
generic (Nbit : 	integer := Nbit );
port	(   A       :		in std_logic_vector (Nbit-1 DOWNTO 0);
            B       :		in std_logic_vector (Nbit-1 DOWNTO 0);
            addnsub :       in std_logic;
            S       :		out std_logic_vector (Nbit-1 DOWNTO 0);
            Cout    :		out std_logic);
end component;

component Comp is
generic ( Nbit: integer:= 32);
port 	(
            signA	: in std_logic;
            signB	: in std_logic;
            Diff	: in std_logic_vector ((Nbit-1) downto 0);
            Carry  	: in std_logic;
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
port	(
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
generic (Nbit : 	integer := Nbit);
port	(        
    		a   : in  std_logic_vector(Nbit/2-1 downto 0);
			b	: in  std_logic_vector(Nbit/2-1 downto 0);
    		p	: out std_logic_vector(Nbit-1 downto 0));
end component;

component mux161N is
generic (Nbit:	integer:=Nbit);
port (
		in0: in std_logic_vector ((Nbit-1) downto 0);
		in1: in std_logic_vector ((Nbit-1) downto 0);
		in2: in std_logic_vector ((Nbit-1) downto 0);
		in3: in std_logic_vector ((Nbit-1) downto 0);
		in4: in std_logic_vector ((Nbit-1) downto 0);
		in5: in std_logic_vector ((Nbit-1) downto 0);
		in6: in std_logic_vector ((Nbit-1) downto 0);
		in7: in std_logic_vector ((Nbit-1) downto 0);
		in8: in std_logic_vector ((Nbit-1) downto 0);
		in9: in std_logic_vector ((Nbit-1) downto 0);
		in10: in std_logic_vector ((Nbit-1) downto 0);
		in11: in std_logic_vector ((Nbit-1) downto 0);
		in12: in std_logic_vector ((Nbit-1) downto 0);
		in13: in std_logic_vector ((Nbit-1) downto 0);
		in14: in std_logic_vector ((Nbit-1) downto 0);
		in15: in std_logic_vector ((Nbit-1) downto 0);
		sel: in std_logic_vector (3 downto 0);
		Y: out std_logic_vector ((Nbit-1) downto 0));
end component;

component mux41N is
generic ( Nbit:	integer:=Nbit);
port (
		in0: in std_logic_vector ((Nbit-1) downto 0);
		in1: in std_logic_vector ((Nbit-1) downto 0);
		in2: in std_logic_vector ((Nbit-1) downto 0);
		in3: in std_logic_vector ((Nbit-1) downto 0);
		sel: in std_logic_vector (1 downto 0);
		Y: out std_logic_vector ((Nbit-1) downto 0));
end component;
	
begin

	AeqB <= AeqBout;
    AnoteqB <= AnoteqBout;
    AgB <= AgBout;
    AlB <= AlBout;
    AgeqB <= AgeqBout;
    AleqB <= AleqBout;
	sumnsub <= ALUsel(0);
	Shift_Rotaten <= comSHIFTER(1);
	Right_LeftN <= comSHIFTER(0);
	
MUL:		BoothMulWallace port map (A(Nbit/2-1 downto 0),B(Nbit/2-1 downto 0),MULout);

ADDSUB:     AddSubN port map (A,B,sumnsub,ADDSUBout,Carry);

COMPLog:   	Comp port map (A(Nbit-1),B(Nbit-1),ADDSUBout,Carry,unsign,AgBout,AeqBout,AnoteqBout,AlBout,AgeqBout,AleqBout);

LOGICunit:  LogicFun_v2 port map (A,B,notAout,notBout,AandBout,AorBout,AxorBout,AnandBout,AnorBout,AxnorBout);

SHIFTER:    bidir_shift_rot_N_interface port map (A,Binshift,complete,Shift_Rotaten,Right_LeftN,arith_logN,SHIFTERout);

MUXout:	 	mux161N port map (ADDSUBout,ADDSUBout,MULout,notAout,notBout,AandBout,AorBout,AxorBout,AnandBout,AnorBout,AxnorBout,SHIFTERout,SHIFTERout,SHIFTERout,SHIFTERout,(others =>'0'),ALUsel,ALUout);


move_num:	process (B, ALUsel)
			begin
				if (((ALUsel = "1011")and(conv_integer(unsigned(B)) > 31))or((ALUsel = "1100")and(conv_integer(unsigned(B)) > 31))) then
					Binshift <= "00000";
					complete <= '1';
				else
					Binshift <= B(log2_N(Nbit)-1 downto 0);
					complete <= '0';
				end if;
			end process;

shift_proc:	process(ALUsel)
			begin
				case (ALUsel) is
					when "1011" => comSHIFTER <= "10";
					when "1100" => comSHIFTER <= "11";
					when "1101" => comSHIFTER <= "00";
					when "1110" => comSHIFTER <= "01";
					when others => comSHIFTER <= "ZZ";
				end case;
			end process;

end Structure;


