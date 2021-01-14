Library ieee;
use ieee.std_logic_1164.all;

entity partC is 
        GENERIC (n : integer := 16);
	port(
	S1, S0, CIN : in std_logic;
	A : in std_logic_vector (n-1 downto 0);
	F : out std_logic_vector (n-1 downto 0);
	COUT : out std_logic);
end entity;

Architecture archC of partC is
begin

	COUT <= A(0);

	F <= ('0' & A(n-1 downto 1))  when (s1='0' and s0='0')
	else (A(0) & A(n-1 downto 1)) when (s1='0' and s0='1')
	else (CIN & A(n-1 downto 1)) when (s1='1' and s0='0')
	else (A(n-1) & A(n-1 downto 1));

end Architecture;
