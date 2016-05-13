----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:14:29 04/08/2016 
-- Design Name: 
-- Module Name:    RegBench - Behavioral 
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

entity RegBench is
    Port ( aA : in  RegAddr;		--adresse du premier registre (à lire)
           aB : in  RegAddr;		--adresse du second registre (à lire)
           aW : in  RegAddr;		--adresse du registre d'entrée (celui dans lequel on veut écrire)
           W : in  STD_LOGIC;										--Write, 1 pour écrire, 0 pour lire
           DATA : in  WORD;		--Data à écrire si 'écriture'
           RST : in  STD_LOGIC;									--reset, 0 pour reset
           CLK : in  STD_LOGIC;									--la clock, toujours
           QA : out  WORD;			--Sortie A
           QB : out  WORD);		--Sortie B
end RegBench;

architecture Behavioral of RegBench is
begin
	Registres : process (CLK)
	begin
		if rising_edge(CLK) then
			if RST = '0' then
				Rx <= (others => ZERO);	--on initialise chaque ligne avec le vecteur nul (8bits)
			else
				if W = '1' then
					--écriture de DATA vers le reg d'@W
					Rx(CONV_INTEGER(signed(aW))) <= DATA;		--on passe l'adresse en paramètre de la table pour accéder à la ligne en question (l'adresse étant sous forme 0b0001, on la cast en int)
				else
					--lecture 
					QA <= Rx(CONV_INTEGER(signed(aA)));
					QB <= Rx(CONV_INTEGER(signed(aB)));
				end if;
			end if;
		end if;
	end process;
end Behavioral;
