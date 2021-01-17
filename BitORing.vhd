Library ieee;
use ieee.std_logic_1164.all;

entity BitORing is  
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
end entity;

architecture arch of BitORing is
  
  -- OR destination
  component ORDst is
    port (
      IR : in std_logic_vector(15 downto 0);
      or_dst : in std_logic;
      microIR : out std_logic_vector(7 downto 0)
    );
  end component;

  -- OR indirect source
  component ORIndSrc is
    port (
      IR : in std_logic_vector(15 downto 0);
      or_ind_src : in std_logic;
      microIR : out std_logic_vector(7 downto 0)
    );
  end component;

  -- OR indirect destination
  component ORIndDst is
    port (
      IR : in std_logic_vector(15 downto 0);
      or_ind_dst : in std_logic;
      microIR : out std_logic_vector(7 downto 0)
    );
  end component;

  -- OR result
  component ORResult is
    port (
      IR : in std_logic_vector(15 downto 0);
      orResult : in std_logic;
      microIR : out std_logic_vector(7 downto 0)
    );
  end component;

  -- OR branch
  component ORBranch is
    port (
      IR : in std_logic_vector(15 downto 0);
      orBranch : in std_logic;
      zeroFlag: in std_logic;
      carryFlag: in std_logic;
      microIR : out std_logic_vector(7 downto 0)
    );
  end component;

  -- OR operation
  component OROperation is
    port (
      IR : in std_logic_vector(15 downto 0);
      orOperation : in std_logic;
      microIR : out std_logic_vector(7 downto 0)
    );
  end component;

  signal microIR_or_dst, microIR_or_ind_src, microIR_or_ind_dst,  microIR_or_result, microIR_or_branch, microIR_or_operation: std_logic_vector(7 downto 0);
begin

  a: ORDst port map (IR, or_dst, microIR_or_dst);
	b: ORIndSrc port map (IR, or_ind_src, microIR_or_ind_src);
	c: ORIndDst port map (IR, or_ind_dst, microIR_or_ind_dst);
  d: ORResult port map (IR, or_result, microIR_or_result);
  e: ORBranch port map (IR, or_branch, zeroFlag, carryFlag, microIR_or_branch);
  f: OROperation port map (IR, or_operation, microIR_or_operation);

	microIR <= microIR_or_dst or microIR_or_ind_src or microIR_or_ind_dst or microIR_or_result or microIR_or_branch or microIR_or_operation;

end arch ; -- arch
