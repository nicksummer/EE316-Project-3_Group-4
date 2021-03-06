library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
	entity LCD_I2C_USER_LEVEL is
		port (
			iClk : in std_logic;
			reset_n  : in std_logic;
			idata    : in std_LOGIC_VECTOR(15 downto 0);
			oRow      : out std_LOGIC;
	        oCol      : out std_LOGIC_VECTOR(3 downto 0);
			ena      : in std_LOGIC;
			oSDA     : inout std_logic;
			oSCL     : inout std_logic
		);
end LCD_I2C_USER_LEVEL;

architecture Structural of LCD_I2C_USER_LEVEL is
COMPONENT LCD_I2C_MASTER IS
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

TYPE state_types IS(start, data_ready, start_i2c, wait_for_stop); --needed states
signal state: state_types := start;
signal busy_sig : std_LOGIC;
signal data_rd : STD_LOGIC_VECTOR(7 DOWNTO 0);
signal ack_error : std_LOGIC;
signal ena_sig : std_LOGIC;
signal reset_sig	: std_LOGIC;
signal data_wr_sig :std_LOGIC_VECTOR(7 downto 0);
signal byteSel    : integer range 0 to 12 := 0;
signal data       : STD_LOGIC_VECTOR(7 DOWNTO 0);
signal the_handshake : std_LOGIC;
CONSTANT counter_max : integer := 5000;
signal counter : integer range 0 to counter_max := 0;

begin

process(byteSel)
 begin
    case byteSel is
       when 0   =>    data <= X"38"; -- init seq
       when 1   =>    data <= X"38";
       when 2   =>    data <= X"38";
       when 3   =>    data <= X"38";
       when 4   =>    data <= X"38";
       when 5   =>    data <= X"38";
       when 6   =>    data <= X"01";
       when 7   =>    data <= X"0C";
       when 8   =>    data <= X"06";
       when 9   =>    data <= X"80"; --------------
	   when 26 =>     data <= X"C0"; -- command to change the line on the LCD 26 when in the new 
	   when others => data <= iData(7 downto 0);
   end case;
	
	if (byteSel < 26) then
		oRow <= '0';
	else 
		oRow <= '1';
	end if;
	
	if (byteSel <= 26) then
		oCol <= std_LOGIC_VECTOR(to_unsigned(byteSel - 10, 4));
	else 
		oCol <= std_LOGIC_VECTOR(to_unsigned(byteSel - 27, 4));
	end if;
end process;

-- byteSel choses byted int 0-10
--data_wr_sig  slave data reg
--ena_sig starts i2c

--input data the 8b data to xmit
--busy_sig  (input )i2c is busy 
--ena input starts state machine
process(iclk, busy_sig)
begin  
if(rising_edge(iClk)) then
	if(reset_n = '0') then
		state <= start;
		ena_sig <= '0';
		byteSel <= 0;
		data_wr_sig <= (others => '0');
	else
	  case state is 
	  when start =>
		if(counter = 0) then 
			counter <= counter_max;
		else
			counter <= counter - 1;
		end if;
			ena_sig <= '0';
			byteSel <= 0;
			if (ena = '1' and counter = 0) then 
				state <= data_ready; 
			end if;
		when data_ready =>
			data_wr_sig <= data;
			if (byteSel = 12) then 
				byteSel <= 7;
			else 
				byteSel <= byteSel + 1;
			end if;
				if(byteSel = 0 and ena = '0') then 
					state <= start;
				else 
					state <= start_i2c; 
				end if;
		when start_i2c =>
			ena_sig <= '1';
			if (the_handshake = '0') then 
				state <= wait_for_stop;
			end if;
		when wait_for_stop =>
			ena_sig <= '0';
			if (the_handshake = '1') then
				state <= data_ready;
			end if;
		when others =>
			state <= start;
			
	  end case;  
	 end if; 
end if;  
end process; 

 
	inst_i2c: LCD_I2C_MASTER
	generic map(
		input_clk => 125_000_000, --input clock speed from user logic in Hz
		bus_clk   => 100_000
	 )   --speed the i2c bus (scl) will run at in Hz)
		port map(
			clk  => iCLk,                 --system clock
			reset_n => reset_n,                       --active low reset
			ena     => ena_sig,                       --latch in command
			addr    => "0100111",    				  --address of target slave
			rw      => '0',                           --'0' is write, '1' is read
			data_wr => data_wr_sig,      			  --data to write to slave
			busy    => busy_sig,                      --indicates transaction in progress
			data_rd => open,   					      --data read from slave
			ack_error => ack_error,                   --flag if improper acknowledge from slave
			sda       => oSDA,                        --serial data output of i2c bus
			scl       => oSCL,                        --serial clock output of i2c bus
			the_handshake => the_handshake
		);

end Structural;

