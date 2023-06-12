library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;
use std.textio.all;

entity Calculator_TB is
end entity Calculator_TB;

architecture Behavioral of Calculator_TB is
    -- Component declaration
    component Calculator is
        port (
            a, b: in std_logic_vector(3 downto 0);
            op: in std_logic_vector(1 downto 0);
            result: out std_logic_vector(3 downto 0);
            carry_out: out std_logic;
            overflow: out std_logic
        );
    end component Calculator;

    -- Test signals
    signal a_tb, b_tb: std_logic_vector(3 downto 0);
    signal op_tb: std_logic_vector(1 downto 0);
    signal result_tb: std_logic_vector(3 downto 0);
    signal carry_out_tb, overflow_tb: std_logic;

begin
    -- Instantiate the Calculator entity
    uut: Calculator
        port map (
            a => a_tb,
            b => b_tb,
            op => op_tb,
            result => result_tb,
            carry_out => carry_out_tb,
            overflow => overflow_tb
        );

    -- Stimulus process
    stimulus: process
    begin
        -- Test case 1: Addition
        a_tb <= "0101";
        b_tb <= "0011";
        op_tb <= "00";
        wait for 10 ns;
        
        -- Test case 2: Subtraction
        a_tb <= "0110";
        b_tb <= "0011";
        op_tb <= "01";
        wait for 10 ns;

        -- Test case 3: Multiplication
        a_tb <= "0101";
        b_tb <= "0010";
        op_tb <= "10";
        wait for 10 ns;

        -- Test case 4: Division
        a_tb <= "0100";
        b_tb <= "0010";
        op_tb <= "11";
        wait for 10 ns;

        -- Test case 5: Division by zero
        a_tb <= "1100";
        b_tb <= "0000";
        op_tb <= "11";
        wait for 10 ns;

        wait;
    end process stimulus;

    -- Monitor process
    monitor: process
        variable result_str: line;
        variable carry_out_str: line;
        variable overflow_str: line;
    begin
        wait for 1 ns;
        write(result_str, result_tb);
        write(carry_out_str, carry_out_tb);
        write(overflow_str, overflow_tb);
        report "Result: " & string(result_str.all);
        report "Carry Out: " & string(carry_out_str.all);
        report "Overflow: " & string(overflow_str.all);
        wait;
    end process monitor;
end architecture Behavioral;

