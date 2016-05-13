----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:42:20 04/15/2016 
-- Design Name: 
-- Module Name:    PipeLine - Behavioral 
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

entity PipeLine is
    Port ( inA  : in  WORD;
           inB  : in  WORD;
           inOP : in  OPT;
           inC  : in  WORD;
           outA : out WORD;
           outB : out WORD;
           outOP: out OPT;
           outC : out WORD;
           CLK  : in  STD_LOGIC);
end PipeLine;

architecture Behavioral of PipeLine is

begin
	Tuyau : process (CLK)
	begin
		if rising_edge(CLK) then
			outA <= inA;
			outB <= inB;
			outC <= inC;
			outOP <= inOP;
		end if;
	end process;
end Behavioral;

