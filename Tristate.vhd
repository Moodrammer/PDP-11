LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY Tristate IS
	GENERIC (n : integer := 16);
	PORT(	          en : IN std_logic;
      		input_signal : IN std_logic_vector(n-1 DOWNTO 0);
	       output_signal : OUT std_logic_vector(n-1 DOWNTO 0));
END Entity;

ARCHITECTURE tristate_arch OF Tristate IS
BEGIN
	output_signal <= input_signal when en='1'
	else 	  (others => 'Z'); 

END Architecture;
