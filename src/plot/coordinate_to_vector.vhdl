-- coordinate to vector
--
-- it represents the component that its in charge
-- of transforming a (x,y,z) -> (y,z) projected vector
-- into an image that contains the pixels to write
-- in the DUAL PORT RAM "vector" component
--
-- in each cycle it generates the output bit and
-- address to represent such vector

library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.numeric_std.all;

entity coordinate_to_vector is
	generic(
		ADDR_SIZE : natural := 4;
		DATA_SIZE : natural := 1;
		COORD_SIZE : natural := 16
	);
	port(
		clk            : in std_logic;
		rst            : in std_logic;
		x              : in std_logic_vector(COORD_SIZE - 1 downto 0);
		y              : in std_logic_vector(COORD_SIZE - 1 downto 0);
		data_out       : out std_logic_vector(DATA_SIZE - 1 downto 0);
		address_out    : out std_logic_vector(ADDR_SIZE - 1 downto 0);
		data_available : in std_logic;
		done           : out std_logic
	);
end entity coordinate_to_vector;

architecture coordinate_to_vector_arq of coordinate_to_vector is

	constant PIXEL_SIZE : natural := ADDR_SIZE / 2;

	signal pixel_x_aux : std_logic_vector(PIXEL_SIZE - 1 downto 0);
	signal pixel_y_aux : std_logic_vector(PIXEL_SIZE - 1 downto 0);

	signal x_out_aux : std_logic_vector(PIXEL_SIZE - 1 downto 0);
	signal y_out_aux : std_logic_vector(PIXEL_SIZE - 1 downto 0);

begin

	COORD_TO_PIXEL: entity work.coordinate_to_pixel
		generic map(
			COORD_SIZE => COORD_SIZE,
			PIXEL_SIZE => PIXEL_SIZE
		)
		port map(
			x => x,
			y => y,
			pixel_x => pixel_x_aux,
			pixel_y => pixel_y_aux
		);

	address_out <= y_out_aux & x_out_aux;

	VEC_PLOTTER: entity work.vector_plotter
		generic map(
			DATA_SIZE => DATA_SIZE,
			PIXEL_SIZE => PIXEL_SIZE
		)
		port map(
			clk      => clk,
			rst      => rst,
			pixel_x  => pixel_x_aux,
			pixel_y  => pixel_y_aux,
			x_out    => x_out_aux,
			y_out    => y_out_aux,
			data_out => data_out,
			start    => data_available,
			done     => done
		);

end architecture coordinate_to_vector_arq;
