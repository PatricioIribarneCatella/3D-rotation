-- UART Tx
--
-- it represents the component in charge of
-- sending parallel data (with FRAME_SIZE = 8 bits)
-- into serial bits following the UART transmission protocol

library IEEE;
	use IEEE.std_logic_1164.all;
	use IEEE.numeric_std.all;

entity uart_tx is
	generic(
		F : natural := 50000 -- frequency in KHz
	);
	port(
		clk      : in  std_logic;
		rst      : in  std_logic;
		tx       : out std_logic;
		tx_busy  : out std_logic;
		start_tx : in  std_logic;
		data_in  : in  std_logic_vector(7 downto 0)
	);
end entity uart_tx;

architecture uart_tx_arq of uart_tx is

	signal clk_tx_aux : std_logic;

begin

	TIME_GEN : entity work.time_generator
		generic map(
			F => F	   
		)
		port map(
            clk     => clk,
            rst     => rst,
			clk_tx  => clk_tx_aux
		);

	TRANSMITTER : entity work.transmitter
		port map(
			clk      => clk,
			rst      => rst,
			tx       => tx,
			tx_busy  => tx_busy,
			clk_tx   => clk_tx_aux,
			start_tx => start_tx,
			data_in  => data_in
		);

end architecture uart_tx_arq;
