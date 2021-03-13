-- coordinate to pixel
--
-- it represents the component in charge of
-- translating the a coordinate (x, y) into
-- its correspondig mapping (pixel_x, pixel_y)
-- to write into the vector image

library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.numeric_std.all;

entity coordinate_to_pixel is
	generic(
		PIXEL_SIZE : natural := 2;
		COORD_SIZE : natural := 16
	);
	port(
		x       : in std_logic_vector(COORD_SIZE - 1 downto 0);
		y       : in std_logic_vector(COORD_SIZE - 1 downto 0);
		pixel_x : out std_logic_vector(PIXEL_SIZE - 1 downto 0);
		pixel_y : out std_logic_vector(PIXEL_SIZE - 1 downto 0)
	);
end entity coordinate_to_pixel;

architecture coordinate_to_pixel_arq of coordinate_to_pixel is

	constant ONE : natural := 2**(COORD_SIZE - 2);

	signal x_aux, y_aux : std_logic_vector(COORD_SIZE - 1 downto 0);

begin
	-- the algorithm its the following:
	--
	--	pixel_x = (x + 1) * 2**PIXEL_SIZE / RANGE_WIDTH
	--	pixel_y = (-y + 1) * 2**PIXEL_SIZE / RANGE_WIDTH
	--
	-- where RANGE_WIDTH its the width of vector coordinates
	-- in this case, this range its x, y : [-1, 1]
	--
	-- as the coordinates "x" and "y" are codified into
	-- fixed point numbers with 2 bits for the integer part
	-- and 14 bits for the decimal part, the ONE
	-- its formatted to follow this convention

	x_aux <= std_logic_vector(signed(x) + ONE);
	y_aux <= std_logic_vector(-signed(y) + ONE);

	pixel_x <= x_aux(COORD_SIZE - 2 downto COORD_SIZE - PIXEL_SIZE - 1);
	pixel_y <= y_aux(COORD_SIZE - 2 downto COORD_SIZE - PIXEL_SIZE - 1);

end architecture coordinate_to_pixel_arq;
