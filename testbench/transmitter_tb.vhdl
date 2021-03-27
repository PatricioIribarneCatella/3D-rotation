
library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.numeric_std.all;

entity transmitter_tb is
end entity transmitter_tb;

architecture transmitter_tb_arq of transmitter_tb is

	constant COUNT_MAX_TB : natural := 4;

    signal clk_aux  : std_logic := '0';
    signal rst_aux  : std_logic := '1';

	signal tx_aux      : std_logic;
	signal tx_busy_aux : std_logic;

	signal clk_tx_aux   : std_logic := '0';
	signal start_tx_aux : std_logic := '0';

	signal data_in_aux  : std_logic_vector(7 downto 0)
		:= "01010101";

	signal count : integer := 0;

begin

    rst_aux <= '0' after 10 ns;
    clk_aux <= not clk_aux after 20 ns;
	start_tx_aux <= '1' after 40 ns, '0' after 80 ns;

	counter : process (clk_aux, rst_aux) is
	begin
		if rst_aux = '1' then
			count <= 0;
			clk_tx_aux <= '0';
		elsif rising_edge(clk_aux) then
			count <= count + 1;
			if count = COUNT_MAX_TB then
				clk_tx_aux <= '1';
				count <= 0;
			else
				clk_tx_aux <= '0';
			end if;
		end if;
	end process;

	DUT: entity work.transmitter
		port map (
			clk      => clk_aux,
			rst      => rst_aux,
			tx       => tx_aux,
			tx_busy  => tx_busy_aux,
			clk_tx   => clk_tx_aux,
			start_tx => start_tx_aux,
			data_in  => data_in_aux
		);

end architecture transmitter_tb_arq;
