Library ieee;
use ieee.std_logic_1164.all;

entity partD is 

        GENERIC (n : integer := 16);
	port(
	S1, S0, CIN : in std_logic;
	A : in std_logic_vector (n-1 downto 0);
	F : out std_logic_vector (n-1 downto 0);
	COUT : out std_logic);

end entity;

Architecture archD of partD is
begin

	Cout <= '0' when (s1='1' and s0='1')
	else A(n-1);

	F <= (A(n-2 downto 0) & '0')   when (s1='0' and s0='0')
	else (A(n-2 downto 0) & A(n-1)) when (s1='0' and s0='1')
	else (A(n-2 downto 0) & CIN)   when (s1='1' and s0='0')
	else (others => '0');

end Architecture;