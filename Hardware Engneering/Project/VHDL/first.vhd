library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Calculator is
    port (
        a, b: in std_logic_vector(3 downto 0);
        op: in std_logic_vector(1 downto 0);  -- 00: addition, 01: subtraction, 10: multiplication, 11: division
        result: out std_logic_vector(3 downto 0);
        error: out std_logic
        
    );
end entity Calculator;

architecture Behavioral of Calculator is
begin
    process (a, b, op)
        variable temp: signed(7 downto 0);
        variable a_signed, b_signed: signed(3 downto 0);
        variable quotient, remainder: signed(3 downto 0);
    begin
        a_signed := signed(a);
        b_signed := signed(b);
        temp := (others => '0');
        
        case op is
            when "00" =>  -- Addition operation
                temp(3 downto 0) := a_signed + b_signed;
                result <= std_logic_vector(temp(3 downto 0));
                error <= temp(4);
            when "01" =>  -- Subtraction operation
                temp(3 downto 0) := a_signed - b_signed;
                result <= std_logic_vector(temp(3 downto 0));
                error <= temp(4);
            when "10" =>  -- Multiplication operation
                temp := a_signed * b_signed;
                result <= std_logic_vector(temp(3 downto 0));
                error <= '0';
                
            when "11" =>  -- Division operation
                if b_signed /= 0 then
                    quotient := a_signed / b_signed;
                    remainder := a_signed rem b_signed;
                    result <= std_logic_vector(quotient(3 downto 0));
                    error <= remainder(0);
                    
                else
                    result <= (others => 'X');  -- Indicate division by zero with 'X' output
                    error <= '1';  -- Set overflow to indicate an error condition
                end if;
            when others =>
                result <= (others => 'X');
                error <= 'X';
        end case;
    end process;
end architecture Behavioral;

