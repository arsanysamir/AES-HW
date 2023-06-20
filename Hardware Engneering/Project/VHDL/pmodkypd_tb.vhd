library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity PmodKYPD_tb is
end entity PmodKYPD_tb;

architecture testbench of PmodKYPD_tb is
    -- Signals for the testbench
    signal reset : std_logic := '0';
    signal clk : std_logic := '0';
    signal LED1 : std_logic;
    signal LED2 : std_logic;
    signal LED3 : std_logic;
    signal JA : std_logic_vector(7 downto 0);
    signal an : std_logic_vector(3 downto 0);
    signal seg : std_logic_vector(6 downto 0);
    
begin
    uut: entity work.PmodKYPD   -- Instantiate
        port map (
            reset => reset,
            clk => clk,
            LED1 => LED1,
            LED2 => LED2,
            LED3 => LED3,
            JA => JA,
            an => an,
            seg => seg
        );

    clk_process: process     -- Clock process
    begin
        while now < 1000 ns loop  -- Simulate for 1000 ns
            clk <= '0'; wait for 5 ns;
            clk <= '1'; wait for 5 ns;
        end loop;
        wait;
    end process clk_process;
    
    stimulus: process
    begin
        -- Initialize the JA, reset signals
        JA <= (others => '0');
        reset <= '1'; wait for 10 ns;
        reset <= '0'; wait for 900 ns;
        wait;
    end process stimulus;
    
end architecture testbench;

