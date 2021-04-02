-- main
--
-- it represents the component in charge of
-- holding all the other components
--
-- * main control
-- * angle generator
-- * 3D rotator
-- * plot generator
-- * console

library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.numeric_std.all;

entity main is
	port(
		clk       : in  std_logic;
		rst       : in  std_logic;
		sw_x_pos  : in  std_logic;
		sw_x_neg  : in  std_logic;
		sw_y_pos  : in  std_logic;
		sw_y_neg  : in  std_logic;
		sw_z_pos  : in  std_logic;
		sw_z_neg  : in  std_logic;
		tx        : out std_logic;
		vsync     : out std_logic;
		hsync     : out std_logic;
		red_out   : out std_logic_vector(2 downto 0);
		green_out : out std_logic_vector(2 downto 0);
		blue_out  : out std_logic_vector(1 downto 0)
	);
end entity main;

architecture main_arq of main is

	constant PIXEL_SIZE : natural := 8;
	constant COORD_SIZE : natural := 16;
	constant ANGLE_SIZE : natural := 17;

	constant X_0 : std_logic_vector(COORD_SIZE - 1 downto 0) := (others => '0');
	constant Y_0 : std_logic_vector(COORD_SIZE - 1 downto 0) := (others => '0');
	constant Z_0 : std_logic_vector(COORD_SIZE - 1 downto 0)
		:= std_logic_vector(to_unsigned(2**(COORD_SIZE - 2), COORD_SIZE));

	signal start_read_aux : std_logic;
	signal read_done_aux  : std_logic;

	signal start_rotate_aux : std_logic;
	signal rotate_done_aux  : std_logic;

	signal start_draw_aux : std_logic;
	signal draw_done_aux  : std_logic;
	signal plot_available_aux : std_logic;

	signal alpha_aux, beta_aux, gamma_aux : std_logic_vector(ANGLE_SIZE - 1 downto 0);
	signal x_out_aux, y_out_aux, z_out_aux : std_logic_vector(COORD_SIZE - 1 downto 0);
	signal x_in_monitor, y_in_monitor : std_logic_vector(COORD_SIZE - 1 downto 0);
	signal vector_coordinates_in, vector_coordinates_out :
		std_logic_vector(COORD_SIZE * 2 - 1 downto 0);

begin

	MAIN_CONTROL : entity work.main_control
        port map (
            clk            => clk,
            rst            => rst,
			read_done      => read_done_aux,
			draw_done      => draw_done_aux,
			rotate_done    => rotate_done_aux,
			plot_available => plot_available_aux,
			start_read     => start_read_aux,
			start_rotate   => start_rotate_aux,
			start_draw     => start_draw_aux
        );

	ANGLE_GENERATOR: entity work.angle_generator
        port map (
            clk        => clk,
			rst        => rst,
            sw_x_pos   => sw_x_pos,
            sw_x_neg   => sw_x_neg,
            sw_y_pos   => sw_y_pos,
            sw_y_neg   => sw_y_neg,
            sw_z_pos   => sw_z_pos,
            sw_z_neg   => sw_z_neg,
            alpha      => alpha_aux,
            beta       => beta_aux,
            gamma      => gamma_aux,
			start_read => start_read_aux,
			read_done  => read_done_aux
        );

	ROTATOR: entity work.rotator_3d
        port map (
            clk   => clk,
            rst   => rst,
            start => start_rotate_aux,
            x_in  => X_0,
            y_in  => Y_0,
            z_in  => Z_0,
            alpha => alpha_aux,
            beta  => beta_aux,
            gamma => gamma_aux,
            x_out => x_out_aux,
            y_out => y_out_aux,
			z_out => z_out_aux,
            done  => rotate_done_aux
        );

	-- latch the input when data its available
	--
	-- this is due to the fact thar "CORDIC rotator"
	-- might change the output signal after the "done"
	-- signal changes from 1 to 0

	vector_coordinates_in <= y_out_aux & z_out_aux;

	INPUT_DATA_MEM : entity work.register_mem
		generic map(
			N => COORD_SIZE * 2
		)
		port map(
            clk      => clk,
            rst      => rst,
			enable   => rotate_done_aux,
			data_in  => vector_coordinates_in,
			data_out => vector_coordinates_out
		);

	x_in_monitor <= vector_coordinates_out(COORD_SIZE * 2 - 1 downto COORD_SIZE);
	y_in_monitor <= vector_coordinates_out(COORD_SIZE - 1 downto 0);

	MONITOR: entity work.plot_generator
		generic map (
			PIXEL_SIZE => PIXEL_SIZE
		)
        port map (
            clk			   => clk,
            rst			   => rst,
			x_in	       => x_in_monitor,
			y_in	       => y_in_monitor,
			start_draw     => start_draw_aux,
			draw_done      => draw_done_aux,
			plot_available => plot_available_aux,
			vsync		   => vsync,
			hsync		   => hsync,
			red_out        => red_out,
			green_out      => green_out,
			blue_out       => blue_out
        );

	CONSOLE: entity work.console
		port map (
			clk        => clk,
			rst        => rst,
			start_send => start_draw_aux,
			x		   => x_out_aux,
			y		   => y_out_aux,
			z		   => z_out_aux,
			tx         => tx
		);

end architecture main_arq;
