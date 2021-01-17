
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity ORBranch is
  port (
    IR : in std_logic_vector(15 downto 0);
    orBranch : in std_logic;
    zeroFlag: in std_logic;
    carryFlag: in std_logic;
    microIR : out std_logic_vector(7 downto 0)
  );
end entity;

architecture arch of ORBranch is
  signal BEQ, BNE, BLO, BLS, BHI, BHS :std_logic;
begin
    
    -- conditions of the types of branching
    BEQ <= zeroFlag;
    BNE <= not(zeroFlag);
    BLO <= not(carryFlag);
    BLS <= not(carryFlag) or zeroFlag;
    BHI <= carryFlag;
    BHS <= carryFlag or zeroFlag;

    
    microIR(7 downto 3) <= "00000";
    microIR(2) <= '1' when IR(11 downto 8)="0001" and orBranch='1'
    else '1' when IR(11 downto 8)="0010" and BEQ='1' and orBranch='1'
    else '1' when IR(11 downto 8)="0011" and BNE='1' and orBranch='1'
    else '1' when IR(11 downto 8)="0100" and BLO='1' and orBranch='1'
    else '1' when IR(11 downto 8)="0101" and BLS='1' and orBranch='1'
    else '1' when IR(11 downto 8)="0110" and BHI='1' and orBranch='1'
    else '1' when IR(11 downto 8)="0111" and BHS='1' and orBranch='1'
    else '0';
    microIR(1 downto 0) <= "00";
end arch ;

