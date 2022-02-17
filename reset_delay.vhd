library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity reset_delay is
    port(
        signal iClk     : in std_logic;
        signal reset_o  : out std_logic
    );
end reset_delay;

architecture Arch of reset_delay is

    signal cont : unsigned(19 downto 0) := X"00000";

    begin
    
    process
    begin
        wait until rising_edge (iClk);
        if cont /= x"FFFFF" then
            cont <= cont + 1;
            reset_o <= '1';
        else
            reset_o <= '0';
        end if;
    end process;
end Arch;
