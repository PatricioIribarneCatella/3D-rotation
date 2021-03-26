
library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.numeric_std.all;

entity angle_generator_tb is
end entity angle_generator_tb;

architecture angle_generator_tb_arq of angle_generator_tb is

    signal clk_aux : std_logic := '0';
    signal rst_aux : std_logic := '1';

	signal sw_x_pos_aux   : std_logic := '1';
	signal sw_x_neg_aux   : std_logic := '0';
	signal sw_y_pos_aux   : std_logic := '1';
	signal sw_y_neg_aux   : std_logic := '0';
	signal sw_z_pos_aux   : std_logic := '1';
	signal sw_z_neg_aux   : std_logic := '0';

	signal alpha_aux      : std_logic_vector(16 downto 0);
	signal beta_aux       : std_logic_vector(16 downto 0);
	signal gamma_aux      : std_logic_vector(16 downto 0);

	signal start_read_aux : std_logic := '0';
	signal read_done_aux  : std_logic;

begin

    rst_aux     <= '0' after 10 ns;
    clk_aux     <= not clk_aux after 20 ns;

	start_read_aux <= '1' after 40 ns, '0' after 80 ns;

  DUT: entity work.angle_generator
        port map (
            clk        => clk_aux,
            rst        => rst_aux,
			sw_x_pos   => sw_x_pos_aux,
			sw_x_neg   => sw_x_neg_aux,
			sw_y_pos   => sw_y_pos_aux,
			sw_y_neg   => sw_y_neg_aux,
			sw_z_pos   => sw_z_pos_aux,
			sw_z_neg   => sw_z_neg_aux,
			alpha      => alpha_aux,
			beta       => beta_aux,
			gamma      => gamma_aux,
			start_read => start_read_aux,
			read_done  => read_done_aux
        );

end architecture angle_generator_tb_arq;
