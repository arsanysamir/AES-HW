----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.06.2023 11:04:45
-- Design Name: 
-- Module Name: fsm decoder - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity decoderFSM is
    Port (
        clk : in STD_LOGIC;
        reset : in STD_LOGIC;
        DecodeOut : in STD_LOGIC_VECTOR (3 downto 0);
        Key1Assigned : out STD_LOGIC;
        Key2Assigned : out STD_LOGIC;
        Key3Assigned : out STD_LOGIC;
        Key1Value : out STD_LOGIC_VECTOR (3 downto 0);
        Key2Value : out STD_LOGIC_VECTOR (3 downto 0);
        Key3Value : out STD_LOGIC_VECTOR (1 downto 0)
        
    );
end decoderFSM;

architecture Behavioral of decoderFSM is
    signal prev_key : STD_LOGIC_VECTOR (3 downto 0) := "0000";
    signal key1_value : STD_LOGIC_VECTOR (3 downto 0) := "0000";
    signal key2_value : STD_LOGIC_VECTOR (3 downto 0) := "0000";
    signal key3_value : STD_LOGIC_VECTOR (1 downto 0) := "00";
    signal key1_assigned : STD_LOGIC := '0';
    signal key2_assigned : STD_LOGIC := '0';
    signal key3_assigned : STD_LOGIC := '0';
begin
    process (clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                prev_key <= "0000";
                key1_value <= "0000";
                key2_value <= "0000";
                key3_value <= "00";
                key1_assigned <= '0';
                key2_assigned <= '0';
                key3_assigned <= '0';
                
	    else
	       if DecodeOut /= prev_key then
		        if key1_assigned = '0' then
                        key1_value <= DecodeOut;
                        key1_assigned <= '1';
                elsif key2_assigned = '0' then
                        key2_value <= DecodeOut;
                        key2_assigned <= '1';
                elsif key3_assigned = '0' then
                        key3_value <= DecodeOut(1 downto 0);
                        key3_assigned <= '1';                    
                end if;
            end if;
            prev_key <= DecodeOut;
	 end if;
	 end if;
    end process;

    Key1Assigned <= key1_assigned;
    Key2Assigned <= key2_assigned;
    Key3Assigned <= key3_assigned;
    Key1Value <= key1_value;
    Key2Value <= key2_value;
    Key3Value <= key3_value;
end Behavioral;
