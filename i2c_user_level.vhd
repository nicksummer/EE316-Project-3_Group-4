--------------------------------------------------
ADC_User_level© 2022 Nick Summerville 
--------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
	entity i2c_user_level is
		port (
			iClk : in std_logic;
			reset_n  : in std_logic;
			ena      : in std_LOGIC;
		    adc_channel : in std_logic_vector(7 downto 0);
		    channel_load : in std_logic;
		    led      : out std_logic;
			oSDA     : inout std_logic;
			oSCL     : inout std_logic;
			adc_data : out std_logic_vector(7 downto 0)
		);
end i2c_user_level;

architecture Structural of i2c_user_level is
COMPONENT i2c_master IS
  GENERIC(
    input_clk : INTEGER := 100_000_000; --input clock speed from user logic in Hz
    bus_clk   : INTEGER := 400_000);   --speed the i2c bus (scl) will run at in Hz
  PORT(
    clk       : IN     STD_LOGIC;                    --system clock
    reset_n   : IN     STD_LOGIC;                    --active low reset
    ena       : IN     STD_LOGIC;                    --latch in command
    addr      : IN     STD_LOGIC_VECTOR(6 DOWNTO 0); --address of target slave
    rw        : IN     STD_LOGIC;                    --'0' is write, '1' is read
    data_wr   : IN     STD_LOGIC_VECTOR(7 DOWNTO 0); --data to write to slave
    busy      : OUT    STD_LOGIC;                    --indicates transaction in progress
    data_rd   : OUT    STD_LOGIC_VECTOR(7 DOWNTO 0); --data read from slave
    ack_error : BUFFER STD_LOGIC;                    --flag if improper acknowledge from slave
    sda       : INOUT  STD_LOGIC;                    --serial data output of i2c bus
    scl       : INOUT  STD_LOGIC;
    the_handshake : out std_logic);                   --serial clock output of i2c bus
END component;

TYPE state_types IS(start, send_address, write_channel, read_adc_data , read_until_done); --needed states
signal state: state_types := start;
signal busy_sig : std_LOGIC;
signal data_rd : STD_LOGIC_VECTOR(7 DOWNTO 0);
signal ack_error : std_LOGIC;
signal ena_sig : std_LOGIC;
signal reset_sig	: std_LOGIC;
signal data_wr_sig :std_LOGIC_VECTOR(7 downto 0);
signal data       : STD_LOGIC_VECTOR(7 DOWNTO 0);
signal the_handshake : std_LOGIC;
CONSTANT counter_max : integer := 5000;
signal rw_sig : std_logic;
signal adc_channel_sig : std_logic_vector(7 downto 0);
signal led_n           : std_logic;
signal handshake       : std_logic;
begin

-- adc_channel <= "00000011"; -- Make Port Later to select ADC Input

-- byteSel choses byted int 0-10
--data_wr_sig  slave data reg
--ena_sig starts i2c

--input data the 8b data to xmit
--busy_sig  (input )i2c is busy 
--ena input starts state machine

--ena_sig,
--rw_sig, 
--data_wr_sig,
--busy_sig, 
--adc_data,

process(iclk)
begin
    if( rising_edge(iclk) ) then
        adc_channel_sig <= adc_channel;
    end if; 
end process;

led <= led_n;

process(iclk)
begin  
if(rising_edge(iClk)) then
	if(reset_n = '0') then
		state <= start;
		ena_sig <= '0';
		data_wr_sig <= (others => '0');
		rw_sig<='0';
		led_n <= '0';
	else

	  case state is 
	  when start => --wait for I2C to be not busy
	   ena_sig <= '0';
	   if handshake = '1' then
	       state <= send_address;
	   end if;
	   when send_address=>  --When ena=1, address slave and send adc channel
	   ena_sig <= '0';
		if (ena = '1' ) then
		    ena_sig <= '1';
		    rw_sig <= '0';
			data_wr_sig <= adc_channel_sig;
			if busy_sig = '1' then
			     state <= write_channel;
			end if; 
		end if;
		when write_channel => --drop ena and wait for write to complete
			ena_sig <= '0';
			rw_sig <= '0';
	        if (busy_sig = '0') then
	           state <= read_adc_data;
	        end if;
		when read_adc_data =>
		ena_sig <= '0';
		if ena = '1' then
			ena_sig <= '1';
		    rw_sig <= '1';
			if busy_sig='1' then
			     state <= read_until_done;
			end if;
	    end if;
		when read_until_done => --to do restart when channel changes
			ena_sig <= '1';     
		    rw_sig <= '1';
		    
		    if(channel_load = '1') then 
		      led_n <= not led_n;
		      state <= start;
		    end if;
		when others =>
			state <= start;	
	  end case;  
	 end if; 
end if;  
end process; 
 

	inst_i2cm: i2c_master
	generic map(
		input_clk => 125_000_000, --input clock speed from user logic in Hz
		bus_clk   => 100_000
	 )   --speed the i2c bus (scl) will run at in Hz)
		port map(
			clk  => iCLk,                 --system clock
			reset_n => reset_n,                          --active low reset
			ena     => ena_sig,                          --latch in command
			addr    => "1001000",    					  --address of target slave
			rw      => rw_sig,                          --'0' is write, '1' is read
			data_wr => data_wr_sig,      					     --data to write to slave
			busy    => busy_sig,                         --indicates transaction in progress
			data_rd => adc_data,   					     --data read from slave
			ack_error => ack_error,                  --flag if improper acknowledge from slave
			sda       => oSDA,                        --serial data output of i2c bus
			scl       => oSCL,                         --serial clock output of i2c bus
			the_handshake => handshake
			
		);

end Structural;
