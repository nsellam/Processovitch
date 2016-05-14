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
use ieee.std_logic_unsigned.all;
use work.processorpack.all;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY testALU IS
END testALU;
 
ARCHITECTURE behavior OF testALU IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT ALU
    PORT(
         A : IN  WORD;
         B : IN  WORD;
         OP : IN  OPT;
         S : buffer  WORD;
         C : OUT  std_logic;
         N : OUT  std_logic;
         Z : OUT  std_logic;
         V : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal A : WORD := (others => '0');
   signal B : WORD := (others => '0');
   signal OP : OPT := (others => '0');

 	--Outputs
   signal S : WORD;
   signal C : std_logic;
   signal N : std_logic;
   signal Z : std_logic;
   signal V : std_logic;
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
   constant CLK_period : time := 10 ns;
	signal MegaS : std_logic_vector((DataSize*2)-1 downto 0);
	signal Res : Word;
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
			OP <= ADD;
				-- test de la fonction ADD
			Res <= X"03";
				-- S = X"01" + X"02" = X"03"
      wait for CLK_period*10;
			OP <= MUL;
			MegaS <= A*B;
				-- test de la fonction MUL
			Res <= X"02";
				-- S = 1x2 = X"02"
		wait for CLK_period*10;
			OP <= SUB;  
				-- test de la fonction SUB + flag N
			Res <= X"FF";
				-- S = FF, N=1
--      wait for CLK_period*10;
--			A  <= X"04";
--			OP <= DIV;
--				-- test de la fonction DIV (pas encore implémentée)
--				-- S = X"02"
		wait for CLK_period*10;
			A  <= X"06"; 
			OP <= ET;
				-- test de la fonction ET
			Res <= X"02";
				-- S = 110^010 = 010 = X"02"
		wait for CLK_period*10;
			OP <= OU;  
				-- test de la fonction OU
			Res <= X"06";
				-- S = 110v010 = 110 = X"06"
      wait for CLK_period*10;
			OP <= XOU;
				-- test de la fonction XOU
			Res <= X"04";
				-- S = 110+010 = 100 = X"04"
		wait for CLK_period*10;
			OP <= NON;
				-- test de la fonction NON
			Res <= X"F9";
				-- S = |0110 = 1001 = X"F9"
		wait for CLK_period*10;
			OP <= LSL; 
			A <= X"AC";
				-- test du LSL + flag C
			Res <= X"58";
				-- S = "1010_1100"<<1 = "0101_1000" = X"58", C=1
		wait for CLK_period*10;
			OP <= LSR;
				 --test du LSR
			Res <= X"D6";
				 --S = "1010_1100">>1 = "1101_0110" = X"D6"
		wait for CLK_period*10;
			OP <= ADD; 
			A  <= X"FE";		
				-- test du débordement + carry + zero
			Res <= X"00";
				-- S = X"00", V=1, C=1, Z=1
		wait for CLK_period*10;
			OP <= MUL;			
			MegaS <= A*B;
				 --test du débordement en cas de MUL
			Res <= X"FC";
				 --S = X"FC", V = 1
		wait for CLK_period*10;
			OP <= NOP; 		
				-- test du débordement + carry + zero
				-- S = X"00", V=1, C=1, Z=1

      wait;
   end process;

END;
