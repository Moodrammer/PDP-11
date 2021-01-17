library ieee;
use ieee.std_logic_1164.all;

entity ORResult is
  port (
    IR : in std_logic_vector(15 downto 0);
    orResult : in std_logic;
    microIR : out std_logic_vector(7 downto 0)
  );
end entity;

architecture arch of ORResult is
  signal registerDirect: std_logic;
begin
    registerDirect <= '1' when IR(5 downto 3) = "000"
    else '0';
    microIR(7 downto 1) <= "0000000";
    microIR(0) <= orResult and registerDirect;
end arch ;

