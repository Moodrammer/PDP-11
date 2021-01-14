LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY adder_nbits IS
   GENERIC (n : integer := 16);
   PORT(a, b : IN std_logic_vector(n-1 DOWNTO 0);
         cin : IN std_logic;
           s : OUT std_logic_vector(n-1 DOWNTO 0);
        cout : OUT std_logic);
END adder_nbits;

ARCHITECTURE archnbits OF adder_nbits IS
         COMPONENT adder_2bits IS
                  PORT( a,b,cin : IN std_logic; 
			s,cout : OUT std_logic);
          END COMPONENT;
          SIGNAL temp : std_logic_vector(n-1 DOWNTO 0);
BEGIN
	f0: adder_2bits PORT MAP(a(0),b(0),cin,s(0),temp(0));
	loop1: FOR i IN 1 TO n-1 GENERATE
        	fx: adder_2bits PORT MAP(a(i),b(i),temp(i-1),s(i),temp(i));
	END GENERATE;
	Cout <= temp(n-1);
END archnbits;

