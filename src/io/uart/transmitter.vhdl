-- transmitter
--
-- it represents the component in charge of
-- managing the state to transmit paralle data
-- in serial format according to UART protocol
--
-- FRAME_SIZE its 8 bits long according
-- to UART protocol

library IEEE;
	use IEEE.std_logic_1164.all;
	use IEEE.numeric_std.all;

entity transmitter is
	port(
		clk      : in  std_logic;
		rst      : in  std_logic;
		tx       : out std_logic;
		tx_busy  : out std_logic;
		clk_tx   : in  std_logic;
		start_tx : in  std_logic;
		data_in  : in  std_logic_vector(7 downto 0)
	);
end entity transmitter;

architecture transmitter_arq of transmitter is

	constant FRAME_SIZE : natural := 8;

	signal tx_buffer : std_logic_vector(FRAME_SIZE downto 0);
	signal data_reg : std_logic_vector(FRAME_SIZE - 1 downto 0);

	signal tx_bit_count : natural range 0 to 15;

	type state is (
		IDLE, LOAD_TX, SHIFT_TX, STOP_TX
	);
	signal tx_state : state;

begin

	tx <= tx_buffer(0);

	TX_FSM: process (clk, rst) is
	begin
   		if rst = '1' then
			tx_buffer <= (others => '1');
			tx_bit_count <= 0;
			tx_state <= IDLE;
			tx_busy <= '0';
			data_reg <= (others => '0');
		elsif rising_edge(clk) then
			tx_busy <= '1'; -- except when explicitly '0'

			case tx_state is
				when IDLE =>
					if start_tx = '1' then
						-- latch the input data immediately.
						data_reg <= data_in;
						tx_busy <= '1';
						tx_state <= LOAD_TX;
					else
						tx_busy <= '0';
					end if;
				when LOAD_TX =>
					if clk_tx = '1' then
						tx_state <= SHIFT_TX;
						tx_bit_count <= (FRAME_SIZE + 1); -- start + data
						tx_buffer <= data_reg & '0';
					end if;
				when SHIFT_TX =>
					if clk_tx = '1' then
						tx_bit_count <= tx_bit_count - 1;
						tx_buffer <= '1' & tx_buffer(tx_buffer'high downto 1);

						if tx_bit_count = 1 then
							tx_state <= STOP_TX;
						end if;
					end if;
				when STOP_TX =>
					if clk_tx = '1' then
						tx_state <= IDLE;
					end if;
				when others =>
					tx_state <= IDLE;
			end case;
		end if;
	end process;

end architecture transmitter_arq;
