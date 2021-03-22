-- cordic motor
--
-- it represents the component in charge of
-- performing the CORDIC algorithm.
-- the architecture its iterative
--
-- the "x" and "y" coordinates are encoded in
-- fixed point numbers with the following convention:
--
-- x, y => | 2 bits  | 14 bits |
--         ---------------------
--         | integer | decimal |
--
-- the angle its encoded as 16 bits number
-- with the following algorithm:
--
-- angle => (radians * 2^16) / PI or
--          (angle * 2^16) / 180

library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.numeric_std.all;

entity cordic_motor is
	generic(
		ITER_MAX : natural := 16
	);
    port(
		clk   : in  std_logic;
		rst   : in  std_logic;
		mode  : in  std_logic;
		start : in  std_logic;
		x_0   : in  std_logic_vector(15 downto 0);
		y_0   : in  std_logic_vector(15 downto 0);
		z_0   : in  std_logic_vector(15 downto 0);
		x     : out std_logic_vector(15 downto 0);
		y     : out std_logic_vector(15 downto 0);
		z     : out std_logic_vector(15 downto 0);
		done  : out std_logic
    );
end entity cordic_motor;

architecture cordic_motor_arq of cordic_motor is

	constant SIZE : natural := 16;

	subtype ROM_entry is std_logic_vector(SIZE - 1 downto 0);
	type Matrix is array(0 to ITER_MAX - 1) of ROM_entry;

	constant atan_ROM : Matrix := (
		std_logic_vector(to_unsigned(16384, SIZE)),
		std_logic_vector(to_unsigned(9672, SIZE)),
		std_logic_vector(to_unsigned(5110, SIZE)),
		std_logic_vector(to_unsigned(2594, SIZE)),
		std_logic_vector(to_unsigned(1302, SIZE)),
		std_logic_vector(to_unsigned(652, SIZE)),
		std_logic_vector(to_unsigned(326, SIZE)),
		std_logic_vector(to_unsigned(163, SIZE)),
		std_logic_vector(to_unsigned(81, SIZE)),
		std_logic_vector(to_unsigned(41, SIZE)),
		std_logic_vector(to_unsigned(20, SIZE)),
		std_logic_vector(to_unsigned(10, SIZE)),
		std_logic_vector(to_unsigned(5, SIZE)),
		std_logic_vector(to_unsigned(3, SIZE)),
		std_logic_vector(to_unsigned(1, SIZE)),
		std_logic_vector(to_unsigned(1, SIZE))
	);

	signal iter : integer := 0;
	signal load : std_logic := '1';

	signal d_i : std_logic;
	signal d_i_rot_mode : std_logic;
	signal d_i_vec_mode : std_logic;

	signal x_i : std_logic_vector(SIZE - 1 downto 0);
	signal x_n : std_logic_vector(SIZE - 1 downto 0);
	signal x_aux : std_logic_vector(SIZE - 1 downto 0);
	signal shift_x_i : std_logic_vector(SIZE - 1 downto 0);
	signal op_add_x : std_logic;

	signal y_i : std_logic_vector(SIZE - 1 downto 0);
	signal y_n : std_logic_vector(SIZE - 1 downto 0);
	signal y_aux : std_logic_vector(SIZE - 1 downto 0);
	signal shift_y_i : std_logic_vector(SIZE - 1 downto 0);
	signal op_add_y : std_logic;

	signal z_i : std_logic_vector(SIZE - 1 downto 0);
	signal z_n : std_logic_vector(SIZE - 1 downto 0);
	signal z_aux : std_logic_vector(SIZE - 1 downto 0);
	signal z_tan : std_logic_vector(SIZE - 1 downto 0);
	signal op_add_z : std_logic;

	type state is (INIT, ROT, IDLE);
    signal cordic_state : state;

begin

	FSM_counter : process (clk, rst) is
	begin
		if rst = '1' then
			iter <= 0;
			load <= '1';
			cordic_state <= IDLE;
		elsif rising_edge(clk) then
			case cordic_state is
				when INIT =>
					cordic_state <= ROT;
					load <= '0';
				when ROT =>
					if iter < ITER_MAX then
						cordic_state <= ROT;
						iter <= iter + 1;
					else
						cordic_state <= IDLE;
					end if;
				when IDLE =>
					if start = '1' then
						cordic_state <= INIT;
					else
						cordic_state <= IDLE;
						iter <= 0;
						load <= '1';
					end if;
			end case;
		end if;
	end process;

	d_i_rot_mode <= z_0(SIZE - 1) when rst = '1' else z_i(SIZE - 1);
	d_i_vec_mode <= not y_0(SIZE - 1) when rst = '1' else not y_i(SIZE - 1);
	d_i <= d_i_rot_mode when mode = '0' else d_i_vec_mode;

	x <= x_n;
	y <= y_n;
	z <= z_n;

	-- notify when CORDIC has finished when ITER_MAX is reached
	done <= '1' when (iter = ITER_MAX - 1) else '0';

	-- X component

	op_add_x <= not d_i;

	x_aux <= x_0 when load = '1' else x_n;

	X_REG: entity work.register_mem
		generic map(
			N => SIZE
		)
		port map(
			data_in => x_aux,
			data_out => x_i,
			clk => clk,
			rst => rst
		);

	X_ADDER: entity work.adder
		generic map(
			N => SIZE
		)
		port map(
			a => x_i,
			b => shift_y_i,
			res => x_n,
			operation => op_add_x
		);

	X_SHIFTER: entity work.shifter
		generic map(
			N => SIZE
		)
		port map(
			data_in => y_i,
			data_out => shift_y_i,
			count => iter
		);

	-- Y component

	op_add_y <= d_i;

	y_aux <= y_0 when load = '1' else y_n;

	Y_REG: entity work.register_mem
		generic map(
			N => SIZE
		)
		port map(
			data_in => y_aux,
			data_out => y_i,
			clk => clk,
			rst => rst
		);

	Y_ADDER: entity work.adder
		generic map(
			N => SIZE
		)
		port map(
			a => y_i,
			b => shift_x_i,
			res => y_n,
			operation => op_add_y
		);

	Y_SHIFTER: entity work.shifter
		generic map(
			N => SIZE
		)
		port map(
			data_in => x_i,
			data_out => shift_x_i,
			count => iter
		);

	-- Z component

	z_aux <= z_0 when load = '1' else z_n;

	op_add_z <= not d_i;

	-- prevent CORDIC to access out of range ROM
	-- when ITER_MAX is reached
	z_tan <= atan_ROM(iter) when iter < ITER_MAX else atan_ROM(ITER_MAX - 1);

	Z_REG: entity work.register_mem
		generic map(
			N => SIZE
		)
		port map(
			data_in => z_aux,
			data_out => z_i,
			clk => clk,
			rst => rst
		);

	Z_ADDER: entity work.adder
		generic map(
			N => SIZE
		)
		port map(
			a => z_i,
			b => z_tan,
			res => z_n,
			operation => op_add_z
		);

end architecture cordic_motor_arq;
