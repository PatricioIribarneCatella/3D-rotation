
library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.numeric_std.all;

entity plot_generator_tb is
end entity plot_generator_tb;

architecture plot_generator_tb_arq of plot_generator_tb is

	constant PIXEL_SIZE_TB : natural := 4;
	constant COORD_SIZE_TB : natural := 16;

    signal clk_aux : std_logic := '0';
    signal rst_aux : std_logic := '1';

    -- x = -0.5758 -> pixel_x = 3
	signal x_in_aux : std_logic_vector(COORD_SIZE_TB - 1 downto 0)
		:= std_logic_vector(to_signed(-9434, COORD_SIZE_TB));
    -- y = 0.8175 -> pixel_y = 1
	signal y_in_aux : std_logic_vector(COORD_SIZE_TB - 1 downto 0)
		:= std_logic_vector(to_unsigned(13384, COORD_SIZE_TB));

	signal start_draw_aux       : std_logic := '0';
	signal draw_done_aux        : std_logic;
	signal plot_available_aux   : std_logic;
	signal vsync_aux, hsync_aux : std_logic;
	signal red_out_aux          : std_logic_vector(2 downto 0);
	signal green_out_aux        : std_logic_vector(2 downto 0);
	signal blue_out_aux         : std_logic_vector(1 downto 0);

begin

    rst_aux <= '0' after 10 ns;
    clk_aux <= not clk_aux after 10 ns; -- 50 MHz clock => T = 20ns
	start_draw_aux <= '1' after 512 us, '0' after 513000 ns;

  DUT: entity work.plot_generator
		generic map (
			PIXEL_SIZE => PIXEL_SIZE_TB
		)
        port map (
            clk			   => clk_aux,
            rst			   => rst_aux,
			x_in	       => x_in_aux,
			y_in	       => y_in_aux,
			start_draw     => start_draw_aux,
			draw_done      => draw_done_aux,
			plot_available => plot_available_aux,
			vsync		   => vsync_aux,
			hsync		   => hsync_aux,
			red_out        => red_out_aux,
			green_out      => green_out_aux,
			blue_out       => blue_out_aux
        );

end architecture plot_generator_tb_arq;
