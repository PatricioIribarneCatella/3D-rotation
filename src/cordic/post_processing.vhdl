-- CORDIC post processing
--
-- it represents the component in charge of
-- scaling the final vector result of CORDIC algorithm
-- due to the natural scaling in each CORDIC iteration

library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.numeric_std.all;
	use IEEE.MATH_REAL.all;

entity post_processing is
    port(
        x_0  : in  std_logic_vector(15 downto 0);
        y_0  : in  std_logic_vector(15 downto 0);
        x    : out std_logic_vector(15 downto 0);
		y    : out std_logic_vector(15 downto 0)
    );
end entity post_processing;

architecture post_processing_arq of post_processing is

	constant SIZE : natural := 16;

	-- inv_An = 1 / An, for the 16th iteration
	signal INV_AN : std_logic_vector(SIZE - 1 downto 0)
		:= std_logic_vector(to_unsigned(9949, SIZE)); -- 0.6072529351 aprox.

	signal x_aux : std_logic_vector(2*SIZE - 1 downto 0);
	signal y_aux : std_logic_vector(2*SIZE - 1 downto 0);

begin

	x_aux <= std_logic_vector(signed(x_0) * signed(INV_AN));
	y_aux <= std_logic_vector(signed(y_0) * signed(INV_AN));

	x <= x_aux(2*SIZE - 3 downto SIZE - 2);
	y <= y_aux(2*SIZE - 3 downto SIZE - 2);

end architecture post_processing_arq;
