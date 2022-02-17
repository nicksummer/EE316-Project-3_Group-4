library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity PWM is
port(
        --IN
        clk     : in std_logic;
        reset   : in std_logic := '0';
        clk_en  : in std_logic;
        value_i : in std_logic_vector(15 downto 0);
        
        --OUT
        pwm_o   : out std_logic
    );
end PWM;

architecture Behavioral of PWM is

signal pwm      : std_logic;
signal counter  : integer range 0 to 255 := 0;

begin

pwm_o <= pwm;

PWM_Process: process(clk, clk_en, reset)
begin
    if (clk_en = '1' and reset = '0' and rising_edge(clk)) then
        if (counter >= to_integer(unsigned(value_i(15 downto 8)))) then
            pwm <= '0';
            counter <= counter + 1;
        else
            counter <= counter + 1;
            pwm <= '1';
        end if;
    elsif (reset = '1' and rising_edge(clk)) then
        pwm <= '0';
        counter <= 0;
    end if;
end process;


end Behavioral;
