----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:50:03 04/08/2016 
-- Design Name: 
-- Module Name:    ALU - Behavioral 
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
use IEEE.STD_LOGIC_1164.ALL; 		--librairie des STD_LOGIC et STD_LOGIC_VECTOR
use IEEE.STD_LOGIC_UNSIGNED.ALL; --librairie des opérations (+,-,*, etc.)

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ALU is
		Generic ( Nb : Natural := 8; 					--taille des données
					 MAX : Natural := 4) ; 				--nombre de bits pour coder les instructions
    Port ( A : in  STD_LOGIC_VECTOR (Nb-1 downto 0);
           B : in  STD_LOGIC_VECTOR (Nb-1 downto 0);
           OP : in STD_LOGIC_VECTOR (MAX-1 downto 0);
           S : buffer STD_LOGIC_VECTOR (Nb-1 downto 0); --S est de type buffer : c'est un out qu'on peut aussi passer en paramètre (voir Z)
           C : out STD_LOGIC;
           N : out STD_LOGIC;
           Z : out STD_LOGIC;
           V : out STD_LOGIC);
end ALU;

architecture Behavioral of ALU is
	constant NOP : STD_LOGIC_VECTOR(MAX-1 downto 0) := B"0000";
	constant ADD : STD_LOGIC_VECTOR(MAX-1 downto 0) := B"0001";
	constant SUB : STD_LOGIC_VECTOR(MAX-1 downto 0) := B"0010";
	constant IdA : STD_LOGIC_VECTOR(MAX-1 downto 0) := B"0011";
	constant IdB : STD_LOGIC_VECTOR(MAX-1 downto 0) := B"0100";
	constant ET  : STD_LOGIC_VECTOR(MAX-1 downto 0) := B"0101";
	constant OU  : STD_LOGIC_VECTOR(MAX-1 downto 0) := B"0110";
	constant XOU : STD_LOGIC_VECTOR(MAX-1 downto 0) := B"0111";
	constant NON : STD_LOGIC_VECTOR(MAX-1 downto 0) := B"1000";
	--constant LSL : STD_LOGIC_VECTOR(MAX-1 downto 0) := B"1001";
	--constant LSR : STD_LOGIC_VECTOR(MAX-1 downto 0) := B"1010";
	constant NUL : STD_LOGIC_VECTOR(Nb-1 downto 0) := B"0000_0000";
	signal A11 : STD_LOGIC_VECTOR(Nb downto 0);
	signal B11 : STD_LOGIC_VECTOR(Nb downto 0);
	signal S11 : STD_LOGIC_VECTOR(Nb downto 0);
begin
	A11 <= '0' & A;		-- [0|aaaa|aaaa] permet de détecter les débordements sur le MSB
	B11 <= '0' & B;
	
	S <= (A AND B) when (OP = ET) else 		-- si ET, S vaut A&B
		  (A OR B) when (OP = OU) else		-- si OU, S vaut A|B
		  (A XOR B) when (OP = XOU) else		-- si XOU, S vaut AxorB
		  (NOT A) when (OP = NON) else		-- si NON, S vaut notA
		  A when (OP = IdA) else				-- si IdA, S vaut A
		  B when (OP = IdB) else				-- si IdB, S vaut B
		  S11(Nb - 1 downto 0);					-- sinon, S vaut les 8 bits de poids faible de S11

	V <= '1' when (OP = ADD AND S11(Nb) = '1') else '0'; --Overflow si l'addition fait déborder S11 [1|ssss|ssss]
	C <= '1' when (OP = ADD AND S11(Nb) = '1') else '0'; --idem
	N <= '1' when (OP = SUB AND S11(Nb) = '1') else '0'; --Neg si la soustraction fait déborder S11 
	Z <= '1' when ((S OR NUL) = 0) else '0';				  --à confirmer avec le prof : 0xFE + 0x02 = 0x00? (on lève le flag?)
	
	S11 <= A11 + B11 when (OP = ADD) else 	-- si ADD, S11 vaut A11+B11, le MSB de S11 vaudra 1 s'il y a débordement
			 A11 - B11 when (OP = SUB) else 	-- si SUB, S11 vaut A11-B11, le MSB de S11 vaudra 1 si négatif, ex : 0b1111_1111 pour -1
			 B"0_0000_0000";						-- dans tous les autres cas, on renvoie 0 (entre autres, le NOP)
end Behavioral;

