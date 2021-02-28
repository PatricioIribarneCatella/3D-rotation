
library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.numeric_std.all;

entity vga_sync_tb is
end entity vga_sync_tb;

architecture vga_sync_tb_arq of vga_sync_tb is

	signal clk_aux  : std_logic := '0';
	signal rst_aux  : std_logic := '1';

	signal hsync_aux	: std_logic;
	signal vsync_aux 	: std_logic;
	signal video_on_aux : std_logic;
	signal pixel_x_aux  : std_logic_vector(9 downto 0);
	signal pixel_y_aux  : std_logic_vector(9 downto 0);
	signal p_tick_aux   : std_logic;

begin

	rst_aux <= '0' after 5 ns;
	clk_aux <= not clk_aux after 10 ns; -- 50 MHz clock => T = 20ns

  DUT: entity work.vga_sync
        port map (
			clk      => clk_aux,
			rst      => rst_aux,
			hsync    => hsync_aux,
			vsync    => vsync_aux,
			video_on => video_on_aux,
			pixel_x  => pixel_x_aux,
			pixel_y  => pixel_y_aux,
			p_tick   => p_tick_aux
        );

end architecture vga_sync_tb_arq;
