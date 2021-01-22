LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

ENTITY ram IS
	PORT(
		clk : IN std_logic;
		we  : IN std_logic;
		address : IN  std_logic_vector;
		datain  : IN  std_logic_vector;
		dataout : OUT std_logic_vector);
END ENTITY ram;

ARCHITECTURE syncrama OF ram IS

	type ram_type is array (0 to (2**address'length)-1) of std_logic_vector(datain'range);

	SIGNAL ram : ram_type := (
		OTHERS => (others => '0')
	);
	BEGIN 
		ram(to_integer(unsigned(address))) <= datain when we = '1';
		dataout <= ram(to_integer(unsigned(address)));
END syncrama;
