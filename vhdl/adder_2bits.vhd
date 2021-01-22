LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY adder_2bits IS
           PORT( a,b,cin :   IN std_logic;
                 s,cout :    OUT std_logic); 
END adder_2bits;

ARCHITECTURE arch2bits OF adder_2bits IS
BEGIN
              s <= a XOR b XOR cin;
              cout <= (a AND b) or (cin AND (a XOR b));
END arch2bits;
