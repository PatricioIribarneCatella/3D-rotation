-- CORDIC pre processing
--
-- it represents the component in charge of
-- adjusting the "x" and "y" vector coordinates,
-- as well as the "angle" depending on which
-- quadrant the angle is

library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.numeric_std.all;

entity pre_processing is
    port(
        x_0     : in  std_logic_vector(15 downto 0);
        y_0     : in  std_logic_vector(15 downto 0);
        angle_0 : in  std_logic_vector(16 downto 0); -- one more bit to hold large angles
        x       : out std_logic_vector(15 downto 0);
		y       : out std_logic_vector(15 downto 0);
		angle   : out std_logic_vector(15 downto 0)
    );
end entity pre_processing;

architecture pre_processing_arq of pre_processing is

	constant SIZE    : natural := 16;

	constant FIRST_CUADRANT  : std_logic_vector(1 downto 0) := "00";
	constant SECOND_CUADRANT : std_logic_vector(1 downto 0) := "01";
	constant THIRD_CUADRANT  : std_logic_vector(1 downto 0) := "10";
	constant FOURTH_CUADRANT : std_logic_vector(1 downto 0) := "11";

	-- PI representation according to the encoding
	-- used in the CORDIC algorithm
	constant PI : natural := 2**SIZE;

	signal neg_x : std_logic_vector(SIZE - 1 downto 0);
	signal neg_y : std_logic_vector(SIZE - 1 downto 0);
	signal angle_quadrant : std_logic_vector(1 downto 0);
	signal angle_plus_pi, angle_minus_pi : std_logic_vector(SIZE downto 0);

begin
	-- The first two digits of the input angle
	-- determines in which quadrant the angle is
	--
	-- 00 = FIRST_CUADRANT:  0   <= angle < 90
	-- 01 = SECOND_CUADRANT: 90  <= angle < 180
	-- 10 = THIRD_CUADRANT:  180 <= angle < 270
	-- 11 = FOURTH_CUADRANT: 270 <= angle < 360

	neg_x <= std_logic_vector(signed(not x_0) + 1);
	neg_y <= std_logic_vector(signed(not y_0) + 1);

	angle_quadrant <= angle_0(SIZE downto SIZE - 1);

	x <= x_0 when angle_quadrant = FIRST_CUADRANT else
		 neg_x when angle_quadrant = SECOND_CUADRANT else
		 neg_x when angle_quadrant = THIRD_CUADRANT else
		 x_0 when angle_quadrant = FOURTH_CUADRANT;

	y <= y_0 when angle_quadrant = FIRST_CUADRANT else
		 neg_y when angle_quadrant = SECOND_CUADRANT else
		 neg_y when angle_quadrant = THIRD_CUADRANT else
		 y_0 when angle_quadrant = FOURTH_CUADRANT;

	-- angle = angle + PI
	angle_plus_pi <= std_logic_vector(signed(angle_0) + PI);
	-- angle = angle - PI
	angle_minus_pi <= std_logic_vector(signed(angle_0) - PI);

	angle <= angle_0(SIZE - 1 downto 0) when angle_quadrant = FIRST_CUADRANT else
			 angle_minus_pi(SIZE - 1 downto 0) when angle_quadrant = SECOND_CUADRANT else
			 angle_plus_pi(SIZE - 1 downto 0) when angle_quadrant = THIRD_CUADRANT else
			 angle_0(SIZE - 1 downto 0) when angle_quadrant = FOURTH_CUADRANT;

end architecture pre_processing_arq;
