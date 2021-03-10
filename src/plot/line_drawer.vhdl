-- line drawer
--
-- it represents the component in charge of
-- drawing a line from (x0, y0) to (x1, y1)
--
-- it uses the "Bresenham's line algorithm"
-- ref: https://en.wikipedia.org/wiki/Bresenham%27s_line_algorithm#All_cases

library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.numeric_std.all;

entity line_drawer is
	generic(
		DATA_SIZE  : natural := 1;
		PIXEL_SIZE : natural := 2
	);
	port(
		clk      : in std_logic;
		rst      : in std_logic;
		pixel_x0 : in std_logic_vector(PIXEL_SIZE - 1 downto 0);
		pixel_y0 : in std_logic_vector(PIXEL_SIZE - 1 downto 0);
		pixel_x1 : in std_logic_vector(PIXEL_SIZE - 1 downto 0);
		pixel_y1 : in std_logic_vector(PIXEL_SIZE - 1 downto 0);
		data_out : out std_logic_vector(DATA_SIZE - 1 downto 0);
		x_out    : out std_logic_vector(PIXEL_SIZE - 1 downto 0);
		y_out    : out std_logic_vector(PIXEL_SIZE - 1 downto 0);
		start    : in std_logic;
		done     : out std_logic
	);
end entity line_drawer;

architecture line_drawer_arq of line_drawer is

	signal in_loop : std_logic := '0';
	signal finished : std_logic := '0';

	signal x_next, y_next, x, y, delta_x, delta_y, dx, dy,
			x_updated, y_updated, x_aux, y_aux : signed(PIXEL_SIZE - 1 downto 0);

	signal err_next, err, err_init, err_shift_2,
			err_plus_dy, err_aux: signed(PIXEL_SIZE - 1 downto 0);
	signal err_2_greater_dy, err_2_lower_dx : std_logic;

	signal right, down : std_logic;

	type state is (IDLE_STATE, RUNNING_STATE, DONE_STATE);
    signal drawer_state : state;

begin

	x_out <= std_logic_vector(x);
	y_out <= std_logic_vector(y);
	data_out <= std_logic_vector(to_unsigned(1, DATA_SIZE));

	--
	-- FSM variables setup
	--
	done <= '1' when drawer_state = DONE_STATE else '0';
	in_loop <= '1' when drawer_state = RUNNING_STATE else '0';

	--
	-- FSM process representing
	-- the different states it can be this
	-- component: IDLE_STATE | RUNNING_STATE | DONE_STATE
	--
	FSM_loop : process (clk, rst) is
	begin
		if rst = '1' then
			drawer_state <= IDLE_STATE;
		elsif rising_edge(clk) then
			case drawer_state is
				when IDLE_STATE =>
					if start = '1' then
						drawer_state <= RUNNING_STATE;
					else
						drawer_state <= IDLE_STATE;
					end if;
				when RUNNING_STATE =>
					if finished = '1' then
						drawer_state <= DONE_STATE;
					else
						drawer_state <= RUNNING_STATE;
					end if;
				when DONE_STATE =>
					if start = '0' then
						drawer_state <= IDLE_STATE;
					elsif start = '1' then
						drawer_state <= RUNNING_STATE;
					else
						drawer_state <= DONE_STATE;
					end if;
			end case;
		end if;
	end process;

	--
	-- Bresenham algorithm variables setup
	--
	delta_x <= signed(pixel_x1) - signed(pixel_x0);
	delta_y <= signed(pixel_y1) - signed(pixel_y0);

	-- true when delta_x > 0
	right <= not delta_x(PIXEL_SIZE - 1);

	-- true when delta_y > 0
	down <= not delta_y(PIXEL_SIZE - 1);

	dx <= -delta_x when right = '0' else delta_x;
	dy <= -delta_y when down = '1' else delta_y;

	--
	-- loop iteration setup
	--
	------------------------
	-- error data circuit --
	------------------------

	err_init <= dx + dy;

	err_shift_2 <= err(PIXEL_SIZE - 2 downto 0) & '0'; -- err << 1

	err_2_greater_dy <= '1' when err_shift_2 >= dy else '0';
	err_2_lower_dx <= '1' when err_shift_2 <= dx else '0';

	err_plus_dy <= err + dy when err_2_greater_dy = '1' else err;

	err_aux <= err_plus_dy + dx when err_2_lower_dx = '1' else err_plus_dy;

	err_next <= err_aux when in_loop = '1' else err_init;

	--------------------------
	-- x and y data circuit --
	--------------------------

	--- x ---
	x_updated <= x + 1 when right = '1' else x - 1;
	x_aux <= x_updated when err_2_greater_dy = '1' else x;
	x_next <= x_aux when in_loop = '1' else signed(pixel_x0);

	--- y ---
	y_updated <= y + 1 when down = '1' else y - 1;
	y_aux <= y_updated when err_2_lower_dx = '1' else y;
	y_next <= y_aux when in_loop = '1' else signed(pixel_y0);

	finished <= '1' when x = signed(pixel_x1) and y = signed(pixel_y1) else '0';

	--
	-- loop process representing the
	-- memory component in charge of
	-- transitioning from one iteration
	-- to the next one
	--
	iterator_loop: process (clk, rst) is
	begin
		if rst = '1' then
			x <= (others => '0');
			y <= (others => '0');
			err <= (others => '0');
		elsif rising_edge(clk) then
			x <= x_next;
			y <= y_next;
			err <= err_next;
		end if;
	end process;

end architecture line_drawer_arq;
