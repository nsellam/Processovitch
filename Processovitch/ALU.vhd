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
use WORK.ProcessorPack.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ALU is
    Port ( A : in  WORD;
           B : in  WORD;
           OP : in OPT;
           S : buffer WORD; --S est de type buffer : c'est un out qu'on peut aussi passer en paramètre (voir Z)
           C : out STD_LOGIC;
           N : out STD_LOGIC;
           Z : out STD_LOGIC;
           V : out STD_LOGIC);
end ALU;

architecture Behavioral of ALU is
	-- signaux à DataSize+1 pour vérifier les débordements
	signal A11 : STD_LOGIC_VECTOR(DataSize downto 0);
	signal B11 : STD_LOGIC_VECTOR(DataSize downto 0);
	signal S11 : STD_LOGIC_VECTOR(DataSize downto 0);
	constant ZERO11 : STD_LOGIC_VECTOR(DataSize downto 0) := '0' & ZERO; -- à check
begin
	A11 <= '0' & A;		-- [0|aaaa|aaaa] permet de détecter les débordements sur le MSB
	B11 <= '0' & B;
	
	S <= (A AND B) when (OP = ET) else 		-- si ET, S vaut A&B
		  (A OR B) when (OP = OU) else		-- si OU, S vaut A|B
		  (A XOR B) when (OP = XOU) else		-- si XOU, S vaut AxorB
		  (NOT A) when (OP = NON) else		-- si NON, S vaut notA
		  S11(DataSize-1 downto 0);			-- sinon, S vaut les 8 bits de poids faible de S11

	V <= '1' when (OP = ADD AND S11(DataSize) = '1') else '0';	--Overflow si l'addition fait déborder S11 [1|ssss|ssss]
	C <= '1' when (OP = ADD AND S11(DataSize) = '1') else '0';	--idem
	N <= '1' when (OP = SUB AND S11(DataSize) = '1') else '0'; 	--Neg si la soustraction fait déborder S11 
	Z <= '1' when ((S OR ZERO) = 0) else '0';				  			--à confirmer avec le prof : 0xFE + 0x02 = 0x00? (on lève le flag?)
	
	S11 <= A11 + B11 when (OP = ADD) else 	-- si ADD, S11 vaut A11+B11, le MSB de S11 vaudra 1 s'il y a débordement
			 A11 - B11 when (OP = SUB) else 	-- si SUB, S11 vaut A11-B11, le MSB de S11 vaudra 1 si négatif, ex : 0b1111_1111 pour -1
			 B"0_0000_0000";						-- dans tous les autres cas, on renvoie 0 (entre autres, le NOP)
end Behavioral;

