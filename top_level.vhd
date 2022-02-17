library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top_level is
    port(
    --General
    clk         : in std_logic;
    reset       : in std_logic;
    
    --Buttons
    pwm_btn     : in std_logic;
    
    --PWM
    pwm_out     : out std_logic;
    
    --LCD (TBDone)
    lcd_en      : out std_logic;
    lcd_rs      : out std_logic;
    lcd_data    : out std_logic_vector(7 downto 0) 
    );
end top_level;

architecture Behavioral of top_level is
    --General
    signal reset_h      : std_logic := '0';
    signal clk_en_op    : std_logic;
    
    --Buttons
    signal pwm_pulse    : std_logic;
    
    --PWM
    signal pwm_on : std_logic;
    
    --Data
    signal data_m : std_logic_vector(15 downto 0); --PLACEHOLDER
    
    component PWM is
        port(
            clk     : in std_logic;
            reset   : in std_logic := '0';
            clk_en  : in std_logic;
            value_i : in std_logic_vector(15 downto 0);
            
            pwm_o   : out std_logic
        );
    end component;
    
    component btn_debounce_toggle is
        GENERIC (
            CONSTANT CNT_MAX : std_logic_vector(15 downto 0) := X"FFFF");
        Port (
            BTN_I   : in std_logic;
            CLK     : in std_logic;
            BTN_O   : out std_logic;
            PULSE_O : out std_logic;
            TOGGLE_O : out std_logic
        );
    end component;
       
begin

    Inst_btn_debounce_pwm: btn_debounce_toggle
        port map(
            BTN_I    => pwm_btn,
            CLK      => clk,
            BTN_O    => open,
            PULSE_O  => pwm_pulse,
            TOGGLE_O => open
        );
    
    Inst_PWM: PWM
        port map(
            clk => clk,
            reset => reset_h,
            clk_en => pwm_on, --CHANGE
            value_i => data_m, --CHANGE
            pwm_o => pwm_out
        );


end Behavioral;
