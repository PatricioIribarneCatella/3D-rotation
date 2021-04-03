
library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.numeric_std.all;

entity main_tb is
end entity main_tb;

architecture main_tb_arq of main_tb is

	constant PIXEL_SIZE_TB : natural := 4; -- image of 16x16

    signal clk_aux : std_logic := '0';
    signal rst_aux : std_logic := '1';

	signal sw_x_pos_aux   : std_logic := '1';
	signal sw_x_neg_aux   : std_logic := '0';
	signal sw_y_pos_aux   : std_logic := '1';
	signal sw_y_neg_aux   : std_logic := '0';
	signal sw_z_pos_aux   : std_logic := '1';
	signal sw_z_neg_aux   : std_logic := '0';

	signal hsync_aux, vsync_aux : std_logic;
	signal tx_aux               : std_logic;
	signal red_out_aux          : std_logic_vector(2 downto 0);
	signal green_out_aux        : std_logic_vector(2 downto 0);
	signal blue_out_aux         : std_logic_vector(1 downto 0);

begin

    rst_aux <= '0' after 5 ns;
    clk_aux <= not clk_aux after 10 ns; -- 50 MHz clock

	DUT: entity work.main
		generic map (
			PIXEL_SIZE => PIXEL_SIZE_TB
		)
        port map (
            clk       => clk_aux,
            rst       => rst_aux,
			sw_x_pos  => sw_x_pos_aux,
			sw_x_neg  => sw_x_neg_aux,
			sw_y_pos  => sw_y_pos_aux,
			sw_y_neg  => sw_y_neg_aux,
			sw_z_pos  => sw_z_pos_aux,
			sw_z_neg  => sw_z_neg_aux,
			hsync     => hsync_aux,
			vsync     => vsync_aux,
			tx        => tx_aux,
			red_out   => red_out_aux,
			green_out => green_out_aux,
			blue_out  => blue_out_aux
        );

end architecture main_tb_arq;
