Library ieee;
use ieee.std_logic_1164.all;

entity PDP11 is
  GENERIC (n : integer := 16);    
	port(
    clk: in std_logic;
    reset: in std_logic
    );
end entity;

architecture arch of PDP11 is
  
  -- Register
  component Register_nbits IS
        GENERIC (n : integer := 16);
	PORT( Clk,Rst,en : IN std_logic;
		       d : IN std_logic_vector(n-1 DOWNTO 0);
		       q : OUT std_logic_vector(n-1 DOWNTO 0));
  END component;

  component counter is
    generic (n: integer);
    port (
      clk, rst, loadEnable: in std_logic;
      load: in std_logic_vector(n-1 downto 0);
      count: out std_logic_vector(n-1 downto 0);
      countEnable: in std_logic
    ) ;
  end component;

  -- Tristate
  component Tristate IS
	GENERIC (n : integer := 16);
	PORT(	          en : IN std_logic;
      		input_signal : IN std_logic_vector(n-1 DOWNTO 0);
	       output_signal : OUT std_logic_vector(n-1 DOWNTO 0));
  END component;

  -- register
  signal internal_bus,register0, register1, register2, register3, register4, register5, register6, register7, mdregister, maregister, ir: std_logic_vector(15 downto 0);

  -- micro ar
  signal microAr: std_logic_vector(7 downto 0);

  -- flags
  signal carryFlag, zeroFlag, negativeFlag: std_logic;

  -- registers in enable
  signal r0_in, r1_in, r2_in, r3_in, r4_in, r5_in, r6_in, r7_in, pc_in, mdr_in, mar_in: std_logic; 
  signal r7_in_en, pc_inc: std_logic; 

  -- registers out enable
  signal r0_out, r1_out, r2_out, r3_out, r4_out, r5_out, r6_out, r7_out, pc_out, mdr_out, mar_out: std_logic;
  signal r7_out_en: std_logic;

begin

  ---------------------------------------------------------------------------------------------------
  -- general purpose registers 

  tri0: Tristate generic map(n) port map(r0_out, register0, internal_bus);
  tri1: Tristate generic map(n) port map(r1_out, register1, internal_bus);
  tri2: Tristate generic map(n) port map(r2_out, register2, internal_bus);
  tri3: Tristate generic map(n) port map(r3_out, register3, internal_bus);
  tri4: Tristate generic map(n) port map(r4_out, register4, internal_bus);
  tri5: Tristate generic map(n) port map(r5_out, register5, internal_bus);
  tri6: Tristate generic map(n) port map(r6_out, register6, internal_bus);
  r7_out_en <= r7_out or pc_out;
  tri7: Tristate generic map(n) port map(r7_out_en, register7, internal_bus);

  reg0: Register_nbits generic map(n) port map (clk, '0', r0_in, internal_bus, register0);
  reg1: Register_nbits generic map(n) port map (clk, '0', r1_in, internal_bus, register1);
  reg2: Register_nbits generic map(n) port map (clk, '0', r2_in, internal_bus, register2);
  reg3: Register_nbits generic map(n) port map (clk, '0', r3_in, internal_bus, register3);
  reg4: Register_nbits generic map(n) port map (clk, '0', r4_in, internal_bus, register4);
  reg5: Register_nbits generic map(n) port map (clk, '0', r5_in, internal_bus, register5);
  reg6: Register_nbits generic map(n) port map (clk, '0', r6_in, internal_bus, register6);
  r7_in_en <= r7_in or pc_in;
  reg7: counter generic map(n) port map (clk, reset, r7_in_en, internal_bus, register7, pc_inc);

  ----------------------------------------------------------------------------------------------
  -- memory access registers

  tri_mdr: Tristate generic map(n) port map(mdr_out, mdregister, internal_bus);
  tri_mar: Tristate generic map(n) port map(mar_out, maregister, internal_bus);

  mdr: Register_nbits generic map(n) port map (clk, '0', mdr_in, internal_bus, mdregister);
  mar: Register_nbits generic map(n) port map (clk, '0', mar_in, internal_bus, maregister);

end arch ; -- arch
