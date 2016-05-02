----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:10:33 04/11/2016 
-- Design Name: 
-- Module Name:    MemInstr - Behavioral 
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

entity MemInstr is
    Port ( address : in  STD_LOGIC_VECTOR (7 downto 0);
           CLK  : in  STD_LOGIC;
           COUT : out  STD_LOGIC_VECTOR (7 downto 0));
end MemInstr;

architecture Behavioral of MemInstr is
	type MATRIX is array(0 to 255) of std_logic_vector(7 downto 0);	--type matrice 256x8, créée pour modéliser la ROM, c'est un tableau de 256 mots de 8bits
	signal ROM : MATRIX;																--notre ROM
begin
	InstructionMemory : process (CLK)
	begin
		if rising_edge(CLK) then
			COUT <= ROM(CONV_INTEGER(signed(address)));			--on passe l'adresse en paramètre de la ROM pour accéder à la ligne en question (l'adresse étant sous forme 0b0001, on la cast en int)
		end if;
	end process;
end Behavioral;

