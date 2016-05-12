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
	Generic (DataSize : Natural := 8; --taille des données (en bits) 
				NbReg : Natural := 4;	 --nombre de bits pour coder les registres
				NbIns : Natural := 4);   --nombre de bits pour coder les instructions 
   Port ( CLK : in  STD_LOGIC);
end DataPath;

architecture Behavioral of DataPath is
	component Pipe
		Port ( 
			inA  : in  STD_LOGIC_VECTOR (7 downto 0);
			inB  : in  STD_LOGIC_VECTOR (7 downto 0);
			inOP : in  STD_LOGIC_VECTOR (NbIns-1 downto 0);
			inC  : in  STD_LOGIC_VECTOR (7 downto 0);
			outA : out STD_LOGIC_VECTOR (7 downto 0);
			outB : out STD_LOGIC_VECTOR (7 downto 0);
			outOP: out STD_LOGIC_VECTOR (3 downto 0);
			outC : out STD_LOGIC_VECTOR (7 downto 0);
			CLK  : in  STD_LOGIC);
	end component;
	component MemInstr
		Port ( 
			address : in  STD_LOGIC_VECTOR (7 downto 0);
			CLK  : in  STD_LOGIC;
			COUT : out STD_LOGIC_VECTOR (31 downto 0));
	end component;
	component RegBench
		Port ( 
			aA : in  STD_LOGIC_VECTOR (NbReg-1 downto 0);	
			aB : in  STD_LOGIC_VECTOR (NbReg-1 downto 0);		
			aW : in  STD_LOGIC_VECTOR (NbReg-1 downto 0);		
			W  : in  STD_LOGIC;										
			DATA: in STD_LOGIC_VECTOR (DataSize-1 downto 0);		
			RST : in STD_LOGIC;									
			CLK : in STD_LOGIC;									
			QA : out STD_LOGIC_VECTOR (DataSize-1 downto 0);		
			QB : out STD_LOGIC_VECTOR (DataSize-1 downto 0));		
	end component;
	component ALU
		Port ( 
			A : in  STD_LOGIC_VECTOR (DataSize-1 downto 0);
			B : in  STD_LOGIC_VECTOR (DataSize-1 downto 0);
			OP : in STD_LOGIC_VECTOR (NbIns-1 downto 0);
			S : buffer STD_LOGIC_VECTOR (DataSize-1 downto 0);
			C : out STD_LOGIC;
			N : out STD_LOGIC;
			Z : out STD_LOGIC;
			V : out STD_LOGIC);
	end component;
	component MemData
		Port ( 
			address : in  STD_LOGIC_VECTOR (7 downto 0);
			CIN : in  STD_LOGIC_VECTOR (DataSize-1 downto 0);		
			RW  : in  STD_LOGIC;	
			RST : in  STD_LOGIC;	
			CLK : in  STD_LOGIC;	
			COUT: out STD_LOGIC_VECTOR (DataSize-1 downto 0));
	end component;
	
	-- SIGNAUX
	signal A_MI2PLiDi: STD_LOGIC_VECTOR(DataSize-1 downto 0);
	signal A_PLiDi2PDiEx: STD_LOGIC_VECTOR(DataSize-1 downto 0);
	signal A_PDiEx2PExMem: STD_LOGIC_VECTOR(DataSize-1 downto 0);
	signal A_PExMem2PMemRe: STD_LOGIC_VECTOR(DataSize-1 downto 0);
	signal A_PMemRe2RB: STD_LOGIC_VECTOR(DataSize-1 downto 0);
	
	signal B_MI2PLiDi: STD_LOGIC_VECTOR(DataSize-1 downto 0);
	signal B_PLiDi2RB: STD_LOGIC_VECTOR(DataSize-1 downto 0);
	signal B_RB2RBMUX: STD_LOGIC_VECTOR(DataSize-1 downto 0);
	signal B_PDiEx2UAL: STD_LOGIC_VECTOR(DataSize-1 downto 0);
	signal B_RBMUX2PDiEx: STD_LOGIC_VECTOR(DataSize-1 downto 0);
	signal B_UAL2PUALMUX: STD_LOGIC_VECTOR(DataSize-1 downto 0);
	signal B_UALMUX2PExMem: STD_LOGIC_VECTOR(DataSize-1 downto 0);
	signal B_MI2PLiDi: STD_LOGIC_VECTOR(DataSize-1 downto 0);
	signal B_PLiDi2RB: STD_LOGIC_VECTOR(DataSize-1 downto 0);
	signal B_RB2RBMUX: STD_LOGIC_VECTOR(DataSize-1 downto 0);
	signal B_B_MDMUX2PMemRe: STD_LOGIC_VECTOR(DataSize-1 downto 0);
	
	signal C_MI2PLiDi: STD_LOGIC_VECTOR(DataSize-1 downto 0);
	signal C_PLiDi2RB: STD_LOGIC_VECTOR(DataSize-1 downto 0);
	signal C_RB2PDiEx: STD_LOGIC_VECTOR(DataSize-1 downto 0);
	signal C_PDiEx2UAL: STD_LOGIC_VECTOR(DataSize-1 downto 0);
	
	signal OP_MI2PLiDi: STD_LOGIC_VECTOR(DataSize-1 downto 0);
	signal OP_PLiDi2PDiEx: STD_LOGIC_VECTOR(DataSize-1 downto 0);
	signal OP_PDiEx2PExMem: STD_LOGIC_VECTOR(DataSize-1 downto 0);
	signal C_MI2PLiDi: STD_LOGIC_VECTOR(DataSize-1 downto 0);
	signal C_MI2PLiDi: STD_LOGIC_VECTOR(DataSize-1 downto 0);
	signal C_MI2PLiDi: STD_LOGIC_VECTOR(DataSize-1 downto 0);
	signal C_MI2PLiDi: STD_LOGIC_VECTOR(DataSize-1 downto 0);
	signal C_MI2PLiDi: STD_LOGIC_VECTOR(DataSize-1 downto 0);
	
begin
	-- TODO LIST
	-- [++++-]Implémentation des wire
	-- [+++++]LC à faire
	-- [+++++]MUX à faire?
	-- [+++++]MemInstr vers Pipe
	-- [-----]CLK à implémenter
	-- [-----]Package 

	--OP:
	 -- AFC (write, @W <- A) [ok]
	 -- COP (write, @W <- R(A) [
	 -- 
	 -- 
	 -- 
	 -- 
	 -- 
	MI: MemInstr port map (
		CLK <= CLK,
		COUT(31 downto 24) => OP_MI2PLiDi,	
		COUT(23 downto 16) => A_MI2PLiDi,
		COUT(15 downto  8) => B_MI2PLiDi,
		COUT( 7 downto  0) => C_MI2PLiDi);
	PLiDi: PipeLine port map (
		CLK <= CLK,
		inA  => A_MI2PLiDi,			-- MI <---A_MI2PLiDi---> PLiDi (inA)
		inB  => B_MI2PLiDi,			-- MI <---B_MI2PLiDi---> PLiDi (inB)
		inC  => C_MI2PLiDi,			-- MI <---C_MI2PLiDi---> PLiDi (inC)
		inOP => OP_MI2PLiDi,			-- MI <---OP_MI2PLiDi---> PLiDi (inOP)
		outA => A_PLiDi2PDiEx,		-- P1(outA)  <---A_PLiDi2PDiEx--> P2(inA)
		outB => B_PLiDi2RB,			-- P1(outB)  <----B_PLiDi2RB----> MUX
		outC => C_PLiDi2RB,			-- P1(outC)  <----C_PLiDi2RB----> RB(aB)
		outOP => OP_PLiDi2PDiEx);	-- P1(outOP) <--OP_PLiDi2PDiEx--> P2(inOP)
	RB : RegBench port map (
		aA => B_PLiDi2RB,				
		aB => C_PLiDi2RB,				
		QA => B_RB2RBMUX,				
		QB => C_RB2PDiEx,				
		aW => A_PMemRe2RB,
		W  => not(OP_PMemRe2LC(3) and not(OP_PMemRe2LC(2))), -- car STORE = B"1000" est la seule instruction à ne pas écrire dans les registres (1W, 0R)
		DATA => B_PMemRe2RB);
	B_RBMUX2PDiEx <=	B_PLiDi2RB when (OP = AFC) else
							B_RB2RBMUX; -- P2(inB) vaut P1(outB) si AFC, RB(QA) sinon
	PDiEx: PipeLine port map (
		CLK <= CLK,
		inA  => A_PLiDi2PDiEx,		
		inB  => B_RBMUX2PDiEx,			-- MUX    <---B_RBMUX2PDiEx--> P2(inB)
		inC  => C_RB2PDiEx,			-- RB(QB)    <----C_RB2PDiEx----> P2(inC)
		inOP => OP_PLiDi2PDiEx,		-- P1(outOP) <--OP_PLiDi2PDiEx--> P2(inOP)
		outA => A_PDiEx2PExMem,		-- P2(outA)  <--A_PDiEx2PExMem--> P3(inA)
		outB => B_PDiEx2UAL,			-- P2(outB)  <----B_PDiEx2UAL---> UAL(A)
		outC => C_PDiEx2UAL,			-- P2(outC)  <----B_PDiEx2UAL---> UAL(B)
		outOP => OP_PDiEx2PExMem);
	UAL: ALU port map (
		A => B_PDiEx2UAL,
		B => C_PDiEx2UAL,
		S => B_UAL2PUALMUX,
		OP	=> OP_PDiEx2PExMem); --on a matché les OP de l'ALU avec les OP de l'assembleur
	B_UALMUX2PExMem <= B_PDiEx2UAL when ((OP = COP) OR (OP = AFC) OR (OP = STORE) OR (OP = LOAD)) else
						 B_UAL2PUALMUX;
	PExMem: PipeLine port map (
		CLK <= CLK,
		inA  => A_PDiEx2PExMem,		-- P3(inA)  est matché avec P3(outA)
		inB  => B_PDiEx2PExMem,		-- P2
		inOP => OP_UAL2PExMem,
		outA => A_PExMem2PMemRe,		-- P3(outA) <----A_PExMem2PMemRe----> P4(inA)
		outB => B_PExMem2MD,
		outOP => OP_PExMem2PMemRe);
	B_PExMemMUX <= A_PExMem2PMemRe when (OP = STORE) else 	-- car on a STORE @i Rj
						B_PExMem2MD when (OP = LOAD);			-- car on a LOAD  Ri @j
	MD: MemData port map (
		address => B_PExMemMUX,
		CIN => B_PExMem2MD,
		COUT => B_MD2PMDMUX,
		RW => not(OP_PExMem2MemRe(3) and not(OP_PExMem2MemRe(2)))); --0W, 1R, donc STORE="1000"->'0' 
	B_MDMUX2PMemRe <= B_MD2PMDMUX when (OP = LOAD) else --on ne cherche dans la RAM que lorsqu'on LOAD
							B_PExMem2MD; --sinon on récup B en sortie du Pipe
	PMemRe: PipeLine port map (
		CLK <= CLK,
		inA  => A_PExMem2PMemRe,	-- P4(inA)  est matché avec P4(outA)
		inB  => B_MDMUX2PMemRe,
		inOP => OP_PExMem2PMemRe,
		outA => A_PMemRe2RB,			-- P4(outA) <----PMemRe2RB----> RB(aW) --on passe outA en adresse écriture de l'ALU
		outB => B_PMemRe2RB,
		outOP => OP_PMemRe2LC);
end Behavioral;

