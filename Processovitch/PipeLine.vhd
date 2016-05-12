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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity PipeLine is
    Port ( inA  : in  STD_LOGIC_VECTOR (7 downto 0);
           inB  : in  STD_LOGIC_VECTOR (7 downto 0);
           inOP : in  STD_LOGIC_VECTOR (3 downto 0);
           inC  : in  STD_LOGIC_VECTOR (7 downto 0);
           outA : out STD_LOGIC_VECTOR (7 downto 0);
           outB : out STD_LOGIC_VECTOR (7 downto 0);
           outOP: out STD_LOGIC_VECTOR (3 downto 0);
           outC : out STD_LOGIC_VECTOR (7 downto 0);
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

