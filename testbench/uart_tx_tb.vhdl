
library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.numeric_std.all;

entity uart_tx_tb is
end entity uart_tx_tb;

architecture uart_tx_tb_arq of uart_tx_tb is

    signal clk_aux  : std_logic := '0';
    signal rst_aux  : std_logic := '1';

	signal tx_aux      : std_logic;
	signal tx_busy_aux : std_logic;

	signal start_tx_aux : std_logic := '0';

	signal data_in_aux  : std_logic_vector(7 downto 0)
		:= "01010101";

begin

    rst_aux <= '0' after 5 ns;
    clk_aux <= not clk_aux after 10 ns; -- 50 MHz
	start_tx_aux <= '1' after 40 ns, '0' after 80 ns;

	DUT: entity work.uart_tx
		port map (
			clk      => clk_aux,
			rst      => rst_aux,
			tx       => tx_aux,
			tx_busy  => tx_busy_aux,
			start_tx => start_tx_aux,
			data_in  => data_in_aux
		);

end architecture uart_tx_tb_arq;
