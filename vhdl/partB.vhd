Library ieee;
use ieee.std_logic_1164.all;

entity partB is 
        GENERIC (n : integer := 16);
	port(
       	     CIN, S1, S0 : in std_logic;
	     A, B: in std_logic_vector (n-1 downto 0);
	     F : out std_logic_vector (n-1 downto 0);
	     COUT: out	std_logic);
end entity;

Architecture archB of partB is
    COMPONENT adder_nbits IS
         GENERIC (n : integer := 16);
 	     PORT(a, b : IN std_logic_vector(n-1 DOWNTO 0);
         	  cin : IN std_logic;
                  s : OUT std_logic_vector(n-1 DOWNTO 0);
	          cout : OUT std_logic);
    END COMPONENT;
    SIGNAL tempA, tempSum : std_logic_vector(n-1 DOWNTO 0);
    SIGNAL tempCin, tempCout: std_logic;
begin

	tempA <= (not A);
	tempCin <= ('1') when (s1='0' and s0='0')
	else (not CIN);
		
 	f0: adder_nbits generic map(n) port map (B, tempA, tempCin, tempSum, tempCout);     
 
	COUT <= '0' when (s1='1')
	else tempCout;
 
	F <= (A and B) when (s1='1' and s0='0')
	else (A or B)  when (s1='1' and s0='1')
	else tempSum;

end Architecture;
