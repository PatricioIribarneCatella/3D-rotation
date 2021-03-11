
library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.numeric_std.all;

entity vector_drawer_tb is
end entity vector_drawer_tb;

architecture vector_drawer_tb_arq of vector_drawer_tb is

    constant DATA_SIZE_TB : natural := 1;
    constant PIXEL_SIZE_TB : natural := 4;

    signal clk_aux : std_logic := '0';
    signal rst_aux : std_logic := '1';

    signal data_aux     : std_logic_vector(DATA_SIZE_TB - 1 downto 0) := "0";

	-- FIRST_CUADRANT final point
	signal pixel_x_aux : std_logic_vector(PIXEL_SIZE_TB - 1 downto 0)
		:= std_logic_vector(to_unsigned(2, PIXEL_SIZE_TB));
	signal pixel_y_aux : std_logic_vector(PIXEL_SIZE_TB - 1 downto 0)
		:= std_logic_vector(to_unsigned(2, PIXEL_SIZE_TB));

	signal x_out_aux, y_out_aux : std_logic_vector(PIXEL_SIZE_TB - 1 downto 0);

	signal start_aux : std_logic := '0';
   	signal done_aux : std_logic;

begin

    rst_aux  <= '0' after 10 ns;
    clk_aux  <= not clk_aux after 20 ns;
	start_aux <= '1' after 10 ns;

					-- SECOND_CUADRANT final point
	pixel_x_aux <= std_logic_vector(to_unsigned(13, PIXEL_SIZE_TB)) after 280 ns,
					-- THIRD_CUADRANT final point
				   std_logic_vector(to_unsigned(2, PIXEL_SIZE_TB)) after 560 ns,
					-- FOURTH_CUADRANT final point
				   std_logic_vector(to_unsigned(13, PIXEL_SIZE_TB)) after 840 ns;

					-- SECOND_CUADRANT final point
	pixel_y_aux <= std_logic_vector(to_unsigned(2, PIXEL_SIZE_TB)) after 280 ns,
					-- THIRD_CUADRANT final point
				   std_logic_vector(to_unsigned(13, PIXEL_SIZE_TB)) after 560 ns,
					-- FOURTH_CUADRANT final point
				   std_logic_vector(to_unsigned(13, PIXEL_SIZE_TB)) after 840 ns;

  DUT: entity work.vector_drawer
		generic map(
			DATA_SIZE => DATA_SIZE_TB,
			PIXEL_SIZE => PIXEL_SIZE_TB
		)
        port map (
            clk   => clk_aux,
            rst   => rst_aux,
			pixel_x => pixel_x_aux,
			pixel_y => pixel_y_aux,
			x_out => x_out_aux,
			y_out => y_out_aux,
			data_out => data_aux,
			start => start_aux,
			done => done_aux
        );

end architecture vector_drawer_tb_arq;
