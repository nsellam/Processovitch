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
		generic(Size : Positive := (DataSize*2));
	Port (A : in  WORD;
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
	signal A11 : STD_LOGIC_VECTOR(DataSize downto 0);	--taille 9bits
	signal B11 : STD_LOGIC_VECTOR(DataSize downto 0);	--taille 9bits
	signal S11 : STD_LOGIC_VECTOR(DataSize downto 0);	--taille 9bits
	signal MegaS : STD_LOGIC_VECTOR(Size-1 downto 0);		--taille 16bits
	constant ZEROS : STD_LOGIC_VECTOR(Size-1 downto 0) := (others => '0'); --taille 16bits
begin
	A11 <= '0' & A;		-- [0|aaaa|aaaa] permet de détecter les débordements sur le MSB
	B11 <= '0' & B;
	
	S <= (A AND B) when (OP = ET) else 		-- si ET, S vaut A&B
		  (A OR B) when (OP = OU) else		-- si OU, S vaut A|B
		  (A XOR B) when (OP = XOU) else		-- si XOU, S vaut AxorB
		  (NOT A) when (OP = NON) else		-- si NON, S vaut notA
		  A(DataSize-1) & A(DataSize-1 downto 1) when (OP = LSR) else	-- si LSR, S vaut le bit de MSB de A + les 7 bits de MSB de A
		  S11(DataSize-1 downto 0);			-- sinon, S vaut les 8 bits de poids faible de S11

	S11 <= A(DataSize-1 downto 0) & '0' when (OP = LSL) else -- si LSL, S vaut les 7 bits de LSB de A + '0'
			 A11 + B11 when (OP = ADD) else 	-- si ADD, S11 vaut A11+B11, le MSB de S11 vaudra 1 s'il y a débordement
			 A11 - B11 when (OP = SUB) else 	-- si SUB, S11 vaut A11-B11, le MSB de S11 vaudra 1 si négatif, ex : 0xFF pour -1
			 MegaS(DataSize downto 0);			-- sinon, S vaut les 9 bits de poids faible de MegaS

	MegaS <= A * B when (OP = MUL) else		-- MegaS(16 bits) <- A(8bits) * B(8bits)
				ZEROS;								-- dans tous les autres cas, on renvoie 0 (entre autres, le NOP)


		-- Gestion des Flags
	V <= '1' when ((OP = ADD AND S11(DataSize) = '1') or 	-- Overflow si l'addition fait déborder S11 [1|ssss|ssss]
					  (OP = MUL AND (not(MegaS(Size-1 downto DataSize) = X"00"))))	-- Overflow si la multiplication fait déborder MegaS [01|ssss|ssss]
					  else '0';											-- sinon pas d'overflow
	C <= '1' when (OP = ADD AND S11(DataSize) = '1') or	-- Carry si l'addition fait déborder S11 [1|ssss|ssss]
					  (OP = LSL AND S11(DataSize) = '1') 		-- Carry si le décalage à gauche fait déborder S11 [1|ssss|sss0]
					  else '0';											-- sinon pas de carry
	N <= '1' when (OP = SUB AND S11(DataSize) = '1') else '0'; 	--Neg si la soustraction fait déborder S11 
	Z <= '1' when ((S OR ZERO) = 0) else '0';				  	--à confirmer avec le prof : 0xFE + 0x02 = 0x00? (on lève le flag?)

end Behavioral;

