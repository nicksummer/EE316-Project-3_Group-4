library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity lut is
    port (
        clock				: in std_logic;
		state   			: in std_logic_vector(2 downto 0);
        LCD_data            : out std_logic_vector(7 downto 0)
    );
    
end lut;


architecture structural of lut is

TYPE state_type IS(send1, send2, send3, send4, send5, send6); --needed states
signal mode      : state_type;                   --state machine
signal clk_cnt : integer range 0 to 99999;
signal clk_en : std_logic;
signal oData  : std_logic_vector(7 downto 0);
signal funcSel : integer range 0 to 36 := 0;
signal LDRSel : integer range 0 to 27 := 0;
signal TempSel : integer range 0 to 34 := 0;
signal PotSel : integer range 0 to 37 := 0;

	 
begin

process(clock)
begin
	if rising_edge(clock) then 
		if (clk_cnt = 2) then		--99999
         clk_cnt <= 0;
			clk_en <= '1';
		else
         clk_cnt <= clk_cnt + 1;
			clk_en <= '0';
      end if;
    end if;
end process;
					 
					 		 
process(funcSel, LDRSel, TempSel, PotSel)
begin

 if state = "000" or state = "100" then		-- Function Generator
	case funcSel is
		when 0 => odata <= x"30";
		when 1 => odata <= x"30";
		when 2 => odata <= x"30";
		when 3 => odata <= x"20";
		when 4 => odata <= x"28";
		when 5 => odata <= x"06";
		when 6 => odata <= x"01";
		when 7 => odata <= x"0F";
		when 8 => odata <= x"01";
		when 9 => odata <= x"0C";
		when 10 => odata <= x"06";
		when 11 => odata <= x"80";  -- 1st line
        when 12 => odata <= x"46";
        when 13 => odata <= x"55";
        when 14 => odata <= x"4E";
        when 15 => odata <= x"43";
        when 16 => odata <= x"54";
        when 17 => odata <= x"49";
        when 18 => odata <= x"4F";
        when 19 => odata <= x"4E";
        when 20 => odata <= x"20";   -- Space
        when 21 => odata <= x"47";
        when 22 => odata <= x"45";
        when 23 => odata <= x"4E";
        when 24 => odata <= x"C0";  -- 2nd line
        when 25 => odata <= x"43";
        when 26 => odata <= x"4C";
        when 27 => odata <= x"4F";
        when 28 => odata <= x"43";
        when 29 => odata <= x"4B";
        when 30 => odata <= x"20";
        when 31 => odata <= x"4F";
        when 32 => odata <= x"55";
        when 33 => odata <= x"54";
        when 34 => odata <= x"50";
        when 35 => odata <= x"55";
        when 36 => odata <= x"54";
	end case;

  elsif state = "001" or state = "101" then      -- LDR
    case LDRSel is
		when 0 => odata <= x"30";
		when 1 => odata <= x"30";
		when 2 => odata <= x"30";
		when 3 => odata <= x"20";
		when 4 => odata <= x"28";
		when 5 => odata <= x"06";
		when 6 => odata <= x"01";
		when 7 => odata <= x"0F";
		when 8 => odata <= x"01";
		when 9 => odata <= x"0C";
		when 10 => odata <= x"06";
		when 11 => odata <= x"80";  -- 1st line
        when 12 => odata <= x"4C";
        when 13 => odata <= x"44";
        when 14 => odata <= x"52";
        when 15 => odata <= x"C0";  -- 2nd line
        when 16 => odata <= x"43";
        when 17 => odata <= x"4C";
        when 18 => odata <= x"4F";
        when 19 => odata <= x"43";
        when 20 => odata <= x"4B";
        when 21 => odata <= x"20";
        when 22 => odata <= x"4F";
        when 23 => odata <= x"55";
        when 24 => odata <= x"54";
        when 25 => odata <= x"50";
        when 26 => odata <= x"55";
        when 27 => odata <= x"54";
	end case;
	
  elsif state = "010" or state = "110" then      -- TEMP
    case TempSel is
		when 0 => odata <= x"30";
		when 1 => odata <= x"30";
		when 2 => odata <= x"30";
		when 3 => odata <= x"20";
		when 4 => odata <= x"28";
		when 5 => odata <= x"06";
		when 6 => odata <= x"01";
		when 7 => odata <= x"0F";
		when 8 => odata <= x"01";
		when 9 => odata <= x"0C";
		when 10 => odata <= x"06";
		when 11 => odata <= x"80";  -- 1st line
        when 12 => odata <= x"54";
        when 13 => odata <= x"48";
        when 14 => odata <= x"45";
        when 15 => odata <= x"52";
        when 16 => odata <= x"4D";
        when 17 => odata <= x"49";
        when 18 => odata <= x"53";
        when 19 => odata <= x"54";
        when 20 => odata <= x"4F";
        when 21 => odata <= x"52";
        when 22 => odata <= x"C0";  -- 2nd line
        when 23 => odata <= x"43";
        when 24 => odata <= x"4C";
        when 25 => odata <= x"4F";
        when 26 => odata <= x"43";
        when 27 => odata <= x"4B";
        when 28 => odata <= x"20";
        when 29 => odata <= x"4F";
        when 30 => odata <= x"55";
        when 31 => odata <= x"54";
        when 32 => odata <= x"50";
        when 33 => odata <= x"55";
        when 34 => odata <= x"54";
	end case;
	
  elsif state = "011" or state = "111" then      -- POT
    case PotSel is
		when 0 => odata <= x"30";
		when 1 => odata <= x"30";
		when 2 => odata <= x"30";
		when 3 => odata <= x"20";
		when 4 => odata <= x"28";
		when 5 => odata <= x"06";
		when 6 => odata <= x"01";
		when 7 => odata <= x"0F";
		when 8 => odata <= x"01";
		when 9 => odata <= x"0C";
		when 10 => odata <= x"06";
		when 11 => odata <= x"80";  -- 1st line
        when 12 => odata <= x"50";
        when 13 => odata <= x"4F";
        when 14 => odata <= x"54";
        when 15 => odata <= x"45";
        when 16 => odata <= x"4E";
        when 17 => odata <= x"54";
        when 18 => odata <= x"49";
        when 19 => odata <= x"4F";
        when 20 => odata <= x"4D";
        when 21 => odata <= x"45";
        when 22 => odata <= x"54";
        when 23 => odata <= x"45";
        when 24 => odata <= x"52";
        when 25 => odata <= x"C0";  -- 2nd line
        when 26 => odata <= x"43";
        when 27 => odata <= x"4C";
        when 28 => odata <= x"4F";
        when 29 => odata <= x"43";
        when 30 => odata <= x"4B";
        when 31 => odata <= x"20";
        when 32 => odata <= x"4F";
        when 33 => odata <= x"55";
        when 34 => odata <= x"54";
        when 35 => odata <= x"50";
        when 36 => odata <= x"55";
        when 37 => odata <= x"54";
	end case;
  end if;
end process;
					 
	 
process(clock, clk_en)
begin
	if rising_edge(clock) and clk_en = '1' then
	  if state = "000" or state = "100" then        ------------------------ function generator ---------------------------------------
	   LDRSel <= 0;
	   TempSel <= 0;
	   PotSel <= 0;
	   case mode is
	       when send1 =>
	           LCD_data(7 downto 4) <= odata(7 downto 4);
	           if funcSel < 12 or funcSel = 24 then
	               LCD_data(3 downto 0) <= x"8";   -- RS = 0
	           else
	               LCD_data(3 downto 0) <= x"9";   -- RS = 1
	           end if;
	           mode <= send2;
	       when send2 =>
	           LCD_data(7 downto 4) <= odata(7 downto 4);
	           if funcSel < 12 or funcSel = 24 then
	               LCD_data(3 downto 0) <= x"C";   -- RS = 0
	           else
	               LCD_data(3 downto 0) <= x"D";   -- RS = 1
	           end if;
	           mode <= send3;
	       when send3 =>
	           LCD_data(7 downto 4) <= odata(7 downto 4);
	           if funcSel < 12 or funcSel = 24 then
	               LCD_data(3 downto 0) <= x"8";   -- RS = 0
	           else
	               LCD_data(3 downto 0) <= x"9";   -- RS = 1
	           end if;
	           if funcSel < 4 then
	               funcSel <= funcSel + 1;
	               mode <= send1;
	           else
	               mode <= send4;
	           end if;
	       when send4 =>
	           LCD_data(7 downto 4) <= odata(3 downto 0);
	           if funcSel < 12 or funcSel = 24 then
	               LCD_data(3 downto 0) <= x"8";   -- RS = 0
	           else
	               LCD_data(3 downto 0) <= x"9";   -- RS = 1
	           end if;
	           mode <= send5;
	       when send5 =>
	           LCD_data(7 downto 4) <= odata(3 downto 0);
	           if funcSel < 12 or funcSel = 24 then
	               LCD_data(3 downto 0) <= x"C";   -- RS = 0
	           else
	               LCD_data(3 downto 0) <= x"D";   -- RS = 1
	           end if;
	           mode <= send6;
	       when send6 =>
	           LCD_data(7 downto 4) <= odata(3 downto 0);
	           if funcSel < 12 or funcSel = 24 then
	               LCD_data(3 downto 0) <= x"8";   -- RS = 0
	           else
	               LCD_data(3 downto 0) <= x"9";   -- RS = 1
	           end if;
	           if state > "011" then
	               if funcSel < 36 then
	                   funcSel <= funcSel + 1;
	               else
	                   funcSel <= 11;
	               end if;
	           else
	               if funcSel < 23 then
	                   funcSel <= funcSel + 1;
	               else
	                   funcSel <= 11;
	               end if;
	           end if;    
	           mode <= send1;
	       when others => null;
	       end case;
	       
	  elsif state = "001" or state = "101" then     ------------------------------------- LDR --------------------------------------------------
	   funcSel <= 0;
	   TempSel <= 0;
	   PotSel <= 0;
	   case mode is
	       when send1 =>
	           LCD_data(7 downto 4) <= odata(7 downto 4);
	           if LDRSel < 12 or LDRSel = 15 then
	               LCD_data(3 downto 0) <= x"8";   -- RS = 0
	           else
	               LCD_data(3 downto 0) <= x"9";   -- RS = 1
	           end if;
	           mode <= send2;
	       when send2 =>
	           LCD_data(7 downto 4) <= odata(7 downto 4);
	           if LDRSel < 12 or LDRSel = 15 then
	               LCD_data(3 downto 0) <= x"C";   -- RS = 0
	           else
	               LCD_data(3 downto 0) <= x"D";   -- RS = 1
	           end if;
	           mode <= send3;
	       when send3 =>
	           LCD_data(7 downto 4) <= odata(7 downto 4);
	           if LDRSel < 12 or LDRSel = 15 then
	               LCD_data(3 downto 0) <= x"8";   -- RS = 0
	           else
	               LCD_data(3 downto 0) <= x"9";   -- RS = 1
	           end if;
	           if LDRSel < 4 then
	               LDRSel <= LDRSel + 1;
	               mode <= send1;
	           else
	               mode <= send4;
	           end if;
	       when send4 =>
	           LCD_data(7 downto 4) <= odata(3 downto 0);
	           if LDRSel < 12 or LDRSel = 15 then
	               LCD_data(3 downto 0) <= x"8";   -- RS = 0
	           else
	               LCD_data(3 downto 0) <= x"9";   -- RS = 1
	           end if;
	           mode <= send5;
	       when send5 =>
	           LCD_data(7 downto 4) <= odata(3 downto 0);
	           if LDRSel < 12 or LDRSel = 15 then
	               LCD_data(3 downto 0) <= x"C";   -- RS = 0
	           else
	               LCD_data(3 downto 0) <= x"D";   -- RS = 1
	           end if;
	           mode <= send6;
	       when send6 =>
	           LCD_data(7 downto 4) <= odata(3 downto 0);
	           if LDRSel < 12 or LDRSel = 15 then
	               LCD_data(3 downto 0) <= x"8";   -- RS = 0
	           else
	               LCD_data(3 downto 0) <= x"9";   -- RS = 1
	           end if;
	           if state > "011" then
	               if LDRSel < 27 then
	                   LDRSel <= LDRSel + 1;
	               else
	                   LDRSel <= 11;
	               end if;
	           else
	               if LDRSel < 14 then
	                   LDRSel <= LDRSel + 1;
	               else
	                   LDRSel <= 11;
	               end if;
	           end if;    
	           mode <= send1;
	       when others => null;
	       end case;  
	  
	  elsif state = "010" or state = "110" then        ------------------------ TEMP ---------------------------------------
	   funcSel <= 0;
	   LDRSel <= 0;
	   PotSel <= 0;
	   case mode is
	       when send1 =>
	           LCD_data(7 downto 4) <= odata(7 downto 4);
	           if TempSel < 12 or TempSel = 25 then
	               LCD_data(3 downto 0) <= x"8";   -- RS = 0
	           else
	               LCD_data(3 downto 0) <= x"9";   -- RS = 1
	           end if;
	           mode <= send2;
	       when send2 =>
	           LCD_data(7 downto 4) <= odata(7 downto 4);
	           if TempSel < 12 or TempSel = 25 then
	               LCD_data(3 downto 0) <= x"C";   -- RS = 0
	           else
	               LCD_data(3 downto 0) <= x"D";   -- RS = 1
	           end if;
	           mode <= send3;
	       when send3 =>
	           LCD_data(7 downto 4) <= odata(7 downto 4);
	           if TempSel < 12 or TempSel = 25 then
	               LCD_data(3 downto 0) <= x"8";   -- RS = 0
	           else
	               LCD_data(3 downto 0) <= x"9";   -- RS = 1
	           end if;
	           if TempSel < 4 then
	               TempSel <= TempSel + 1;
	               mode <= send1;
	           else
	               mode <= send4;
	           end if;
	       when send4 =>
	           LCD_data(7 downto 4) <= odata(3 downto 0);
	           if TempSel < 12 or TempSel = 25 then
	               LCD_data(3 downto 0) <= x"8";   -- RS = 0
	           else
	               LCD_data(3 downto 0) <= x"9";   -- RS = 1
	           end if;
	           mode <= send5;
	       when send5 =>
	           LCD_data(7 downto 4) <= odata(3 downto 0);
	           if TempSel < 12 or TempSel = 25 then
	               LCD_data(3 downto 0) <= x"C";   -- RS = 0
	           else
	               LCD_data(3 downto 0) <= x"D";   -- RS = 1
	           end if;
	           mode <= send6;
	       when send6 =>
	           LCD_data(7 downto 4) <= odata(3 downto 0);
	           if TempSel < 12 or TempSel = 25 then
	               LCD_data(3 downto 0) <= x"8";   -- RS = 0
	           else
	               LCD_data(3 downto 0) <= x"9";   -- RS = 1
	           end if;
	           if state > "011" then
	               if TempSel < 34 then
	                   TempSel <= TempSel + 1;
	               else
	                   TempSel <= 11;
	               end if;
	           else
	               if TempSel < 21 then
	                   TempSel <= TempSel + 1;
	               else
	                   TempSel <= 11;
	               end if;
	           end if;    
	           mode <= send1;
	       when others => null;
	       end case;
	     
	  elsif state = "011" or state = "111" then        ------------------------ POT ---------------------------------------
	   funcSel <= 0;
	   LDRSel <= 0;
	   TempSel <= 0;
	   case mode is
	       when send1 =>
	           LCD_data(7 downto 4) <= odata(7 downto 4);
	           if PotSel < 12 or PotSel = 22 then
	               LCD_data(3 downto 0) <= x"8";   -- RS = 0
	           else
	               LCD_data(3 downto 0) <= x"9";   -- RS = 1
	           end if;
	           mode <= send2;
	       when send2 =>
	           LCD_data(7 downto 4) <= odata(7 downto 4);
	           if PotSel < 12 or PotSel = 22 then
	               LCD_data(3 downto 0) <= x"C";   -- RS = 0
	           else
	               LCD_data(3 downto 0) <= x"D";   -- RS = 1
	           end if;
	           mode <= send3;
	       when send3 =>
	           LCD_data(7 downto 4) <= odata(7 downto 4);
	           if PotSel < 12 or PotSel = 22 then
	               LCD_data(3 downto 0) <= x"8";   -- RS = 0
	           else
	               LCD_data(3 downto 0) <= x"9";   -- RS = 1
	           end if;
	           if PotSel < 4 then
	               PotSel <= PotSel + 1;
	               mode <= send1;
	           else
	               mode <= send4;
	           end if;
	       when send4 =>
	           LCD_data(7 downto 4) <= odata(3 downto 0);
	           if PotSel < 12 or PotSel = 22 then
	               LCD_data(3 downto 0) <= x"8";   -- RS = 0
	           else
	               LCD_data(3 downto 0) <= x"9";   -- RS = 1
	           end if;
	           mode <= send5;
	       when send5 =>
	           LCD_data(7 downto 4) <= odata(3 downto 0);
	           if PotSel < 12 or PotSel = 22 then
	               LCD_data(3 downto 0) <= x"C";   -- RS = 0
	           else
	               LCD_data(3 downto 0) <= x"D";   -- RS = 1
	           end if;
	           mode <= send6;
	       when send6 =>
	           LCD_data(7 downto 4) <= odata(3 downto 0);
	           if PotSel < 12 or PotSel = 22 then
	               LCD_data(3 downto 0) <= x"8";   -- RS = 0
	           else
	               LCD_data(3 downto 0) <= x"9";   -- RS = 1
	           end if;
	           if state > "011" then
	               if PotSel < 37 then
	                   PotSel <= PotSel + 1;
	               else
	                   PotSel <= 11;
	               end if;
	           else
	               if PotSel < 24 then
	                   PotSel <= PotSel + 1;
	               else
	                   PotSel <= 11;
	               end if;
	           end if;    
	           mode <= send1;
	       when others => null;
	       end case;   
	  end if;
	end if;
end process;		 
					 
end structural;

