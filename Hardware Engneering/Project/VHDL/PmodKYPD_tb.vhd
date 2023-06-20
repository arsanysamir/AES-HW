LIBRARY IEEE;
USE ieee.std_logic_1164.all;

ENTITY PmodKYPD_tb IS
END PmodKYPD_tb;

ARCHITECTURE behavioral OF PmodKYPD_tb IS
  COMPONENT PmodKYPD
    PORT (
      clk     : IN STD_LOGIC;
      reset : IN STD_LOGIC;
      rows    : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      Col : BUFFER STD_LOGIC_VECTOR(3 DOWNTO 0);
      keys    : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
  END COMPONENT;

  SIGNAL clk       : STD_LOGIC := '0';
  SIGNAL reset   : STD_LOGIC := '1';
  SIGNAL rows      : STD_LOGIC_VECTOR(3 DOWNTO 0) := (OTHERS => '1');
  SIGNAL Col   : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL keys      : STD_LOGIC_VECTOR(15 DOWNTO 0);

BEGIN
  uut: PmodKYPD
    PORT MAP (
      clk => clk,
      reset => reset,
      rows => rows,
      Col => Col,
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
    reset <= '0';
    WAIT FOR 20 ns;
    reset <= '1';

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

END behavioral;
