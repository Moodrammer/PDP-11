
Library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pla is
  port (
    i: in std_logic_vector(15 downto 0);
    o: out std_logic_vector(8 downto 0);
    enable: in std_logic
  ) ;
end entity;

architecture arc of pla is
   signal opGroup : std_logic_vector (1 downto 0);
   signal firstGroup : std_logic_vector (8 downto 0);
begin

	opGroup <= "00"  when (i(15 downto 12) = "1111")--Special Operations
  	  else "01" when (i(15 downto 12) = "1011")--singel op
  	  else "10" when (i(15 downto 12) = "1101")--branching
	  else "11";-- two op
	firstGroup <= "000000100"  when (i(11 downto 8) = "0001")--halt
  	  else "011000001" when (i(11 downto 8) = "0010")--nop
  	  else "000101010" when (i(11 downto 8) = "0011")--jsr
	  else "000111100" when (i(11 downto 8) = "0100")--rts
	  else "001000010"; --iret
	o <= firstGroup  when (opGroup = "00")
  	  else "010000001" when (opGroup = "01")
  	  else "011000001" when (opGroup = "10")
	  else "001000001";

end arc ; -- arch