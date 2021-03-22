-- cordic
--
-- it represents the component in charge of
-- rotating a vector from "(x_0, y_0)" with an
-- angle of "angle", returning "(x, y)"
--
-- its composed by three stages:
--
-- - PRE_PROCESSING: it determines the quadrant of the
--		initial vector and adjust the angle and coordinates
--
-- - MOTOR: performs the CORDIC rotation
--
-- - POST_PROCESSING: scales the resulting vector

library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.numeric_std.all;

entity cordic is
    port(
		clk    : in  std_logic;
		rst    : in  std_logic;
		start  : in  std_logic;
		x_0    : in  std_logic_vector(15 downto 0);
		y_0    : in  std_logic_vector(15 downto 0);
		angle  : in  std_logic_vector(16 downto 0); -- one more bit to hold large angles
		x      : out std_logic_vector(15 downto 0);
		y      : out std_logic_vector(15 downto 0);
		done   : out std_logic
    );
end entity cordic;

architecture cordic_arq of cordic is

	constant SIZE    : natural := 16;
	constant ROTATION_MODE : std_logic := '0';

	signal x_aux      : std_logic_vector(SIZE - 1 downto 0);
	signal x_aux_post : std_logic_vector(SIZE - 1 downto 0);
	signal y_aux      : std_logic_vector(SIZE - 1 downto 0);
	signal y_aux_post : std_logic_vector(SIZE - 1 downto 0);
	signal angle_aux  : std_logic_vector(SIZE - 1 downto 0);

begin

	PRE_PROCESSING: entity work.pre_processing
		port map (
			x_0     => x_0,
			y_0     => y_0,
			angle_0 => angle,
			x       => x_aux,
			y       => y_aux,
			angle   => angle_aux
		);
		
	MOTOR: entity work.cordic_motor
		port map (
			clk   => clk,
			rst   => rst,
			mode  => ROTATION_MODE,
			start => start,
			x_0   => x_aux,
			y_0   => y_aux,
			z_0   => angle_aux,
			x     => x_aux_post,
			y     => y_aux_post,
			done  => done
		);

	POST_PROCESSING: entity work.post_processing
		port map (
			x_0  => x_aux_post,
			y_0  => y_aux_post,
			x    => x,
			y    => y
		);

end architecture cordic_arq;
