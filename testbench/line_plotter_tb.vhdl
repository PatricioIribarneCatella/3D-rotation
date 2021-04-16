
library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.numeric_std.all;

entity line_plotter_tb is
end entity line_plotter_tb;

architecture line_plotter_tb_arq of line_plotter_tb is

    constant DATA_SIZE_TB : natural := 1;
    constant PIXEL_SIZE_TB : natural := 3;

    signal clk_aux : std_logic := '0';
    signal rst_aux : std_logic := '1';

    signal data_aux     : std_logic_vector(DATA_SIZE_TB - 1 downto 0) := "0";

	signal pixel_x0_aux : std_logic_vector(PIXEL_SIZE_TB - 1 downto 0)
		:= std_logic_vector(to_unsigned(4, PIXEL_SIZE_TB));
	signal pixel_y0_aux : std_logic_vector(PIXEL_SIZE_TB - 1 downto 0)
		:= std_logic_vector(to_unsigned(3, PIXEL_SIZE_TB));
	signal pixel_x1_aux : std_logic_vector(PIXEL_SIZE_TB - 1 downto 0)
		:= std_logic_vector(to_unsigned(7, PIXEL_SIZE_TB));
	signal pixel_y1_aux : std_logic_vector(PIXEL_SIZE_TB - 1 downto 0)
		:= std_logic_vector(to_unsigned(1, PIXEL_SIZE_TB));

	signal x_out_aux, y_out_aux : std_logic_vector(PIXEL_SIZE_TB - 1 downto 0);

	signal start_aux : std_logic := '0';
   	signal done_aux : std_logic;

begin

    rst_aux  <= '0' after 10 ns;
    clk_aux  <= not clk_aux after 20 ns;
	start_aux <= '1' after 10 ns, '0' after 280 ns;

  DUT: entity work.line_plotter
		generic map(
			DATA_SIZE => DATA_SIZE_TB,
			PIXEL_SIZE => PIXEL_SIZE_TB
		)
        port map (
            clk   => clk_aux,
            rst   => rst_aux,
			pixel_x0 => pixel_x0_aux,
			pixel_y0 => pixel_y0_aux,
			pixel_x1 => pixel_x1_aux,
			pixel_y1 => pixel_y1_aux,
			data_out => data_aux,
			x_out => x_out_aux,
			y_out => y_out_aux,
			start => start_aux,
			done => done_aux
        );

end architecture line_plotter_tb_arq;
