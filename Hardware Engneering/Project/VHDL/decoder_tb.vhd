
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Decoder_tb is
end Decoder_tb;

architecture Behavioral of Decoder_tb is
    component Decoder is
        Port (
            clk : in  STD_LOGIC;
            Row : in  STD_LOGIC_VECTOR (3 downto 0);
            Col : out  STD_LOGIC_VECTOR (3 downto 0);
            DecodeOut : out  STD_LOGIC_VECTOR (3 downto 0)
        );
    end component Decoder;

    signal clk : STD_LOGIC := '0';
    signal Row : STD_LOGIC_VECTOR (3 downto 0) := "0000";
    signal Col : STD_LOGIC_VECTOR (3 downto 0);
    signal DecodeOut : STD_LOGIC_VECTOR (3 downto 0);

begin
    uut: Decoder
        port map (
            clk => clk,
            Row => Row,
            Col => Col,
            DecodeOut => DecodeOut
        );

    clk_process: process
    begin
        while now < 40 ms loop
            clk <= '0';
            wait for 0.5 ms;
            clk <= '1';
            wait for 0.5 ms;
        end loop;
        wait;
    end process;

    stimulus_process: process
    begin
        Row <= "0111";
        wait for 1 ms;
        Row <= "1011";
        wait for 1 ms;
        Row <= "1101";
        wait for 1 ms;
        Row <= "1110";
        wait for 1 ms;
        wait;
    end process;

end Behavioral;
