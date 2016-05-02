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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity RegBench is
	Generic ( REG_MAX : Natural := 16; --nombre de registres
				 Nb : Natural := 4); --nombre de bits pour coder les registres
    Port ( aA : in  STD_LOGIC_VECTOR (Nb-1 downto 0);		--adresse du premier registre (à lire)
           aB : in  STD_LOGIC_VECTOR (Nb-1 downto 0);		--adresse du second registre (à lire)
           aW : in  STD_LOGIC_VECTOR (Nb-1 downto 0);		--adresse du registre d'entrée (celui dans lequel on veut écrire)
           W : in  STD_LOGIC;										--Write, 1 pour écrire, 0 pour lire
           DATA : in  STD_LOGIC_VECTOR (7 downto 0);		--Data à écrire si 'écriture'
           RST : in  STD_LOGIC;									--reset, 0 pour reset
           CLK : in  STD_LOGIC;									--la clock, toujours
           QA : out  STD_LOGIC_VECTOR (7 downto 0);		--Sortie A
           QB : out  STD_LOGIC_VECTOR (7 downto 0));		--Sortie B
end RegBench;

architecture Behavioral of RegBench is
	type MATRIX is array(0 to REG_MAX-1) of std_logic_vector(7 downto 0);	--matrice pour représenter la table des registres, tableau de REG_MAX mots de 8bits
	signal Rx : MATRIX;																		--table des registres
	signal NUL : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');				--signal nul, créé pour le reset
begin
	Registres : process (CLK)
	begin
		if rising_edge(CLK) then
			if RST = '0' then
				Rx <= (others => NUL);	--on initialise chaque ligne avec le vecteur nul (8bits)
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
