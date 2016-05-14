--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   11:57:54 04/11/2016
-- Design Name:   
-- Module Name:   /home/sellam/Documents/4-IR/SystInfo/Processovitch/Processovitch/testRegBench.vhd
-- Project Name:  Processovitch
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: RegBench
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE work.processorpack.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY testRegBench IS
END testRegBench;
 
ARCHITECTURE behavior OF testRegBench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT RegBench
    PORT(
         aA : IN  RegAddr;
         aB : IN  RegAddr;
         aW : IN  RegAddr;
         W : IN  std_logic;
         DATA : IN  WORD;
         RST : IN  std_logic;
         CLK : IN  std_logic;
         QA : OUT  WORD;
         QB : OUT  WORD
        );
    END COMPONENT;
    

   --Inputs
   signal aA : RegAddr := (others => '0');
   signal aB : RegAddr := (others => '0');
   signal aW : RegAddr := (others => '0');
   signal W : std_logic := '0';
   signal DATA : WORD := (others => '0');
   signal RST : std_logic := '0';
   signal CLK : std_logic := '0';

 	--Outputs
   signal QA : WORD;
   signal QB : WORD;

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
	
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: RegBench PORT MAP (
          aA => aA,
          aB => aB,
          aW => aW,
          W => W,
          DATA => DATA,
          RST => RST,
          CLK => CLK,
          QA => QA,
          QB => QB
        );

   -- Clock process definitions
   CLK_process :process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
	
   begin		
      -- hold reset state for 100 ns.
			RST <= '1';
			DATA <= X"AC";
      wait for 100 ns;	
			aW <= X"1"; --affiche dans R1 0xAC
			W <= '1';
      wait for CLK_period*10;
			DATA <= X"DC";
			aW <= X"2";
			aB <= X"2"; --affiche dans R2 0xDC
		wait for CLK_period*10;
			W <= '0';
			aA <= X"1"; --retourne 0xAC et 0xDC
		wait for CLK_period*10;
			RST <= '0';
			aW <= X"0";
		wait for CLK_period*10;
			W <= '1';
      -- insert stimulus here 
		wait for CLK_period*10;
			RST <= '1';
      wait;
   end process;

END;
