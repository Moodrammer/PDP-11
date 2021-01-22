library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity ORIndSrc is
  port (
    IR : in std_logic_vector(15 downto 0);
    or_ind_src : in std_logic;
    microIR : out std_logic_vector(7 downto 0)
  );
end entity;

architecture arch of ORIndSrc is
begin
    microIR(7 downto 1) <= "0000000";
    microIR(0) <= or_ind_src and not(IR(9));
end arch ;

