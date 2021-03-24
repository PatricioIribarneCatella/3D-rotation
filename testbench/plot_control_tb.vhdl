
library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.numeric_std.all;

entity plot_control_tb is
end entity plot_control_tb;

architecture plot_control_tb_arq of plot_control_tb is

    constant IMAGE_PIXEL_SIZE_TB : natural := 3;
	constant MONITOR_HEIGHT : natural := 525; -- total number of lines in a frame

    signal clk_aux : std_logic := '0';
    signal rst_aux : std_logic := '1';

	 -- from VGA sync
	signal pixel_x_aux        : std_logic_vector(9 downto 0) := (others => '0');
	signal pixel_y_aux        : std_logic_vector(9 downto 0) := (others => '0');

	signal clear_done_aux     : std_logic := '0';
	signal write_done_aux     : std_logic := '0';
	signal data_available_aux : std_logic := '0';

	signal write_start_aux    : std_logic;
	signal write_enable_aux   : std_logic;
	signal clear_start_aux    : std_logic;
	signal clear_select_aux   : std_logic;
	signal plot_available_aux : std_logic;

begin

    rst_aux <= '0' after 10 ns;
    clk_aux <= not clk_aux after 20 ns;

				-- when all the image has been read
				-- from: READING_STATE to: IDLE_STATE
	pixel_y_aux <= std_logic_vector(to_unsigned(2**IMAGE_PIXEL_SIZE_TB, 10)) after 40 ns,
				-- when the all the monitor has been read
				-- from: READY_STATE to: READING_STATE
				   std_logic_vector(to_unsigned(MONITOR_HEIGHT, 10)) after 320 ns;

				-- when data its available
				-- from: IDLE_STATE to: CLEARING_STATE
	data_available_aux <= '1' after 160 ns, '0' after 200 ns;

				-- when the eraser has finished
				-- from: CLEARING_STATE to: WRITING_STATE
	clear_done_aux <= '1' after 200 ns, '0' after 220 ns;

				-- when writing has finished
				-- from: WRITING_STATE to: READY_STATE
	write_done_aux <= '1' after 240 ns, '0' after 280 ns;

  DUT: entity work.plot_control
		generic map (
			IMAGE_PIXEL_SIZE => IMAGE_PIXEL_SIZE_TB
		)
        port map (
            clk     => clk_aux,
            rst     => rst_aux,
			pixel_x => pixel_x_aux,
			pixel_y => pixel_y_aux,
			clear_done => clear_done_aux,
			write_done => write_done_aux,
			data_available => data_available_aux,
			write_start => write_start_aux,
			write_enable => write_enable_aux,
			clear_start => clear_start_aux,
			clear_select => clear_select_aux,
			plot_available => plot_available_aux
        );

end architecture plot_control_tb_arq;
