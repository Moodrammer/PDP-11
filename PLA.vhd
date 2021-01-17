
Library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pla is
  port (
    i: in std_logic_vector(15 downto 0);
    o: out std_logic_vector(7 downto 0)
  ) ;
end entity;

architecture arc of pla is
   signal opGroup : std_logic_vector (1 downto 0);
   signal specialOperations, twoOperands, oneOperand : std_logic_vector (7 downto 0);
begin

	opGroup <= "00"  when (i(15 downto 12) = "1111")--Special Operations
  	  else "01" when (i(15 downto 12) = "1011")--singel op
  	  else "10" when (i(15 downto 12) = "1101")--branching
		else "11";-- two op
	

	specialOperations <= "00000100"  when (i(11 downto 8) = "0001")--halt
  	  else "11000001" when (i(11 downto 8) = "0010")--nop
  	  else "00101010" when (i(11 downto 8) = "0011")--jsr
	  else "00111100" when (i(11 downto 8) = "0100")--rts
		else "01000010"; --iret
	

	twoOperands <= "01000001"  when (i(11 downto 9) = "000")--reg direct
	else "01001001" when (i(11 downto 9) = "001")--reg indirect
	else "01010001" when (i(11 downto 10) = "01")--auto Increment
	else "01100001" when (i(11 downto 10) = "10")--auto decrement
	else "01110001"; --Indexed

	
	oneOperand <= "10000001"  when (i(5 downto 3) = "000")--reg direct
	else "10001001" when (i(5 downto 3) = "001")--reg indirect
	else "10010001" when (i(5 downto 4) = "01")--auto Increment
	else "10100001" when (i(5 downto 4) = "10")--auto decrement
	else "10110001"; --Indexed
	
	
	o <= specialOperations  when (opGroup = "00")
  	  else oneOperand when (opGroup = "01")
  	  else "11000000" when (opGroup = "10")
	  else twoOperands;

end arc ; -- arch
