
library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.numeric_std.all;

entity coordinate_to_pixel_tb is
end entity coordinate_to_pixel_tb;

architecture coordinate_to_pixel_tb_arq of coordinate_to_pixel_tb is

    constant PIXEL_SIZE_TB : natural := 3;
    constant COORD_SIZE_TB : natural := 16;

	signal pixel_x_aux : std_logic_vector(PIXEL_SIZE_TB - 1 downto 0);
	signal pixel_y_aux : std_logic_vector(PIXEL_SIZE_TB - 1 downto 0);

    -- x = 0.875 -> pixel_x = 7
	signal x_aux : std_logic_vector(COORD_SIZE_TB - 1 downto 0)
		:= std_logic_vector(to_unsigned(14336, COORD_SIZE_TB));
    -- y = 0.625 -> pixel_y = 1
	signal y_aux : std_logic_vector(COORD_SIZE_TB - 1 downto 0)
		:= std_logic_vector(to_unsigned(10240, COORD_SIZE_TB));

begin

			-- x = -0.375 -> pixel_x = 2
	x_aux <= std_logic_vector(to_signed(-6144, COORD_SIZE_TB)) after 40 ns,
			-- x = -0.625 -> pixel_x = 1
			 std_logic_vector(to_signed(-10240, COORD_SIZE_TB)) after 80 ns,
			-- x = 0.875 -> pixel_x = 7
			 std_logic_vector(to_unsigned(14336, COORD_SIZE_TB)) after 120 ns;

			-- y = 0.625 -> pixel_y = 1
	y_aux <= std_logic_vector(to_unsigned(10240, COORD_SIZE_TB)) after 40 ns,
			-- y = -0.375 -> pixel_y = 5
			 std_logic_vector(to_signed(-6144, COORD_SIZE_TB)) after 80 ns,
			-- y = -0.375 -> pixel_y = 5
			 std_logic_vector(to_signed(-6144, COORD_SIZE_TB)) after 120 ns;

  DUT: entity work.coordinate_to_pixel
		generic map(
			COORD_SIZE => COORD_SIZE_TB,
			PIXEL_SIZE => PIXEL_SIZE_TB
		)
        port map (
			x => x_aux,
			y => y_aux,
			pixel_x => pixel_x_aux,
			pixel_y => pixel_y_aux
        );

end architecture coordinate_to_pixel_tb_arq;
