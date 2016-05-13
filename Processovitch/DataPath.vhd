----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:15:20 04/15/2016 
-- Design Name: 
-- Module Name:    DataPath - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use WORK.ProcessorPack.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity DataPath is
   Port (ASM : in  WORD; 
			CLK : in  STD_LOGIC);
end DataPath;

architecture Behavioral of DataPath is
	component PipeLine
		Port ( 
			inA  : in  WORD;
			inB  : in  WORD;
			inOP : in  OPT;
			inC  : in  WORD;
			outA : out WORD;
			outB : out WORD;
			outOP: out OPT;
			outC : out WORD;
			CLK  : in  STD_LOGIC);
	end component;
	component MemInstr
		Port ( 
			address : in  WORD;
			CLK  : in  STD_LOGIC;
			COUT : out INSTR);
	end component;
	component RegBench
		Port ( 
			aA : in  RegAddr;	
			aB : in  RegAddr;		
			aW : in  RegAddr;		
			W  : in  STD_LOGIC;										
			DATA: in WORD;		
			RST : in STD_LOGIC;									
			CLK : in STD_LOGIC;									
			QA : out WORD;		
			QB : out WORD);		
	end component;
	component ALU
		Port ( 
			A : in  WORD;
			B : in  WORD;
			OP : in OPT;
			S : buffer WORD;
			C : out STD_LOGIC;
			N : out STD_LOGIC;
			Z : out STD_LOGIC;
			V : out STD_LOGIC);
	end component;
	component MemData
		Port ( 
			address : in  WORD;
			CIN : in  WORD;		
			RW  : in  STD_LOGIC;	
			RST : in  STD_LOGIC;	
			CLK : in  STD_LOGIC;	
			COUT: out WORD);
	end component;
	
	-- SIGNAUX
	type inPipe is
		record
			A, B, C : WORD;
			OP: OPT;
		end record;
	type MUX is
		record
			RB, UAL, MD1, MD2 : WORD;
		end record;
	
			-- SIGNAUX
	signal inPLiDi : inPipe;
	signal inPDiEx : inPipe;
	signal inPExMem: inPipe; -- .C non utilisé
	signal inPMemRe: inPipe; -- .C non utilisé
	signal inRB: inPipe;		 -- .OP non utilisé
	signal inUAL: inPipe;	 -- .A et .OP non utilisés
	signal inMUX: MUX;		 -- B
	signal inMD: WORD;		 -- B
	signal inLC: OPT;			 -- OP
	signal inDATARB: WORD;	 -- B
	
begin
	-- TODO LIST
	-- [+++++]Implémentation des wire
	-- [+++++]LC à faire
	-- [+++++]MUX à faire?
	-- [+++++]MemInstr vers Pipe
	-- [+++++]CLK à implémenter
	-- [+++++]Package 
	-- [-----]Tests

	MI: MemInstr port map (
		address => ASM,
		CLK => CLK,
		COUT(31 downto 28) => inRB.OP, -- inRB.OP n'est de toute façon jamais utilisé
		COUT(27 downto 24) => inPLiDi.OP,	
		COUT(23 downto 16) => inPLiDi.A,
		COUT(15 downto  8) => inPLiDi.B,
		COUT( 7 downto  0) => inPLiDi.C);
	PLiDi: PipeLine port map (
		CLK => CLK,
		inA  => inPLiDi.A,			-- MI <---A_MI2PLiDi---> PLiDi (inA)
		inB  => inPLiDi.B,			-- MI <---B_MI2PLiDi---> PLiDi (inB)
		inC  => inPLiDi.C,			-- MI <---C_MI2PLiDi---> PLiDi (inC)
		inOP => inPLiDi.OP,			-- MI <---OP_MI2PLiDi---> PLiDi (inOP)
		outA => inPDiEx.A,		-- P1(outA)  <---A_PLiDi2PDiEx--> P2(inA)
		outB => inRB.B,			-- P1(outB)  <----B_PLiDi2RB----> MUX
		outC => inRB.C,			-- P1(outC)  <----C_PLiDi2RB----> RB(aB)
		outOP => inPDiEx.OP);	-- P1(outOP) <--OP_PLiDi2PDiEx--> P2(inOP)
	RB : RegBench port map (
		CLk => CLK,
		RST => '1',
		aA => inRB.B(RegCnt-1 downto 0),				
		aB => inRB.C(RegCnt-1 downto 0),				
		QA => inMUX.RB,				
		QB => inPDiEx.C,				
		aW => inRB.A(RegCnt-1 downto 0),			-- vient de P_Mem/Re
		W  => not(inLC(3) and not(inLC(2))), -- car STORE = B"1000" est la seule instruction à ne pas écrire dans les registres (1W, 0R)
		DATA => inDATARB);
	inPDiEx.B <=	inRB.B when (inPDiEx.OP = AFC) else
							inMUX.RB; -- P2(inB) vaut P1(outB) si AFC, RB(QA) sinon
	PDiEx: PipeLine port map (
		CLK => CLK,
		inA  => inPDiEx.A,		
		inB  => inPDiEx.B,			-- MUX    <---B_RBMUX2PDiEx--> P2(inB)
		inC  => inPDiEx.C,			-- RB(QB)    <----C_RB2PDiEx----> P2(inC)
		inOP => inPDiEx.OP,		-- P1(outOP) <--OP_PLiDi2PDiEx--> P2(inOP)
		outA => inPExMem.A,		-- P2(outA)  <--A_PDiEx2PExMem--> P3(inA)
		outB => inUAL.B,			-- P2(outB)  <----B_PDiEx2UAL---> UAL(A)
		outC => inUAL.C,			-- P2(outC)  <----B_PDiEx2UAL---> UAL(B)
		outOP => inPExMem.OP);
	UAL: ALU port map (
		A => inUAL.B,
		B => inUAL.C,
		S => inMUX.UAL,
		OP	=> inPExMem.OP); --on a matché les OP de l'ALU avec les OP de l'assembleur
	inPExMem.B <= inUAL.B when (
													 (inPExMem.OP = COP) OR 
													 (inPExMem.OP = AFC) OR 
													 (inPExMem.OP = STR) OR 
													 (inPExMem.OP = LDR)) else
							 inMUX.UAL;
	PExMem: PipeLine port map (
		CLK => CLK,
		inA  => inPExMem.A,		-- P3(inA)  est matché avec P3(outA)
		inB  => inPExMem.B,		-- P2
		inC  => ZERO,
		inOP => inPExMem.OP,
		outA => inPMemRe.A,		-- P3(outA) <----A_PExMem2PMemRe----> P4(inA)
		outB => inMD,
		outC => ZERO,
		outOP => inPMemRe.OP);
	inMUX.MD1 <= inPMemRe.A when (inPMemRe.OP = STR) else 	-- car on a STORE @i Rj
					 inMD when (inPMemRe.OP = LDR);			-- car on a LOAD  Ri @j
	MD: MemData port map (
		CLK => CLK,
		address => inMUX.MD1,
		CIN => inMD,
		COUT => inMUX.MD2,
		RST => '1',
		RW => not(inPMemRe.OP(3) and not(inPMemRe.OP(2)))); --0W, 1R, donc STORE="1000"->'0' 
	inPMemRe.B <= inMUX.MD2 when (inPMemRe.OP = LDR) else --on ne cherche dans la RAM que lorsqu'on LOAD
							inMD; --sinon on récup B en sortie du Pipe
	PMemRe: PipeLine port map (
		CLK => CLK,
		inA  => inPMemRe.A,	-- P4(inA)  est matché avec P4(outA)
		inB  => inPMemRe.B,
		inC  => ZERO,
		inOP => inPMemRe.OP,
		outA => inRB.A,			-- P4(outA) <----PMemRe2RB----> RB(aW) --on passe outA en adresse écriture du banc de registre
		outB => inDATARB,
		outC => ZERO,
		outOP => inLC);
end Behavioral;

