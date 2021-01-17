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
    PORT( 
        Clk,Rst,en : IN std_logic;
        d : IN std_logic_vector(n-1 DOWNTO 0);
        q : OUT std_logic_vector(n-1 DOWNTO 0)
    );
  END component;

  component counter is
    GENERIC (n : integer := 16);
    port (
      clk, rst, loadEnable: in std_logic;
      load: in std_logic_vector(n-1 downto 0);
      count: out std_logic_vector(n-1 downto 0);
      countEnable: in std_logic
    );
  end component;

  -- Tristate
  component Tristate IS
    GENERIC (n : integer := 16);
    PORT(
      en : IN std_logic;
      input_signal : IN std_logic_vector(n-1 DOWNTO 0);
      output_signal : OUT std_logic_vector(n-1 DOWNTO 0)
    );
  END component;

  -- ALU
  component ALU is
    GENERIC (n : integer := 16);  
    port(
      A, B:  in std_logic_vector (n-1 downto 0);
      S:     in std_logic_vector (3 downto 0);
      CIN:   in std_logic;
      F:     out std_logic_vector (n-1 downto 0);
      COUT, zeroFlag, negativeFlag:  out std_logic
    );
  end component;


  -- register
  signal internal_bus,register0, register1, register2, register3, register4, register5, register6, register7: std_logic_vector(15 downto 0);
  signal mdregister, maregister, iregister, iregister_temp, iregister_address, tempregister, Yregister, Zregister: std_logic_vector(15 downto 0);
  signal flagregister: std_logic_vector(15 downto 0);

  -- micro ar
  signal microAr: std_logic_vector(7 downto 0);

  -- flags
  signal carryFlag, zeroFlag, negativeFlag: std_logic;

  -- registers in enable
  signal r0_in, r1_in, r2_in, r3_in, r4_in, r5_in, r6_in, r7_in, pc_in, mdr_in, mar_in: std_logic; 
  signal r7_in_en, pc_inc: std_logic;
  signal ir_in, temp_in, Y_in, Z_in: std_logic;

  -- registers out enable
  signal r0_out, r1_out, r2_out, r3_out, r4_out, r5_out, r6_out, r7_out, pc_out, mdr_out, mar_out: std_logic;
  signal r7_out_en: std_logic;
  signal ir_address_out, temp_out, Z_out: std_logic;

  -- ALU
  signal ALU_output: std_logic_vector(15 downto 0);
  signal ALU_B_input, ALU_A_input, ALU_Flag_in: std_logic_vector(15 downto 0);
  signal ALU_carryFlag, ALU_zeroFlag, ALU_negativeFlag: std_logic;

  -- control store
  signal F6: std_logic_vector(3 downto 0); -- ALU group
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

  ----------------------------------------------------------------------------------------------
  -- instruction register

  tri_ir_address: Tristate generic map(n) port map(ir_address_out, iregister_address, internal_bus);

  ireg: Register_nbits generic map(n) port map (clk, '0', ir_in, internal_bus, iregister);
  iregister_temp <= "00000000" & iregister(7 downto 0);
  ireg_address: Register_nbits generic map(n) port map (clk, '0', '1', iregister_temp, iregister_address);


  ----------------------------------------------------------------------------------------------
  -- ALU
  ALU_A_input <= internal_bus;
  ALU_B_input <= Yregister;
  alunit: ALU generic map(n) port map(ALU_A_input, ALU_B_input, F6, carryFlag, ALU_output, ALU_carryFlag, ALU_zeroFlag, ALU_negativeFlag);

  ALU_Flag_in <= "0000000000000" & ALU_carryFlag & ALU_zeroFlag & ALU_negativeFlag;
  flagreg: Register_nbits generic map(n) port map (clk, '0', Z_in, ALU_Flag_in, flagregister);
  carryFlag <= flagregister(2);
  zeroFlag <= flagregister(1); 
  negativeFlag <= flagregister(0); 

  ----------------------------------------------------------------------------------------------
  -- transparent registers

  tri_Z: Tristate generic map(n) port map(Z_out, Zregister, internal_bus);
  tri_temp: Tristate generic map(n) port map(temp_out, tempregister, internal_bus);

  tempreg: Register_nbits generic map(n) port map (clk, '0', temp_in, internal_bus, tempregister);
  Zreg: Register_nbits generic map(n) port map (clk, '0', Z_in, ALU_output, Zregister);
  Yreg: Register_nbits generic map(n) port map (clk, '0', Y_in, internal_bus, Yregister);

end arch ; -- arch
