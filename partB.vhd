Library ieee;
use ieee.std_logic_1164.all;

entity partB is 
        GENERIC (n : integer := 16);
	port(
       	     S1, S0 : in std_logic;
	     A, B: in std_logic_vector (n-1 downto 0);
	     F : out std_logic_vector (n-1 downto 0));
end entity;

Architecture archB of partB is
begin

	F <= (A and B) when (s1='0' and s0='0')
	else (A or B)  when (s1='0' and s0='1')
	else (A xor B) when (s1='1' and s0='0')
	else (not A); 

end Architecture;