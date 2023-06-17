library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity decoderFSM_tb is
end decoderFSM_tb;

architecture Behavioral of decoderFSM_tb is
    signal clk : std_logic := '0';
    signal resetIn : std_logic := '1';
    signal DecodeOut : std_logic_vector(3 downto 0) := "0000";
    signal Key1Assigned : std_logic;
    signal Key2Assigned : std_logic;
    signal Key3Assigned : std_logic;
    signal Key1Value : std_logic_vector(3 downto 0);
    signal Key2Value : std_logic_vector(3 downto 0);
    signal Key3Value : std_logic_vector(1 downto 0);
    
    constant CLK_PERIOD : time := 10 ns;  -- Example clock period, adjust as needed
    
begin
    -- Instantiate the decoderFSM module
    UUT : entity work.decoderFSM
        port map (
            clk => clk,
            reset => resetIn,  -- Modified signal name
            DecodeOut => DecodeOut,
            Key1Assigned => Key1Assigned,
            Key2Assigned => Key2Assigned,
            Key3Assigned => Key3Assigned,
            Key1Value => Key1Value,
            Key2Value => Key2Value,
            Key3Value => Key3Value
        );

    -- Clock process
    process
    begin
        while now < 1000 ns loop  -- Simulation duration, adjust as needed
            clk <= '0';
            wait for CLK_PERIOD / 2;
            clk <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
        wait;
    end process;

    -- Stimulus process
    process
    begin
        -- Provide stimulus values here
        
        -- Example: Press Key1
        DecodeOut <= "0001";
        resetIn <= '0';
        wait for CLK_PERIOD;
        
        -- Example: Press Key2
        DecodeOut <= "0010";
        resetIn <= '0';
        wait for CLK_PERIOD;
        
        -- Example: Press Key3
        DecodeOut <= "0011";
        resetIn <= '0';
        wait for CLK_PERIOD;
        
	-- Example: Press Key3
        DecodeOut <= "0000";
        resetIn <= '1';
        wait for CLK_PERIOD;

        -- Add more test cases as needed
        
        wait;
    end process;

end Behavioral;

