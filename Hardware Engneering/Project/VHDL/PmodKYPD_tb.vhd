LIBRARY IEEE;
USE ieee.std_logic_1164.all;

ENTITY PmodKYPD_tb IS
END PmodKYPD_tb;

ARCHITECTURE behavioral OF PmodKYPD_tb IS

  COMPONENT PmodKYPD
    PORT (
 	reset : IN STD_LOGIC;
      	clk : IN STD_LOGIC;
	LED1: out std_logic;
    	LED2: out std_logic;
    	LED3: out std_logic;
	LED4: out std_logic;
	JArow : in  STD_LOGIC_VECTOR (3 downto 0); -- PmodKYPD is designed to be connected to JA
JAcol : out  STD_LOGIC_VECTOR (3 downto 0);
    an : out  STD_LOGIC_VECTOR (3 downto 0);   -- Controls which position of the seven segment display to display
    seg : out  STD_LOGIC_VECTOR (6 downto 0) -- digit to display on the seven segment display 
    );
  END COMPONENT;

  
  SIGNAL reset_t   : STD_LOGIC := '1';
SIGNAL clk_t       : STD_LOGIC := '0';
 SIGNAL LED1_t: std_logic;
 SIGNAL LED2_t: std_logic;
 SIGNAL LED3_t: std_logic;
 SIGNAL LED4_t: std_logic;
  SIGNAL JArow_t      : STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL JAcol_t      : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL an_t   : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL seg_t      : STD_LOGIC_VECTOR(6 DOWNTO 0);

BEGIN
  uut: PmodKYPD
    PORT MAP (
	reset => reset_t,
      	clk => clk_t,
      
	LED1 => LED1_t,
    	LED2 => LED2_t,
    	LED3 => LED3_t,
	LED4 => LED4_t,
      JArow => JArow_t,
JAcol => JAcol_t,
      an => an_t,
      seg => seg_t
    );
-- Clock process
    process
    begin
   --     while now < 1000 ns loop  -- Simulation duration, adjust as needed
            clk_t <= '0';
            wait for 10 ns;
            clk_t <= '1';
            wait for 10 ns;
--end loop;
    end process;
  
process
    begin
        -- Provide stimulus values here
               
        -- Example: Press Key1
        JArow_t <= "0001";
        reset_t <= '0';
        wait for 10 ns;
        
        -- Example: Press Key2
        JArow_t <= "0010";
        reset_t <= '0';
        wait for 10 ns; 
        
        -- Example: Press Key3
        JArow_t <= "0100";
        reset_t <= '0';
        wait for 10 ns;
  END PROCESS;

END behavioral;
