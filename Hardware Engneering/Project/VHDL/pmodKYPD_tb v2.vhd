LIBRARY IEEEE;
USE ieee.std_logic_1164.all;

ENTITY PmodKYPD_tb IS
END PmodKYPD_tb;

ARCHITECTURE behavior OF PmodKYPD_tb IS
  COMPONENT PmodKYPD_tb
    PORT (
      clk     : IN STD_LOGIC;
      reset_n : IN STD_LOGIC;
      rows    : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      columns : BUFFER STD_LOGIC_VECTOR(3 DOWNTO 0);
      keys    : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
  END COMPONENT;

  SIGNAL clk       : STD_LOGIC := '0';
  SIGNAL reset_n   : STD_LOGIC := '1';
  SIGNAL rows      : STD_LOGIC_VECTOR(3 DOWNTO 0) := (OTHERS => '1');
  SIGNAL columns   : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL keys      : STD_LOGIC_VECTOR(15 DOWNTO 0);

BEGIN
  uut: PmodKYPD
    PORT MAP (
      clk => clk,
      reset_n => reset_n,
      rows => rows,
      columns => columns,
      keys => keys
    );

  clk_process: PROCESS
  BEGIN
    WHILE NOW < 1 us LOOP  -- Simulate for 1 micro s
      clk <= NOT clk;
      WAIT FOR 10 ns;
    END LOOP;
    WAIT;
  END PROCESS;

  stimulus_process: PROCESS
  BEGIN
    reset_n <= '0';
    WAIT FOR 20 ns;
    reset_n <= '1';

    WAIT FOR 50 ns;
    rows <= "1101";
    WAIT FOR 50 ns;
    rows <= "0111";
    WAIT FOR 50 ns;
    rows <= "1011";
    WAIT FOR 50 ns;
    rows <= "1111";

    WAIT;
  END PROCESS;

END behavior;
