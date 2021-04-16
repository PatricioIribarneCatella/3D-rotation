-- vector plotter
--
-- it represents the component in charge of
-- drawing a vector from its origin (relative to the size of the image)
-- to its final position

library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.numeric_std.all;

entity vector_plotter is
	generic(
		DATA_SIZE  : natural := 1;
		PIXEL_SIZE : natural := 2
	);
	port(
		clk         : in std_logic;
		rst         : in std_logic;
		pixel_x     : in std_logic_vector(PIXEL_SIZE - 1 downto 0);
		pixel_y     : in std_logic_vector(PIXEL_SIZE - 1 downto 0);
		x_out       : out std_logic_vector(PIXEL_SIZE - 1 downto 0);
		y_out       : out std_logic_vector(PIXEL_SIZE - 1 downto 0);
		data_out    : out std_logic_vector(DATA_SIZE - 1 downto 0);
		start       : in std_logic;
		done        : out std_logic
	);
end entity vector_plotter;

architecture vector_plotter_arq of vector_plotter is

	constant IMAGE_SIZE : natural := 2**PIXEL_SIZE;

	constant VERT_AXES_LEFT  : natural := (IMAGE_SIZE / 2) - 1;
	constant VERT_AXES_RIGHT : natural := IMAGE_SIZE / 2;
	constant HORIZ_AXES_UP   : natural := (IMAGE_SIZE / 2) - 1;
	constant HORIZ_AXES_DOWN : natural := IMAGE_SIZE / 2;

	constant PIXEL_X_FIRST_CUAD  : std_logic_vector(PIXEL_SIZE - 1 downto 0)
				:= std_logic_vector(to_unsigned(VERT_AXES_LEFT, PIXEL_SIZE));
	constant PIXEL_Y_FIRST_CUAD  : std_logic_vector(PIXEL_SIZE - 1 downto 0)
				:= std_logic_vector(to_unsigned(HORIZ_AXES_UP, PIXEL_SIZE));
	constant PIXEL_X_SECOND_CUAD : std_logic_vector(PIXEL_SIZE - 1 downto 0)
				:= std_logic_vector(to_unsigned(VERT_AXES_RIGHT, PIXEL_SIZE));
	constant PIXEL_Y_SECOND_CUAD : std_logic_vector(PIXEL_SIZE - 1 downto 0)
				:= std_logic_vector(to_unsigned(HORIZ_AXES_UP, PIXEL_SIZE));
	constant PIXEL_X_THIRD_CUAD  : std_logic_vector(PIXEL_SIZE - 1 downto 0)
				:= std_logic_vector(to_unsigned(VERT_AXES_LEFT, PIXEL_SIZE));
	constant PIXEL_Y_THIRD_CUAD  : std_logic_vector(PIXEL_SIZE - 1 downto 0)
				:= std_logic_vector(to_unsigned(HORIZ_AXES_DOWN, PIXEL_SIZE));
	constant PIXEL_X_FOURTH_CUAD : std_logic_vector(PIXEL_SIZE - 1 downto 0)
				:= std_logic_vector(to_unsigned(VERT_AXES_RIGHT, PIXEL_SIZE));
	constant PIXEL_Y_FOURTH_CUAD : std_logic_vector(PIXEL_SIZE - 1 downto 0)
				:= std_logic_vector(to_unsigned(HORIZ_AXES_DOWN, PIXEL_SIZE));

	signal pixel_x0_aux : std_logic_vector(PIXEL_SIZE - 1 downto 0);
	signal pixel_y0_aux : std_logic_vector(PIXEL_SIZE - 1 downto 0);

begin
	-- logic to obtain the center of the image (a.k.a the initial point)
	-- considering where the "pixel_x" and "pixel_y" values are (the current cuadrant)

	pixel_x0_aux <= PIXEL_Y_FIRST_CUAD when
						unsigned(pixel_x) <= VERT_AXES_LEFT and unsigned(pixel_y) <= HORIZ_AXES_UP else
					PIXEL_X_SECOND_CUAD when
						unsigned(pixel_x) >= VERT_AXES_RIGHT and unsigned(pixel_y) <= HORIZ_AXES_UP else
					PIXEL_X_THIRD_CUAD when
						unsigned(pixel_x) <= VERT_AXES_LEFT and unsigned(pixel_y) >= HORIZ_AXES_DOWN else
					PIXEL_X_FOURTH_CUAD when
						unsigned(pixel_x) >= VERT_AXES_RIGHT and unsigned(pixel_y) >= HORIZ_AXES_DOWN;

	pixel_y0_aux <= PIXEL_Y_FIRST_CUAD when
						unsigned(pixel_x) <= VERT_AXES_LEFT and unsigned(pixel_y) <= HORIZ_AXES_UP else
					PIXEL_Y_SECOND_CUAD when
						unsigned(pixel_x) >= VERT_AXES_RIGHT and unsigned(pixel_y) <= HORIZ_AXES_UP else
					PIXEL_Y_THIRD_CUAD when
						unsigned(pixel_x) <= VERT_AXES_LEFT and unsigned(pixel_y) >= HORIZ_AXES_DOWN else
					PIXEL_Y_FOURTH_CUAD when
						unsigned(pixel_x) >= VERT_AXES_RIGHT and unsigned(pixel_y) >= HORIZ_AXES_DOWN;


	LINE_PLOTTER: entity work.line_plotter
		generic map(
			DATA_SIZE => DATA_SIZE,
			PIXEL_SIZE => PIXEL_SIZE
		)
		port map(
			clk         => clk,
			rst         => rst,
			pixel_x0    => pixel_x0_aux,
			pixel_y0    => pixel_y0_aux,
			pixel_x1    => pixel_x,
			pixel_y1    => pixel_y,
			data_out    => data_out,
			x_out       => x_out,
			y_out       => y_out,
			start       => start,
			done        => done
		);

end architecture vector_plotter_arq;
