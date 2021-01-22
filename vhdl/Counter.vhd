library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity counter is
  generic (n: integer);
  port (
    clk, rst, loadEnable: in std_logic;
    load: in std_logic_vector(n-1 downto 0);
    count: out std_logic_vector(n-1 downto 0);
    countEnable: in std_logic
  ) ;
end entity;

architecture arch of counter is
  signal cnt :integer;
begin
    process( clk, rst )
    begin
      if rst = '1' then
        cnt <= 0;
      elsif rising_edge(clk) and (countEnable = '1') then
        cnt <= cnt + 1;
      elsif rising_edge(clk) and (loadEnable = '1') then
        cnt <= to_integer(unsigned(load));
      end if ;
    end process ; 
    count <= std_logic_vector(to_unsigned(cnt, count'length));
end arch ;
