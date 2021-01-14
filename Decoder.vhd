Library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity decoder is
  generic(n : integer := 2);
  port (
    i: in std_logic_vector((n-1) downto 0);
    o: out std_logic_vector(((2 ** n) - 1) downto 0);
    enable: in std_logic
  ) ;
end entity;

architecture arch of decoder is
begin
    process(i)
    begin
        o <= (others => '0'); -- default
        o(to_integer(unsigned(i))) <= '1'; 
    end process ; --
end arch ; -- arch
