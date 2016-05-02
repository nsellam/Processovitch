----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:10:27 04/15/2016 
-- Design Name: 
-- Module Name:    PipeDiEx - Behavioral 
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

entity PipeDiEx is
    Port ( A  : inout STD_LOGIC_VECTOR (7 downto 0);
           OP : inout STD_LOGIC_VECTOR (3 downto 0);
           B  : inout STD_LOGIC_VECTOR (7 downto 0);
           C  : inout STD_LOGIC_VECTOR (7 downto 0);
			  CLK: in  STD_LOGIC);
end PipeDiEx;

architecture Behavioral of PipeDiEx is

begin
	PipeDiEx : process (CLK)
	begin
		if rising_edge(CLK) then
			-- ??
		end if;
	end process;
end Behavioral;

