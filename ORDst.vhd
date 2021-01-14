
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity ORDst is
  port (
    IR : in std_logic_vector(15 downto 0);
    or_dst : in std_logic;
    microIR : out std_logic_vector(7 downto 0)
  );
end entity;

architecture arch of ORDst is
begin
    microIR(7 downto 6) <= "00";
    microIR(5) <= or_dst and IR(5);
    microIR(4) <= or_dst and IR(4);
    microIR(3) <= or_dst and IR(3);
    microIR(2 downto 0) <= "000";
end arch ;

