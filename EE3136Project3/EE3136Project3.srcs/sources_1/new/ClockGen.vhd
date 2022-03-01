library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;


entity ClockGen is
    Port ( 
      Clk : in std_logic;
      ADC_data : in std_logic_vector(7 downto 0);
      reset_n  : in std_logic;
      ena      : in std_logic;
      clock_out    : out std_logic
    );
end ClockGen;
architecture Behavioral of ClockGen is
signal counter : integer := 0;
signal the_value : integer := 0;
signal clock : std_logic;
signal adc_data_sig : std_logic_vector(7 downto 0);

begin

adc_data_sig <= adc_data;
clock_out <= clock  when ena = '1' else '0';
the_value <= 125000 + 326 * to_integer(unsigned(adc_data_sig));

process(clk)
begin 
if(reset_n = '0') then
     counter <= 0;
     clock <= '0';
end if;
    if(rising_edge(Clk)) then 
       if( counter = the_value ) then
        counter <= 0;
        clock <= not clock; 
       else 
        counter <= counter + 1;
       end if;
    end if;
end process;

end Behavioral;
