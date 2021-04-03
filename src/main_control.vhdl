-- main control
--
-- read/rotate/draw
--
-- represents the component in charge of
-- managing the logic to control the data acquisition
-- only when the plotting logic its available
-- to process it

library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.numeric_std.all;

entity main_control is
	port(
		clk            : in std_logic;
		rst            : in std_logic;
		read_done      : in std_logic;
		draw_done      : in std_logic;
		rotate_done    : in std_logic;
		plot_available : in std_logic;
		start_read     : out std_logic;
		start_rotate   : out std_logic;
		start_draw     : out std_logic
	);
end entity main_control;

architecture main_control_arq of main_control is

	type state is (
		IDLE, READING, ROTATING, DRAWING
	);
    signal current_state, next_state : state;

begin

	mem : process (clk, rst) is
	begin
		if rst = '1' then
			current_state <= IDLE;
		elsif rising_edge(clk) then
			current_state <= next_state;
		end if;
	end process;

	transitions : process (
		current_state, plot_available,
		rotate_done, read_done, draw_done
	) is
	begin
		case current_state is
			when IDLE =>
				if plot_available = '1' then
					next_state <= READING;
					start_read <= '1';
				else
					next_state <= IDLE;
					start_read <= '0';
					start_rotate <= '0';
					start_draw <= '0';
				end if;
			when READING =>
				if read_done = '1' then
					next_state <= ROTATING;
					start_read <= '0';
					start_rotate <= '1';
					start_draw <= '0';
				else
					next_state <= READING;
					start_read <= '1';
				end if;
			when ROTATING =>
				if rotate_done = '1' then
					next_state <= DRAWING;
					start_read <= '0';
					start_rotate <= '0';
				else
					next_state <= ROTATING;
					start_read <= '0';
					start_rotate <= '1';
					start_draw <= '0';
				end if;
			when DRAWING =>
				if draw_done = '1' then
					next_state <= IDLE;
					start_read <= '0';
					start_rotate <= '0';
					start_draw <= '0';
				else
					next_state <= DRAWING;
					start_read <= '0';
					start_rotate <= '0';
					start_draw <= '1';
				end if;
		end case;
	end process;

end architecture main_control_arq;
