
library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.numeric_std.all;

entity console_tb is
end entity console_tb;

architecture console_tb_arq of console_tb is

    signal clk_aux  : std_logic := '0';
    signal rst_aux  : std_logic := '1';

	signal tx_aux       : std_logic;
	signal start_send_aux : std_logic := '0';

	signal x_aux  : std_logic_vector(15 downto 0)
		:= "0101010101010101";
	signal y_aux  : std_logic_vector(15 downto 0)
		:= "0111000011110000";
	signal z_aux  : std_logic_vector(15 downto 0)
		:= "0000111100001111";

begin

    rst_aux <= '0' after 5 ns;
    clk_aux <= not clk_aux after 10 ns; -- 50 MHz
	start_send_aux <= '1' after 20 ns, '0' after 40 ns;

	DUT: entity work.console
		port map (
			clk        => clk_aux,
			rst        => rst_aux,
			start_send => start_send_aux,
			x		   => x_aux,
			y		   => y_aux,
			z		   => z_aux,
			tx         => tx_aux
		);

end architecture console_tb_arq;
