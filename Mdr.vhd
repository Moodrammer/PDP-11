LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY mdr IS
  GENERIC (n : integer := 16);
	PORT( 
    Clk,Rst,en, mem_read : IN std_logic;
    d : IN std_logic_vector(n-1 DOWNTO 0);
    ram_out: IN std_logic_vector(n-1 DOWNTO 0);
		q : OUT std_logic_vector(n-1 DOWNTO 0)
	);
END mdr;

ARCHITECTURE reg_arch OF mdr IS
BEGIN
	PROCESS (Clk,Rst,en, mem_read)
	BEGIN
		IF Rst = '1' THEN
      q <= (OTHERS=>'0');
    ELSIF mem_read = '1' THEN
			q <= ram_out;
		ELSIF rising_edge(Clk) and en='1' THEN
			q <= d;
		END IF;
	END PROCESS;
END reg_arch;
