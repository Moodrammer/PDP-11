
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity OROperation is
  port (
    IR : in std_logic_vector(15 downto 0);
    orOperation : in std_logic;
    microIR : out std_logic_vector(7 downto 0)
  );
end entity;

architecture arch of OROperation is
  signal singleOperand :std_logic;
begin
    

    -- conditions of the types of branching
    singleOperand <= '1' when IR(15 downto 12) = "1011"
    else '0';
    
    microIR(7 downto 5) <= "000";
    microIR(4) <= singleOperand and orOperation;
    microIR(3 downto 0) <=  IR(15 downto 12) when singleOperand = '0' and orOperation = '1'
    else IR(11 downto 8) when singleOperand = '1' and orOperation = '1'
    else "0000";
end arch ;

