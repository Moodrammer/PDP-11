Library ieee;
use ieee.std_logic_1164.all;

entity PDP11 is
  GENERIC (n : integer := 16);    
	port(
      clock: in std_logic;
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
        q : OUT std_logic_vector(n-1 DOWNTO 0);
        rising: in std_logic
    );
  END component;

  component mdr IS
  GENERIC (n : integer := 16);
	PORT( 
    Clk,Rst,en, mem_read : IN std_logic;
    d : IN std_logic_vector(n-1 DOWNTO 0);
    ram_out: IN std_logic_vector(n-1 DOWNTO 0);
		q : OUT std_logic_vector(n-1 DOWNTO 0)
	);
  END component;

  -- Counter
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

  -- RAM
  component ram IS
    port(
      clk : IN std_logic;
      we  : IN std_logic;
      address : IN  std_logic_vector;
      datain  : IN  std_logic_vector;
      dataout : OUT std_logic_vector
    );
  end component;

  -- PLA
  component pla is
    port (
      i: in std_logic_vector(15 downto 0);
      o: out std_logic_vector(7 downto 0);
      enable: in std_logic
    ) ;
  end component;

  -- Bit oring circuits
  component BitORing is  
    port(
      IR : in std_logic_vector(15 downto 0);
      or_dst : in std_logic;
      or_ind_src : in std_logic;
      or_ind_dst : in std_logic;
      or_result: in std_logic;
      or_branch: in std_logic;
      or_operation: in std_logic;
      zeroFlag: in std_logic;
      carryFlag: in std_logic;
      microIR : out std_logic_vector(7 downto 0)
    );
  end component;

  component decoder is
    generic(m : integer := 2);
    port (
      i: in std_logic_vector((m-1) downto 0);
      o: out std_logic_vector(((2 ** m) - 1) downto 0)
    );
  end component;


  -- register
  signal internal_bus,register0, register1, register2, register3, register4, register5, register6, register7: std_logic_vector(15 downto 0);
  signal mdregister, maregister, iregister, iregister_temp, iregister_address, tempregister, Yregister, Zregister: std_logic_vector(15 downto 0);
  signal flagregister, ram_out: std_logic_vector(15 downto 0);

  -- micro ar
  signal microAr_input, microAr_output: std_logic_vector(7 downto 0);

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
    signal control_word: std_logic_vector(31 downto 0);

    -- grouped control signals
    signal F0: std_logic_vector(7 downto 0);
    signal F1, F2, F8: std_logic_vector(2 downto 0);
    signal F3, F7: std_logic_vector(1 downto 0);
    signal F4, F5, F9, F10: std_logic;
    signal F6: std_logic_vector(3 downto 0); -- ALU group

    -- individual control signals
    signal mem_write, mem_read, pla_out, halt, clk: std_logic;
    signal r_src_out, r_dst_out, r_src_in, r_dst_in: std_logic;

    -- decoding circuits
    signal bitoring_output, pla_output: std_logic_vector(7 downto 0);
    signal decoder_F8_outputs: std_logic_vector(7 downto 0); -- bit oring group
    signal decoder_F7_outputs: std_logic_vector(3 downto 0); -- read/write group
    signal decoder_F3_outputs: std_logic_vector(3 downto 0); -- some input signals
    signal decoder_F2_outputs: std_logic_vector(7 downto 0); -- other input signals
    signal decoder_F1_outputs: std_logic_vector(7 downto 0); -- some output signals group
    signal decoder_rsrc_outputs : std_logic_vector(7 downto 0); -- to know which register is the src
    signal decoder_rdst_outputs : std_logic_vector(7 downto 0); -- to know which register is the dst

begin

  clk <= clock and not(halt); -- to stop the cpu
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

  reg0: Register_nbits generic map(n) port map (clk, reset, r0_in, internal_bus, register0, '1');
  reg1: Register_nbits generic map(n) port map (clk, reset, r1_in, internal_bus, register1, '1');
  reg2: Register_nbits generic map(n) port map (clk, reset, r2_in, internal_bus, register2, '1');
  reg3: Register_nbits generic map(n) port map (clk, reset, r3_in, internal_bus, register3, '1');
  reg4: Register_nbits generic map(n) port map (clk, reset, r4_in, internal_bus, register4, '1');
  reg5: Register_nbits generic map(n) port map (clk, reset, r5_in, internal_bus, register5, '1');
  reg6: Register_nbits generic map(n) port map (clk, reset, r6_in, internal_bus, register6, '1');
  r7_in_en <= r7_in or pc_in;
  reg7: counter generic map(n) port map (clk, reset, r7_in_en, internal_bus, register7, pc_inc);

  ----------------------------------------------------------------------------------------------
  -- memory access

  tri_mdr: Tristate generic map(n) port map(mdr_out, mdregister, internal_bus);
  tri_mar: Tristate generic map(n) port map(mar_out, maregister, internal_bus);

  mdreg: mdr generic map(n) port map (clk, reset, mdr_in, mem_read, internal_bus, ram_out, mdregister);
  mar: Register_nbits generic map(n) port map (clk, reset, mar_in, internal_bus, maregister, '1');
  
  ram0: ram port map(clk, mem_write, maregister(10 downto 0), mdregister, ram_out);

  ----------------------------------------------------------------------------------------------
  -- instruction register

  tri_ir_address: Tristate generic map(n) port map(ir_address_out, iregister_address, internal_bus);

  ireg: Register_nbits generic map(n) port map (clk, '0', ir_in, internal_bus, iregister, '1');
  iregister_temp <= "00000000" & iregister(7 downto 0) when iregister(7) = '0'
  else "11111111" & iregister(7 downto 0);

  ireg_address: Register_nbits generic map(n) port map (clk, '0', '1', iregister_temp, iregister_address, '1');


  ----------------------------------------------------------------------------------------------
  -- ALU
  ALU_A_input <= internal_bus;
  ALU_B_input <= Yregister;
  alunit: ALU generic map(n) port map(ALU_A_input, ALU_B_input, F6, carryFlag, ALU_output, ALU_carryFlag, ALU_zeroFlag, ALU_negativeFlag);

  ALU_Flag_in <= "0000000000000" & ALU_carryFlag & ALU_zeroFlag & ALU_negativeFlag;
  flagreg: Register_nbits generic map(n) port map (clk, reset, Z_in, ALU_Flag_in, flagregister, '1');
  carryFlag <= flagregister(2);
  zeroFlag <= flagregister(1); 
  negativeFlag <= flagregister(0); 

  ----------------------------------------------------------------------------------------------
  -- transparent registers

  tri_Z: Tristate generic map(n) port map(Z_out, Zregister, internal_bus);
  tri_temp: Tristate generic map(n) port map(temp_out, tempregister, internal_bus);

  tempreg: Register_nbits generic map(n) port map (clk, '0', temp_in, internal_bus, tempregister, '1');
  Zreg: Register_nbits generic map(n) port map (clk, '0', Z_in, ALU_output, Zregister, '1');
  Yreg: Register_nbits generic map(n) port map (clk, '0', Y_in, internal_bus, Yregister, '1');


  -----------------------------------------------------------------------------------------------
  -- control store

  -- control word groups
  F0 <= control_word(28 downto 21);
  F1 <= control_word(20 downto 18);
  F2 <= control_word(17 downto 15);
  F3 <= control_word(14 downto 13);
  F4 <= control_word(12);
  F5 <= control_word(11);
  F6 <= control_word(10 downto 7);
  F7 <= control_word(6 downto 5);
  F8 <= control_word(4 downto 2);
  F9 <= control_word(1);
  F10 <= control_word(0);

  -- control word groups decoding circuits
  decoder_F1: decoder generic map(3) port map(F1, decoder_F1_outputs);
  decoder_F2: decoder generic map(3) port map(F2, decoder_F2_outputs);
  decoder_F3: decoder generic map(2) port map(F3, decoder_F3_outputs);
  decoder_F7: decoder generic map(2) port map(F7, decoder_F7_outputs);
  decoder_F8: decoder generic map(3) port map(F8, decoder_F8_outputs);
  decoder_Rsrc: decoder generic map(3) port map(iregister(8 downto 6), decoder_rsrc_outputs);
  decoder_Rdst: decoder generic map(3) port map(iregister(2 downto 0), decoder_rdst_outputs);


  -- individual control signals
  pc_out <= decoder_F1_outputs(1);
  mdr_out <= decoder_F1_outputs(2);
  Z_out <= decoder_F1_outputs(3);
  r_src_out <= decoder_F1_outputs(4);
  r_dst_out <= decoder_F1_outputs(5);
  temp_out <= decoder_F1_outputs(6);
  ir_address_out <= decoder_F1_outputs(7);

  pc_in <= decoder_F2_outputs(1);
  ir_in <= decoder_F2_outputs(2);
  Z_in <= decoder_F2_outputs(3);
  r_src_in <= decoder_F2_outputs(4);
  r_dst_in <= decoder_F2_outputs(5);

  mar_in <= decoder_F3_outputs(1);
  mdr_in <= decoder_F3_outputs(2);
  temp_in <= decoder_F3_outputs(3);

  mem_read <= decoder_F7_outputs(1);
  mem_write <= decoder_F7_outputs(2);

  Y_in <= F4;
  pla_out <= F9;
  pc_inc <= F5;
  halt <= F10;
  
  r0_out <= (decoder_rsrc_outputs(0) and r_src_out) or (decoder_rdst_outputs(0) and r_dst_out);
  r1_out <= (decoder_rsrc_outputs(1) and r_src_out) or (decoder_rdst_outputs(1) and r_dst_out);
  r2_out <= (decoder_rsrc_outputs(2) and r_src_out) or (decoder_rdst_outputs(2) and r_dst_out);
  r3_out <= (decoder_rsrc_outputs(3) and r_src_out) or (decoder_rdst_outputs(3) and r_dst_out);
  r4_out <= (decoder_rsrc_outputs(4) and r_src_out) or (decoder_rdst_outputs(4) and r_dst_out);
  r5_out <= (decoder_rsrc_outputs(5) and r_src_out) or (decoder_rdst_outputs(5) and r_dst_out);
  r6_out <= (decoder_rsrc_outputs(6) and r_src_out) or (decoder_rdst_outputs(6) and r_dst_out);
  r7_out <= (decoder_rsrc_outputs(7) and r_src_out) or (decoder_rdst_outputs(7) and r_dst_out);
  
  r0_in <= (decoder_rsrc_outputs(0) and r_src_in) or (decoder_rdst_outputs(0) and r_dst_in);
  r1_in <= (decoder_rsrc_outputs(1) and r_src_in) or (decoder_rdst_outputs(1) and r_dst_in);
  r2_in <= (decoder_rsrc_outputs(2) and r_src_in) or (decoder_rdst_outputs(2) and r_dst_in);
  r3_in <= (decoder_rsrc_outputs(3) and r_src_in) or (decoder_rdst_outputs(3) and r_dst_in);
  r4_in <= (decoder_rsrc_outputs(4) and r_src_in) or (decoder_rdst_outputs(4) and r_dst_in);
  r5_in <= (decoder_rsrc_outputs(5) and r_src_in) or (decoder_rdst_outputs(5) and r_dst_in);
  r6_in <= (decoder_rsrc_outputs(6) and r_src_in) or (decoder_rdst_outputs(6) and r_dst_in);
  r7_in <= (decoder_rsrc_outputs(7) and r_src_in) or (decoder_rdst_outputs(7) and r_dst_in);

  -- 
  microAr_input <= F0 or bitoring_output or pla_output;

  plarray: pla port map(iregister, pla_output, pla_out);
  microareg: Register_nbits generic map(8) port map (clk, reset, '1', microAr_input, microAr_output, '0');
  bitoringcirc: BitORing port map(iregister, decoder_F8_outputs(1), decoder_F8_outputs(2), decoder_F8_outputs(3), decoder_F8_outputs(4), decoder_F8_outputs(5), decoder_F8_outputs(6), zeroFlag, carryFlag, bitoring_output);
  rom: ram port map(clk, '0', microAr_output, control_word, control_word); -- first control_word is don't care


end arch ; -- arch
