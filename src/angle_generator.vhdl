-- angle generator
--
-- it represents the component in charge of
-- generating the rotation angles for X, Y and Z axes
-- given the input in the button switches

library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.numeric_std.all;

entity angle_generator is
	port(
		clk        : in  std_logic;
		rst        : in  std_logic;
		sw_x_pos   : in  std_logic;
		sw_x_neg   : in  std_logic;
		sw_y_pos   : in  std_logic;
		sw_y_neg   : in  std_logic;
		sw_z_pos   : in  std_logic;
		sw_z_neg   : in  std_logic;
		alpha      : out std_logic_vector(16 downto 0);
		beta       : out std_logic_vector(16 downto 0);
		gamma      : out std_logic_vector(16 downto 0);
		start_read : in  std_logic;
		read_done  : out std_logic
	);
end entity angle_generator;

architecture angle_generator_arq of angle_generator is

	signal read_done_val : std_logic := '0';

begin

	mem : process (clk, rst) is
	begin
		if rst = '1' then
			read_done <= '0';
		elsif rising_edge(clk) then
			read_done <= read_done_val;
		end if;
	end process;

	transition : process (start_read) is
	begin
		if start_read = '1' then
			read_done_val <= '1';
		else
			read_done_val <= '0';
		end if;
	end process;

	-- up/down counter for X
	ALPHA_GENERATOR : entity work.up_down_counter
		port map(
			clk     => clk,
			rst     => rst,
			up_sw   => sw_x_pos,
			down_sw => sw_x_neg,
			enable  => start_read,
			angle   => alpha
		);

	-- up/down counter for Y
	BETA_GENERATOR : entity work.up_down_counter
		port map(
			clk     => clk,
			rst     => rst,
			up_sw   => sw_y_pos,
			down_sw => sw_y_neg,
			enable  => start_read,
			angle   => beta
		);

	-- up/down counter for Z
	GAMMA_GENERATOR : entity work.up_down_counter
		port map(
			clk     => clk,
			rst     => rst,
			up_sw   => sw_z_pos,
			down_sw => sw_z_neg,
			enable  => start_read,
			angle   => gamma
		);

end architecture angle_generator_arq;
