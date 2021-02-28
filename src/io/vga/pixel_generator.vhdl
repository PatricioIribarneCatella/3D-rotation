-- pixel generator
--
-- it represents the logic to generate a sigal
-- for the RGB output to the VGA monitor, given
-- an input signal of "zero" or "one",
-- and considering the value of `video_on`
--
-- if `video_on` its "zero" it returns "zero"
-- and in the other case it converts the input
-- into a RGB valid signal value

library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.numeric_std.all;

entity pixel_generator is
	generic(
		DATA_SIZE : natural := 1
	);
	port(
		data      : in std_logic_vector(DATA_SIZE - 1 downto 0);
		red_out   : out std_logic_vector(2 downto 0);
		green_out : out std_logic_vector(2 downto 0);
		blue_out  : out std_logic_vector(1 downto 0);
		video_on  : in std_logic;
		clk       : in std_logic;
		rst       : in std_logic
	);
end entity pixel_generator;

architecture pixel_generator_arq of pixel_generator is

	signal red_reg: std_logic_vector(2 downto 0);
	signal green_reg: std_logic_vector(2 downto 0);
	signal blue_reg: std_logic_vector(1 downto 0);

begin

	translator: process(clk, rst)
	begin
		if rst = '1' then
			red_reg   <= (others => '0');
			green_reg <= (others => '0');
			blue_reg  <= (others => '0');
		elsif rising_edge(clk) then
			if data = "1" then
				red_reg   <= (others => '1');
				green_reg <= (others => '1');
				blue_reg  <= (others => '1');
			else
				red_reg   <= (others => '0');
				green_reg <= (others => '0');
				blue_reg  <= (others => '0');
			end if;
		end if;
	end process;

	red_out   <= red_reg when video_on = '1' else (others => '0');
	green_out <= green_reg when video_on = '1' else (others => '0');
	blue_out  <= blue_reg when video_on = '1' else (others => '0');

end architecture pixel_generator_arq;
