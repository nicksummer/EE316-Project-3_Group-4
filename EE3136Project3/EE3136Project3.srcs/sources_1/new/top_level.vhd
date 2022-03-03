library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity top_level is
Port ( 
     clk : in std_logic;
     led0_b : out std_logic;
     led0_g : out std_logic;
     led0_r : out std_logic;
     led1_b : out std_logic;
     led1_g : out std_logic;
     led1_r : out std_logic;
     ja     : inout std_logic_vector(7 downto 0);
     jb     : inout std_logic_vector(7 downto 0);
     btn    : in std_logic_vector(1 downto 0)
);
end top_level;


architecture Behavioral of top_level is

Component lcd_user_level is
  GENERIC(
    input_clk : INTEGER := 100_000_000 --input clock speed from user logic in Hz
    );
		port (
			iClk : in std_logic;
			reset_n  : in std_logic;
			ena      : in std_LOGIC;
			oSDA     : inout std_logic;
			oSCL     : inout std_logic;
			oRow     : out std_logic;
			oCol     : out std_logic_vector(3 downto 0);
			iData    : in std_logic_vector(7 downto 0)
		);
end component;

   component ClockGen is
        Port ( 
          Clk : in std_logic;
          ADC_data : in std_logic_vector(7 downto 0);
          reset_n  : in std_logic;
          ena      : in std_logic;
          clock_out    : out std_logic
        );
    end component;
  
    component i2c_user_level is
		port (
			iClk : in std_logic;
			reset_n  : in std_logic;
			ena      : in std_LOGIC;
			adc_channel : in std_logic_vector(7 downto 0);
		    channel_load : in std_logic;
		    led      :out std_logic;
			oSDA     : inout std_logic;
			oSCL     : inout std_logic;
			adc_data : out std_logic_vector(7 downto 0)
		);
    end component;
    
    component PWM_Generator is
		port (
			CLK : in std_logic;
			reset_n : in std_logic;
			duty_cycle : in std_logic_vector(7 downto 0);
			duty_load : in std_logic;
			PWM_out : out std_logic
		);
	end component;
		
   component btn_debounce_toggle is 
	   GENERIC (
	       CONSTANT CNTR_MAX : std_logic_vector(15 downto 0) := X"FFFF");
    Port ( BTN_I 	: in  STD_LOGIC;
           CLK 		: in  STD_LOGIC;
           BTN_O 	: out  STD_LOGIC;
           TOGGLE_O : out  STD_LOGIC
           );
    end component;

signal adc_data_sig : std_logic_vector(7 downto 0);
signal reset_sig_n : std_logic;
signal pwm_out_sig : std_logic;
signal adc_channel_sig : std_logic_vector(7 downto 0);
signal channel_load_sig : std_logic;
signal btn1_deb : std_logic;
signal btn1_deb_last : std_logic;
signal led_sig       : std_logic;
signal LCD_oRow_SIG  : std_logic;
signal LCD_oCol_SIG  : std_logic_vector(3 downto 0);
signal LCD_iData_sig : std_logic_vector(7 downto 0);
signal ena_sig       : std_logic;

TYPE ROW is array (0 to 15) of STD_LOGIC_VECTOR(7 downto 0);
	constant LDR_const            : row := (x"4c", x"44", x"52", others => x"20");
	constant Therm_const          : row := (x"54", x"68", x"65", x"72", x"6d", x"69", x"73", x"74", x"6f", x"72", others => x"20" );
	constant FUNCT_Const	      : row := (x"46", x"75", x"6e", x"63", x"74", x"69", x"6f", x"6e", x"20", x"47", x"65", x"6e", others => x"20");
	constant POT_const            : row := (x"50", x"6f", x"74", x"65", x"6e", x"74", x"69", x"6f", x"6d", x"65", x"74", x"65", x"72", others => x"20");
    constant Gen_clock_yes_const  : row := (x"43", x"6c", x"6b", x"20", x"4f", x"75", x"74", x"70", x"75", x"74", x"3a", x"20", x"59", x"45", x"53", others => x"20");
    constant Gen_clock_no_const   : row := (x"43", x"6c", x"6b", x"20", x"4f", x"75", x"74", x"70", x"75", x"74", x"3a", x"20", x"4e", x"6f", others => x"20");
begin
reset_sig_n <= not btn(0);
jb(3) <= pwm_out_sig;
--led0_r <= pwm_out_sig;
led1_r <= adc_channel_sig(0);  
led1_b <= adc_channel_sig(1);  
led1_g <= led_sig; 

ena_sig <= '0' when adc_channel_sig = "10" else '1';

process(LCD_oRow_sig, LCD_oCol_sig, adc_channel_sig)
	begin
		case adc_channel_sig is 
		  when "00" => 
		      if LCD_oRow_sig = '0' then
		          LCD_iData_sig <= LDR_const(to_integer(unsigned(LCD_oCol_sig)));
		      else
		          LCD_iData_sig <= Gen_clock_yes_const(to_integer(unsigned(LCD_oCol_sig)));
		      end if;
		 when "01" => 
		      if LCD_oRow_sig = '0' then
		          LCD_iData_sig <= Therm_const(to_integer(unsigned(LCD_oCol_sig)));
		      else
		          LCD_iData_sig <= Gen_clock_yes_const(to_integer(unsigned(LCD_oCol_sig)));
		      end if;
		 when "10" => 
		      if LCD_oRow_sig = '0' then
		          LCD_iData_sig <= Funct_const(to_integer(unsigned(LCD_oCol_sig)));
		      else
		          LCD_iData_sig <= Gen_clock_no_const(to_integer(unsigned(LCD_oCol_sig)));
		      end if; 
		  when others => 
		      if LCD_oRow_sig = '0' then
		          LCD_iData_sig <= pot_const(to_integer(unsigned(LCD_oCol_sig)));
		      else
		          LCD_iData_sig <= Gen_clock_yes_const(to_integer(unsigned(LCD_oCol_sig)));
		      end if;    
		end case;
end process;


process(clk)
begin
    if(rising_edge(clk)) then
     btn1_deb_last <= btn1_deb;
     channel_load_sig <= '0';
        if(btn1_deb_last = '0' and btn1_deb = '1') then
            adc_channel_sig(1 downto 0) <= std_LOGIC_VECTOR(to_unsigned(to_integer(unsigned( adc_channel_sig(1 downto 0))) + 1, 2));
            channel_load_sig <= '1';
        end if;
    end if;
end process;

inst_lcd_master : lcd_user_level
  GENERIC map (
    input_clk => 125_000_000 --input clock speed from user logic in Hz
    )
		port map(
			iClk => clk,
			reset_n => reset_sig_n,
			ena     => '1',
			oSDA    => jb(0), 
			oSCL    => jb(1), 
			oRow    => LCD_oRow_SIG,
			oCol    => LCD_oCol_sig,
			iData   => LCD_iData_sig
		);

inst_ClockGen : ClockGen
    port map(
          Clk => clk,
          ADC_data => adc_data_sig,
          reset_n  => reset_sig_n,
          ena      => ena_sig,
          clock_out => ja(3)    
    );

inst_pwm : pwm_generator
    port map(
     CLK => clk,
	 reset_n => reset_sig_n,
	 duty_cycle => adc_data_sig,
	 duty_load  => '1',
	 PWM_out => pwm_out_sig
      
    );
inst_i2c : i2c_user_level
    port map (
      iClk => clk,
	  reset_n => reset_sig_n,  
	  ena  => '1',
	  adc_channel => adc_channel_sig,
	  channel_load => channel_load_sig,
	  led => led_sig,
	  oSDA => ja(0),--oSDA_SIG,
	  oSCL => ja(1),--oSCL_SIG,
	  adc_data => adc_data_sig
    );
    
inst_debounce : btn_debounce_toggle
    port map(
      BTN_I => btn(1),	
      CLK   => clk,		
      BTN_O => btn1_deb	
          --TOGGLE_O => 
      );
end Behavioral;
