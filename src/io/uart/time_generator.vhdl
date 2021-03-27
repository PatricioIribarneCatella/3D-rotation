----------------------------
-- TIMING
----------------------------

library ieee;
   use ieee.std_logic_1164.all;
   use ieee.numeric_std.all;
   use ieee.std_logic_unsigned.all;

entity timing is
   generic (
      F : natural;
      min_baud: natural
   );
   port (
      CLK : in std_logic;
      RST : in std_logic;
      divisor : in std_logic_vector;
      ClrDiv : in std_logic;
      Top16 : buffer std_logic;
      TopTx : out std_logic;
      TopRx : out std_logic
   );
end timing;

-- ----------------------------------------------------
Architecture timing of timing is
-- ----------------------------------------------------
--	signal baud_value : natural;
	constant max_div : natural := ((F*1000)/(16*min_baud));
	subtype div16_type is natural range 0 to max_div-1;
	signal Div16	: div16_type;
	signal ClkDiv	: integer;
	signal RxDiv	: integer;
begin
-- --------------------------
-- Baud rate selection
-- --------------------------
--
--      process (CLK) -- baud_value setting.
--         begin
--            if rising_edge(CLK) then
--               case Baud is
--                  when "000" => baud_value <= 115200;
--                  when "001" => baud_value <= 57600;
--                  when "010" => baud_value <= 38400;
--                  when "011" => baud_value <= 19200;
--                  when "100" => baud_value <= 9600;
--                  when "101" => baud_value <= 4800;
--                  when "110" => baud_value <= 2400;
--                  when "111" => baud_value <= 1200;
--                  when others => baud_value <= 1200; -- n.u.
--               end case;
--            end if;
--      end process;
--      
-- --------------------------
-- Clk16 Clock Generation
-- --------------------------
      process (RST, CLK)
         begin
            if RST='1' then
               Top16 <= '0';
               Div16 <= 0;
            elsif rising_edge(CLK) then
               Top16 <= '0';
               if Div16 = conv_integer(divisor) then
               	  Div16 <= 0;
                  Top16 <= '1';
               else
                  Div16 <= Div16 + 1;
               end if;
            end if;
      end process;
      
-- --------------------------
-- Tx Clock Generation
-- --------------------------
      process (RST, CLK)
         begin
            if RST='1' then
               TopTx <= '0';
               ClkDiv <= 0; --(others=>'0');
            elsif rising_edge(CLK) then
               TopTx <= '0';
               if Top16='1' then
                  ClkDiv <= ClkDiv + 1;
                  if ClkDiv = 15 then
                     TopTx <= '1';
                     ClkDiv <= 0;
                  end if;
               end if;
            end if;
      end process;
      
-- ------------------------------
-- Rx Sampling Clock Generation
-- ------------------------------
      process (RST, CLK)
        begin
            if RST='1' then
               TopRx <= '0';
               RxDiv <= 0;
            elsif rising_edge(CLK) then
               TopRx <= '0';
               if ClrDiv='1' then
                  RxDiv <= 0;
               elsif Top16='1' then
                  if RxDiv = 7 then
                     RxDiv <= 0;
                     TopRx <= '1';
                  else
                    RxDiv <= RxDiv + 1;
                  end if;
               end if;
            end if;
      end process;
end architecture;
