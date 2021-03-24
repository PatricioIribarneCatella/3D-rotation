-- plot generator
--
-- it represents the component in charge of
-- rendering the rotating vector plus the axes
-- when new coordinates are available and the
-- VGA sync controller enables the input read

library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.numeric_std.all;

entity plot_generator is
	generic(
		PIXEL_SIZE : natural := 4
	);
    port(
		clk		       : in  std_logic;
		rst		       : in  std_logic;
		x_in	       : in  std_logic_vector(15 downto 0);
		y_in	       : in  std_logic_vector(15 downto 0);
		start_draw     : in  std_logic;
		draw_done      : out std_logic;
		plot_available : out std_logic;
		vsync		   : out std_logic;
		hsync		   : out std_logic;
		red_out        : out std_logic_vector(2 downto 0);
		green_out      : out std_logic_vector(2 downto 0);
		blue_out       : out std_logic_vector(1 downto 0)
    );
end entity plot_generator;

architecture plot_generator_arq of plot_generator is

	constant DATA_SIZE  : natural := 1;
	constant COORD_SIZE : natural := 16;
	constant ADDR_SIZE  : natural := PIXEL_SIZE * 2;
	constant IMAGE_SIZE : natural := 2**PIXEL_SIZE;
	constant ZERO       : std_logic_vector(DATA_SIZE - 1 downto 0) := (others => '0');

	signal video_on_vga                      : std_logic;
	signal image_select                      : std_logic;
	signal clear_done_aux, write_done_aux    : std_logic;
	signal write_start_aux, write_enable_aux : std_logic;
	signal clear_start_aux, clear_select_aux : std_logic;
	signal pixel_x_vga, pixel_y_vga          : std_logic_vector(9 downto 0);

	signal vector_data           : std_logic_vector(DATA_SIZE - 1 downto 0);
	signal eraser_data           : std_logic_vector(DATA_SIZE - 1 downto 0);
	signal data_to_store         : std_logic_vector(DATA_SIZE - 1 downto 0);
	signal vector_data_to_read   : std_logic_vector(DATA_SIZE - 1 downto 0);
	signal axes_data_to_read     : std_logic_vector(DATA_SIZE - 1 downto 0);
	signal image_data            : std_logic_vector(DATA_SIZE - 1 downto 0);
	signal pixel_data            : std_logic_vector(DATA_SIZE - 1 downto 0);
	signal vector_address        : std_logic_vector(ADDR_SIZE - 1 downto 0);
	signal eraser_address        : std_logic_vector(ADDR_SIZE - 1 downto 0);
	signal address_to_store      : std_logic_vector(ADDR_SIZE - 1 downto 0);
	signal image_address_to_read : std_logic_vector(ADDR_SIZE - 1 downto 0);

begin

	draw_done <= write_done_aux;

	PLOT_CONTROL : entity work.plot_control
		generic map(
			IMAGE_PIXEL_SIZE => PIXEL_SIZE
		)
		port map(
            clk            => clk,
            rst            => rst,
			pixel_x        => pixel_x_vga,
			pixel_y        => pixel_y_vga,
			clear_done     => clear_done_aux,
			write_done     => write_done_aux,
			data_available => start_draw,
			write_start    => write_start_aux,
			write_enable   => write_enable_aux,
			clear_start    => clear_start_aux,
			clear_select   => clear_select_aux,
			plot_available => plot_available
		);

	COORD_TO_VECTOR : entity work.coordinate_to_vector
		generic map(
			ADDR_SIZE  => ADDR_SIZE,
			DATA_SIZE  => DATA_SIZE,
			COORD_SIZE => COORD_SIZE
		)
        port map(
            clk            => clk,
            rst            => rst,
			x              => x_in,
			y              => y_in,
			data_out       => vector_data,
			address_out    => vector_address,
			data_available => write_start_aux,
			done           => write_done_aux
        );

	VECTOR_ERASER : entity work.vector_eraser
		generic map(
			DATA_SIZE => DATA_SIZE,
			ADDR_SIZE => ADDR_SIZE
		)
        port map(
            clk         => clk,
            rst         => rst,
            data_out    => eraser_data,
            address_out => eraser_address,
            clear_start => clear_start_aux,
            clear_done  => clear_done_aux
        );

	-- muxes to determine which data and address'
	-- should pass: it could be from the vector generator
	-- or from the eraser
	data_to_store <= eraser_data when clear_select_aux = '1' else vector_data;
	address_to_store <= eraser_address when clear_select_aux = '1' else vector_address;

	VECTOR : entity work.vector
		generic map(
			DATA_SIZE => DATA_SIZE,
			ADDR_SIZE => ADDR_SIZE
		)
        port map(
            clk          => clk,
            rst          => rst,
            write_enable => write_enable_aux,
            data_in      => data_to_store,
            address_in   => address_to_store,
            data_out     => vector_data_to_read,
            address_out  => image_address_to_read
        );

	AXES : entity work.axes
		generic map(
			DATA_SIZE => DATA_SIZE,
			ADDR_SIZE => ADDR_SIZE
		)
        port map(
            clk     => clk,
            rst     => rst,
            data    => axes_data_to_read,
            address => image_address_to_read
        );

	-- generates address to read from vector and
	-- axes images
	image_address_to_read <= pixel_y_vga(PIXEL_SIZE - 1 downto 0) &
							 pixel_x_vga(PIXEL_SIZE - 1 downto 0);

	-- generates final image data
	image_data <= vector_data_to_read or axes_data_to_read;

	-- logic to determine if the pixel counters are
	-- in the range of the image size
	image_select <= '1' when to_integer(unsigned(pixel_x_vga)) < IMAGE_SIZE and
							 to_integer(unsigned(pixel_y_vga)) < IMAGE_SIZE
						else '0';

	-- mux to determine if the pixel counters are
	-- in the range of the image size
	pixel_data <= image_data when image_select = '1' else ZERO;

	PIXEL_GEN : entity work.pixel_generator
		generic map(
			DATA_SIZE => DATA_SIZE
		)
        port map(
            clk       => clk,
            rst       => rst,
            video_on  => video_on_vga,
            red_out   => red_out,
            green_out => green_out,
            blue_out  => blue_out,
            data      => pixel_data 
        );

	VGA_SYNC : entity work.vga_sync
        port map(
            clk      => clk,
            rst      => rst,
            hsync    => hsync,
            vsync    => vsync,
            video_on => video_on_vga,
            pixel_x  => pixel_x_vga,
            pixel_y  => pixel_y_vga,
            p_tick   => open
        );

end architecture plot_generator_arq;
