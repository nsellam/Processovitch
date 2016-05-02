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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity DataPath is
    Port ( CLK : in  STD_LOGIC);
end DataPath;

architecture Behavioral of DataPath is
	component Pipe
		Port ( 
			inA : in  STD_LOGIC_VECTOR (7 downto 0);
			inB : in  STD_LOGIC_VECTOR (7 downto 0);
			inOP : in  STD_LOGIC_VECTOR (3 downto 0);
			inC : in  STD_LOGIC_VECTOR (7 downto 0);
			outA : out  STD_LOGIC_VECTOR (7 downto 0);
			outB : out  STD_LOGIC_VECTOR (7 downto 0);
			outOP : out  STD_LOGIC_VECTOR (3 downto 0);
			outC : out  STD_LOGIC_VECTOR (7 downto 0);
			CLK : in  STD_LOGIC);
	component MemInstr
		Port ( 
			address : in  STD_LOGIC_VECTOR (7 downto 0);
			CLK  : in  STD_LOGIC;
			COUT : out STD_LOGIC_VECTOR (7 downto 0));
	end component;
	component RegBench
		Port ( 
			aA : in  STD_LOGIC_VECTOR (Nb-1 downto 0);	
			aB : in  STD_LOGIC_VECTOR (Nb-1 downto 0);		
			aW : in  STD_LOGIC_VECTOR (Nb-1 downto 0);		
			W  : in  STD_LOGIC;										
			DATA: in STD_LOGIC_VECTOR (7 downto 0);		
			RST : in STD_LOGIC;									
			CLK : in STD_LOGIC;									
			QA : out STD_LOGIC_VECTOR (7 downto 0);		
			QB : out STD_LOGIC_VECTOR (7 downto 0));		
	end component;
	component ALU
		Port ( 
			A : in  STD_LOGIC_VECTOR (Nb-1 downto 0);
			B : in  STD_LOGIC_VECTOR (Nb-1 downto 0);
			OP : in STD_LOGIC_VECTOR (MAX-1 downto 0);
			S : buffer STD_LOGIC_VECTOR (Nb-1 downto 0);
			C : out STD_LOGIC;
			N : out STD_LOGIC;
			Z : out STD_LOGIC;
			V : out STD_LOGIC);
	end component;
	component MemData
		Port ( 
			address : in  STD_LOGIC_VECTOR (7 downto 0);
			CIN : in  STD_LOGIC_VECTOR (7 downto 0);		
			RW  : in  STD_LOGIC;	
			RST : in  STD_LOGIC;	
			CLK : in  STD_LOGIC;	
			COUT: out STD_LOGIC_VECTOR (7 downto 0));
	end component;
	signal wire: TD_LOG...
begin
	-- TODO LIST
	-- [++++-]Implémentation des wire
	-- [-----]OP à faire
	-- [-----]MUX à faire?
	-- [-----]MemInstr vers Pipe
	-- [-----]CLK à implémenter
	-- [-----]Package 

	--OP:
	 -- AFC (write, @W <- A)
	 -- COP (write, @W <- R(A)
	 -- 
	 -- 
	 -- 
	 -- 
	 -- 
	--MI: MemInstr port map (
	-- bien relou à faire
	PLiDi: PipeLine port map (
		inA  => A_MI2PLiDi;			-- ?? <---A_MI2PLiDi---> PLiDi (inA)
		inB  => B_MI2PLiDi;			-- ?? <---B_MI2PLiDi---> PLiDi (inB)
		inC  => C_MI2PLiDi;			-- ?? <---C_MI2PLiDi---> PLiDi (inC)
		inOP => OP_MI2PLiDi;			-- ?? <---OP_MI2PLiDi---> PLiDi (inOP)
		outA => A_PLiDi2PDiEx;		-- outA est matché en sortie avec A_MI2PLiDi (wire)
		outB => B_PLiDi2RB;			-- P1(outB)  <----B_PLiDi2RB----> RB(aA)
		outC => C_PLiDi2RB;			-- P1(outC)  <----C_PLiDi2RB----> RB(aB)
		outOP => OP_PLiDi2PDiEx);	-- P1(outOP) <--OP_PLiDi2PDiEx--> P2(inOP)
	RB : RegBench port map (
		aA => B_PLiDi2RB;				
		aB => C_PLiDi2RB;				
		QA => B_RB2PDiEx;				
		QB => C_RB2PDiEx;				
		aW => A_PMemRe2RB;
		W  => OP_LCRe2RB;
		DATA => B_PMemRe2RB);
	B_RB2PDiEx <= 
	PDiEx: PipeLine port map (
		inA  => A_PLiDi2PDiEx;		
		inB  => B_RB2PDiEx;			-- RB(QA)    <----B_RB2PDiEx----> P2(inB)
		inC  => C_RB2PDiEx;			-- RB(QB)    <----C_RB2PDiEx----> P2(inC)
		inOP => OP_PLiDi2PDiEx;		-- P1(outOP) <--OP_PLiDi2PDiEx--> P2(inOP)
		outA => A_PDiEx2PExMem;		-- P1(outOP) <--
		outB => B_PDiEx2UAL;			-- P2(outB)  <----B_PDiEx2UAL---> UAL(A)
		outC => C_PDiEx2UAL;			-- P2(outC)  <----B_PDiEx2UAL---> UAL(B)
		outOP => OP_PDiEx2PExMem);
	UAL: ALU port map (
		A => B_PDiEx2UAL;
		B => C_PDiEx2UAL;
		S => OP_UAL2PExMem;
		OP						);
	PExMem: PipeLine port map (
		inA  => A_PDiEx2PExMem;
		inB  => B_PDiEx2PExMem;
		inOP => OP_UAL2PExMem;
		outA => A_PExMem2PMemRe;
		outB => B_PExMem2MD;
		outOP => OP_PExMem2PMemRe);
	MD: MemData port map (
		address => B_PExMem2MD;
		CIN => B_PExMem2MD;
		COUT => B_MD2PMemRe;
		RW => 			);
	PMemRe: PipeLine port map (
		inA  => A_PExMem2PMemRe;
		inB  => B_MD2PMemRe;
		inOP => OP_PExMem2PMemRe;
		outA => A_PMemRe2RB;
		outB => B_PMemRe2RB;
		outOP => OP_PMemRe2LC);
	OP_LC2RB <= not(OP_PMemRe2LC(3)); -- car STORE = B"1000" est la seule instruction à ne pas écrire dans les registres
end Behavioral;

