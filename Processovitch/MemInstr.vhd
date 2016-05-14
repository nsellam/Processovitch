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
use IEEE.STD_LOGIC_ARITH.ALL;
use WORK.ProcessorPack.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MemInstr is
    Port ( address : in  WORD;
           CLK  : in  STD_LOGIC;
           COUT : out  INSTR);
end MemInstr;

architecture Behavioral of MemInstr is	
begin

			-- INSTRUCTIONS
	ROM(0) <= X"06_00_5C_99";
	ROM(1) <= X"05_02_00_07";
	ROM(2) <= X"06_00_8E_CF";
	ROM(3) <= X"01_01_00_02";
	ROM(4) <= X"03_03_02_00";
	ROM(5) <= X"01_02_01_02";
	ROM(6) <= X"08_84_01_E2";
	ROM(7) <= X"07_00_84_9A";

	InstructionMemory : process (CLK)
	begin
		if rising_edge(CLK) then
			COUT <= ROM(CONV_INTEGER(unsigned(address)));	--on passe l'adresse en paramètre de la ROM pour accéder à la ligne en question (l'adresse étant sous forme 0b0001, on la cast en int)
		end if;
	end process;
end Behavioral;

