
library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.numeric_std.all;

entity pixel_generator_tb is
end entity pixel_generator_tb;

architecture pixel_generator_tb_arq of pixel_generator_tb is

	constant DATA_SIZE_tb : natural := 1;

	signal clk_aux  : std_logic := '0';
	signal rst_aux  : std_logic := '1';

	signal data_aux : std_logic_vector(DATA_SIZE_tb - 1 downto 0) := "0";
	signal video_on_aux : std_logic := '1';

	signal red_out_aux   : std_logic_vector(2 downto 0);
	signal green_out_aux : std_logic_vector(2 downto 0);
	signal blue_out_aux  : std_logic_vector(1 downto 0);

begin

	rst_aux <= '0' after 10 ns;
	clk_aux <= not clk_aux after 20 ns;
	data_aux <= "1" after 40 ns;
	video_on_aux <= '0' after 100 ns;

  DUT: entity work.pixel_generator
        port map (
			clk   => clk_aux,
			rst   => rst_aux,
			video_on => video_on_aux,
			red_out => red_out_aux,
			green_out => green_out_aux,
			blue_out => blue_out_aux,
			data => data_aux
        );

end architecture pixel_generator_tb_arq;
