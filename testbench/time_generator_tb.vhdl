
library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.numeric_std.all;

entity time_generator_tb is
end entity time_generator_tb;

architecture time_generator_tb_arq of time_generator_tb is

    signal clk_aux : std_logic := '0';
    signal rst_aux : std_logic := '1';

	signal clk_tx_aux : std_logic;

begin

    rst_aux     <= '0' after 5 ns;
    clk_aux     <= not clk_aux after 10 ns;

  DUT: entity work.time_generator
        port map (
            clk     => clk_aux,
            rst     => rst_aux,
			clk_tx  => clk_tx_aux
        );

end architecture time_generator_tb_arq;
