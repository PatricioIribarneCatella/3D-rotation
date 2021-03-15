-- plot control
--
-- it represents the component in charge of
-- generating the control signals to write
-- and erase the images (vector and axes)

library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.numeric_std.all;

entity plot_control is
	generic(
		IMAGE_PIXEL_SIZE : natural := 4
	);
	port(
		clk            : in std_logic;
		rst            : in std_logic;
		pixel_x        : in std_logic_vector(9 downto 0); -- from VGA sync
		pixel_y        : in std_logic_vector(9 downto 0); -- from VGA sync
		clear_done     : in std_logic;
		write_done     : in std_logic;
		data_available : in std_logic;
		write_start    : out std_logic;
		write_enable   : out std_logic;
		clear_start    : out std_logic;
		clear_select   : out std_logic;
		plot_select    : out std_logic
	);
end entity plot_control;

architecture plot_control_arq of plot_control is

	constant ZERO : std_logic_vector(9 downto 0) := (others => '0');
	constant IMAGE_SIZE : natural := 2**IMAGE_PIXEL_SIZE;
	constant MONITOR_WIDTH : natural := 800; -- total number of pixels in a line
	constant MONITOR_HEIGHT : natural := 525; -- total number of lines in a frame

	type state is (
		IDLE_STATE, READING_STATE,
		CLEARING_STATE, WRITING_STATE
	);
    signal plotting_state, plotting_state_next : state;

begin

	plotting_mem : process (clk, rst) is
	begin
		if rst = '1' then
			plotting_state <= READING_STATE;
		elsif rising_edge(clk) then
			plotting_state <= plotting_state_next;
		end if;
	end process;

	plotting_transitions : process (
		plotting_state, clear_done, write_done,
		data_available, pixel_x, pixel_y
	) is
	begin
		case plotting_state is
			when IDLE_STATE =>
				if data_available = '1' and
					(to_integer(unsigned(pixel_y)) >= IMAGE_SIZE) then
					plotting_state_next <= CLEARING_STATE;
					plot_select <= '0';
					write_enable <= '1';
					clear_select <= '1';
					clear_start <= '1';
				elsif (to_integer(unsigned(pixel_x)) = MONITOR_WIDTH and
						(to_integer(unsigned(pixel_y)) < IMAGE_SIZE or
						to_integer(unsigned(pixel_y)) = MONITOR_HEIGHT)) then
					plotting_state_next <= READING_STATE;
					write_enable <= '0';
					plot_select <= '1';
				else
					plotting_state_next <= IDLE_STATE;
					write_enable <= '0';
					plot_select <= '0';
				end if;
			when READING_STATE =>
				if to_integer(unsigned(pixel_x)) = IMAGE_SIZE then
					plotting_state_next <= IDLE_STATE;
					write_enable <= '0';
					plot_select <= '0';
				else 
					plotting_state_next <= READING_STATE;
					write_enable <= '0';
					write_start <= '0';
					plot_select <= '1';
					clear_select <= '0';
					clear_start <= '0';
				end if;
			when CLEARING_STATE =>
				if clear_done = '1' then
					plotting_state_next <= WRITING_STATE;
					plot_select <= '0';
					write_enable <= '1';
					write_start <= '1';
					clear_select <= '0';
					clear_start <= '0';
				else
					plotting_state_next <= CLEARING_STATE;
					plot_select <= '0';
					write_enable <= '1';
					write_start <= '0';
					clear_select <= '1';
					clear_start <= '1';
				end if;
			when WRITING_STATE =>
				if write_done = '1' then
					plotting_state_next <= IDLE_STATE;
					plot_select <= '0';
					write_enable <= '0';
					write_start <= '0';
				else
					plot_select <= '0';
					write_enable <= '1';
					write_start <= '1';
					clear_select <= '0';
					clear_start <= '0';
				end if;
		end case;
	end process;

end architecture plot_control_arq;
