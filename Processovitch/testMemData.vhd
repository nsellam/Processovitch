--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   11:49:50 04/11/2016
-- Design Name:   
-- Module Name:   /home/sellam/Documents/4-IR/SystInfo/Processovitch/Processovitch/testMemData.vhd
-- Project Name:  Processovitch
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: MemData
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
 
ENTITY testMemData IS
END testMemData;
 
ARCHITECTURE behavior OF testMemData IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT MemData
    PORT(
         address : IN  WORD;
         CIN : IN  WORD;
         RW : IN  std_logic;
         RST : IN  std_logic;
         CLK : IN  std_logic;
         COUT : OUT  WORD
        );
    END COMPONENT;
    

   --Inputs
   signal address : WORD := (others => '0');
   signal CIN : WORD := (others => '0');
   signal RW : std_logic := '0';
   signal RST : std_logic := '0';
   signal CLK : std_logic := '0';

 	--Outputs
   signal COUT : WORD;

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: MemData PORT MAP (
          address => address,
          CIN => CIN,
          RW => RW,
          RST => RST,
          CLK => CLK,
          COUT => COUT
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
		RST <= '1';
		RAM(254) <= X"DC";
      -- hold reset state for 100 ns.
      wait for 100 ns;	
			address <= X"01";
			CIN <= X"AC";
			RW <= '0'; --écriture
      wait for CLK_period*10;
			RW <= '1'; --lecture
			CIN <= X"DC";
      -- insert stimulus here 
		wait for CLK_period*10;
			RW <= '0';
			RST <= '0';
      wait for CLK_period*10;
			RST <= '1';
			RW <= '1';
      -- insert stimulus here 		
      wait for CLK_period*10;
			RW <= '0';
      -- insert stimulus here 
      wait for CLK_period*10;
			RST <= '0';
			RW <= '0';
      -- insert stimulus here 		
      wait for CLK_period*10;
			RST <= '1';
      -- insert stimulus here 
      wait;
   end process;

END;
