-- time generator
--
-- it represents the component in charge of
-- generating the clock time signal for
-- UART transmission
--
-- it works for 115200 bauds setting

library IEEE;
	use IEEE.std_logic_1164.all;
	use IEEE.numeric_std.all;

entity time_generator is
	generic(
		F : natural := 50000; -- frequency in KHz
		MIN_BAUD : natural := 1200
	);
	port(
		clk    : in std_logic;
		rst    : in std_logic;
		clk_tx : out std_logic
	);
end entity time_generator;

architecture time_generator_arq of time_generator is

	constant DIVISOR : natural := 27; -- for 115200 bauds
	constant MAX_DIV : natural := ((F * 1000) / (16 * MIN_BAUD));

	subtype div16_type is natural range 0 to MAX_DIV - 1;

	signal Div16  : div16_type;
	signal ClkDiv : integer;
	signal Top16  : std_logic;

begin
	-----------------------------
	-- Clk-16 Clock Generation --
	-----------------------------
	clock_16 : process (clk, rst) is
	begin
		if rst = '1' then
			Top16 <= '0';
			Div16 <= 0;
		elsif rising_edge(clk) then
			Top16 <= '0';
			if Div16 = DIVISOR then
				Div16 <= 0;
				Top16 <= '1';
			else
				Div16 <= Div16 + 1;
			end if;
		end if;
	end process;

	-------------------------
	-- Tx Clock Generation --
	-------------------------
	clock_tx : process (clk, rst) is
	begin
		if rst = '1' then
			clk_tx <= '0';
			ClkDiv <= 0;
		elsif rising_edge(clk) then
			clk_tx <= '0';
			if Top16 = '1' then
				ClkDiv <= ClkDiv + 1;
				if ClkDiv = 15 then
					clk_tx <= '1';
					ClkDiv <= 0;
				end if;
			end if;
		end if;
	end process;

end architecture time_generator_arq;
