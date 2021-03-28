-- console
--
-- it represents the component in charge of
-- sending the X, Y and Z coordinates generated in
-- the rotation step (by the CORDIC algorithm),
-- through the UART protocol interface so it could
-- be read by TTY application
--
-- * frequency: 50 MHz
-- * baud rate: 115200
-- * coordinate format: binary

library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.numeric_std.all;

entity console is
	port(
		clk        : in std_logic;
		rst        : in std_logic;
		start_send : in std_logic;
		x          : in std_logic_vector(15 downto 0);
		y          : in std_logic_vector(15 downto 0);
		z          : in std_logic_vector(15 downto 0);
		tx         : out std_logic
	);
end entity console;

architecture console_arq of console is

	-- Line to print:
	--
	-- | x | : | x_coord | space | y | : | y_coord | space | z | : | z_coord | CR |
	-- ----------------------------------------------------------------------------
	-- | 8 | 8 |    16   |   8   | 8 | 8 |    16   |   8   | 8 | 8 |    16   |  8 | -> in bits

	constant FRAME_SIZE : natural := 8;
	constant BYTE_COUNT : natural := 15;
	constant DATA_SIZE  : natural := FRAME_SIZE * BYTE_COUNT;

	-- "x" character in ASCII
	constant X_CHAR : std_logic_vector(FRAME_SIZE - 1 downto 0)
		:= std_logic_vector(to_unsigned(120, FRAME_SIZE));
	-- "y" character in ASCII
	constant Y_CHAR : std_logic_vector(FRAME_SIZE - 1 downto 0)
		:= std_logic_vector(to_unsigned(121, FRAME_SIZE));
	-- "z" character in ASCII
	constant Z_CHAR : std_logic_vector(FRAME_SIZE - 1 downto 0)
		:= std_logic_vector(to_unsigned(122, FRAME_SIZE));

	-- ":" character in ASCII
	constant DOTS_CHAR : std_logic_vector(FRAME_SIZE - 1 downto 0)
		:= std_logic_vector(to_unsigned(58, FRAME_SIZE));
	-- "space" character in ASCII
	constant SPACE_CHAR : std_logic_vector(FRAME_SIZE - 1 downto 0)
		:= std_logic_vector(to_unsigned(32, FRAME_SIZE));
	-- "CR" character in ASCII
	constant ENTER_CHAR : std_logic_vector(FRAME_SIZE - 1 downto 0)
		:= std_logic_vector(to_unsigned(13, FRAME_SIZE));

	signal tx_busy_aux, start_tx_aux : std_logic;
	signal data_in_aux : std_logic_vector(FRAME_SIZE - 1 downto 0);
	signal data        : std_logic_vector(DATA_SIZE - 1 downto 0);

	signal data_counter : integer := BYTE_COUNT;

	type state is (
		IDLE, LOAD, SEND, STOP
	);
	signal send_state : state;

begin

	sender : process (clk, rst) is
	begin
		if rst = '1' then
			send_state <= IDLE;
			start_tx_aux <= '0';
			data_counter <= 0;
			data_in_aux <= (others => '0');
		elsif rising_edge(clk) then
			case send_state is
				when IDLE =>
					if start_send = '1' then
						data <= X_CHAR & DOTS_CHAR & x & SPACE_CHAR &
							    Y_CHAR & DOTS_CHAR & y & SPACE_CHAR &
							    Z_CHAR & DOTS_CHAR & z & ENTER_CHAR;
						send_state <= LOAD;
					else
						start_tx_aux <= '0';
						data_counter <= BYTE_COUNT;
						send_state <= IDLE;
					end if;
				when LOAD => 
					if tx_busy_aux = '1' then
						start_tx_aux <= '0';
						send_state <= SEND;
					else
						start_tx_aux <= '1';
						data_in_aux <= data(data_counter * FRAME_SIZE - 1 downto (data_counter - 1) * FRAME_SIZE);
					end if;
				when SEND =>
					if tx_busy_aux = '0' then
						if data_counter = 1 then
							start_tx_aux <= '0';
							send_state <= STOP;
						else
							data_counter <= data_counter - 1;
							send_state <= LOAD;
						end if;
					end if;
				when STOP =>
					send_state <= IDLE;
			end case;
		end if;
	end process;

	UART : entity work.uart_tx
		port map(
			clk      => clk,
			rst      => rst,
			tx       => tx,
			tx_busy  => tx_busy_aux,
			start_tx => start_tx_aux,
			data_in  => data_in_aux
		);

end architecture console_arq;
