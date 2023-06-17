library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity PmodKYPD_tb is
end PmodKYPD_tb;

architecture Behavioral of PmodKYPD_tb is

    -- Component Declarations
    component PmodKYPD is
        Port ( 
            reset: in std_logic;
            clk : in  STD_LOGIC;
            LED1: out std_logic;
            LED2: out std_logic;
            LED3: out std_logic;
            JA : inout  STD_LOGIC_VECTOR (7 downto 0);
            an : out  STD_LOGIC_VECTOR (3 downto 0);
            seg : out  STD_LOGIC_VECTOR (6 downto 0)
        );
    end component;

    -- Signal Declarations
    signal reset_signal : std_logic := '0';
    signal clk_signal : std_logic := '0';
    signal LED1_signal : std_logic;
    signal LED2_signal : std_logic;
    signal LED3_signal : std_logic;
    signal JA_signal : STD_LOGIC_VECTOR (7 downto 0);
    signal an_signal : STD_LOGIC_VECTOR (3 downto 0);
    signal seg_signal : STD_LOGIC_VECTOR (6 downto 0);

begin

    -- Instantiate the DUT (Device Under Test)
    DUT: PmodKYPD
        port map (
            reset => reset_signal,
            clk => clk_signal,
            LED1 => LED1_signal,
            LED2 => LED2_signal,
            LED3 => LED3_signal,
            JA => JA_signal,
            an => an_signal,
            seg => seg_signal
        );

    -- Stimulus Process
    stim_proc: process
    begin
        -- Initialize inputs
        reset_signal <= '1';
        clk_signal <= '0';
        JA_signal <= (others => '0');
        
        -- Wait for reset to be released
        wait for 10 ns;
        reset_signal <= '0';

        -- Generate clock with 50% duty cycle
        clk_signal <= '0';
        wait for 5 ns;
        clk_signal <= '1';
        wait for 5 ns;
        
        -- Perform test scenario here
        
        wait;
    end process;

end Behavioral;

