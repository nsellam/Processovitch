--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   21:56:27 04/08/2016
-- Design Name:   
-- Module Name:   /home/sellam/Documents/4-IR/SystInfo/Processovitch/Processovitch/testALU.vhd
-- Project Name:  Processovitch
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: ALU
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
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY testALU IS
END testALU;
 
ARCHITECTURE behavior OF testALU IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT ALU
    PORT(
         A : IN  std_logic_vector(7 downto 0);
         B : IN  std_logic_vector(7 downto 0);
         OP : IN  std_logic_vector(3 downto 0);
         S : buffer  std_logic_vector(7 downto 0);
         C : OUT  std_logic;
         N : OUT  std_logic;
         Z : OUT  std_logic;
         V : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal A : std_logic_vector(7 downto 0) := (others => '0');
   signal B : std_logic_vector(7 downto 0) := (others => '0');
   signal OP : std_logic_vector(3 downto 0) := (others => '0');

 	--Outputs
   signal S : std_logic_vector(7 downto 0);
   signal C : std_logic;
   signal N : std_logic;
   signal Z : std_logic;
   signal V : std_logic;
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: ALU PORT MAP (
          A => A,
          B => B,
          OP => OP,
          S => S,
          C => C,
          N => N,
          Z => Z,
          V => V
        );

	-- A <= X"00", X"01" after 10 ns;
   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	
			A  <= X"01";
			B  <= X"02";
			OP <= X"1";
      wait for CLK_period*10;
			OP <= X"2";
		wait for CLK_period*10;
			OP <= X"3";  
      wait for CLK_period*10;
			OP <= X"4";
		wait for CLK_period*10;
			OP <= X"5";
		wait for CLK_period*10;
			OP <= X"6";  
      wait for CLK_period*10;
			OP <= X"7";
		wait for CLK_period*10;
			OP <= X"1";  
			A  <= X"FE";
      wait for CLK_period*10;
			OP <= X"0";
      wait;
   end process;

END;
