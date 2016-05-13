----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:28:08 04/08/2016 
-- Design Name: 
-- Module Name:    MemData - Behavioral 
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
use IEEE.STD_LOGIC_1164.ALL;	--librairie des STD_LOGIC et STD_LOGIC_VECTOR
use IEEE.STD_LOGIC_ARITH.ALL;	--librairie des CONV_INTEGER
use WORK.ProcessorPack.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MemData is
    Port ( address : in  WORD;	--adresse passée en paramètre pour accéder à une ligne de la RAM
           CIN : in  WORD;			--data à écrire si 'écriture'
           RW : in  STD_LOGIC;	--Read/Write, 0 pour écrire, 1 pour lire
           RST : in  STD_LOGIC;	--reset de la RAM, 0 pour reset
           CLK : in  STD_LOGIC;	--la clock
           COUT : out  WORD);		--sortie si 'lecture'
end MemData;

architecture Behavioral of MemData is
begin
	DataMemory : process (CLK)
	begin
		if rising_edge(CLK) then
			if RST = '0' then	
				RAM <= (others => ZERO);	--on initialise chaque ligne avec le vecteur nul (8bits)
			else
				if RW = '0' then
					--On écrit 
					RAM(CONV_INTEGER(signed(address))) <= CIN; --on passe l'adresse en paramètre de la RAM pour accéder à la ligne en question (l'adresse étant sous forme 0b0001, on la cast en int)
				else
					--On lit 
					COUT <= RAM(CONV_INTEGER(signed(address)));
				end if;
			end if;
		end if;
	end process;
end Behavioral;

