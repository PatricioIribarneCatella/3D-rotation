
library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.numeric_std.all;

entity main_control_tb is
end entity main_control_tb;

architecture main_control_tb_arq of main_control_tb is

    signal clk_aux : std_logic := '0';
    signal rst_aux : std_logic := '1';

	signal read_done_aux      : std_logic := '0';
	signal draw_done_aux      : std_logic := '0';
	signal rotate_done_aux    : std_logic := '0';
	signal plot_available_aux : std_logic := '0';

	signal start_read_aux     : std_logic;
	signal start_rotate_aux   : std_logic;
	signal start_draw_aux     : std_logic;

begin

    rst_aux     <= '0' after 10 ns;
    clk_aux     <= not clk_aux after 20 ns;

	plot_available_aux <= '1' after 40 ns, '0' after 80 ns;
	read_done_aux <= '1' after 80 ns, '0' after 120 ns;
	rotate_done_aux <= '1' after 200 ns, '0' after 240 ns;
	draw_done_aux <= '1' after 320 ns;

  DUT: entity work.main_control
        port map (
            clk            => clk_aux,
            rst            => rst_aux,
			read_done      => read_done_aux,
			draw_done      => draw_done_aux,
			rotate_done    => rotate_done_aux,
			plot_available => plot_available_aux,
			start_read     => start_read_aux,
			start_rotate   => start_rotate_aux,
			start_draw     => start_draw_aux
        );

end architecture main_control_tb_arq;
