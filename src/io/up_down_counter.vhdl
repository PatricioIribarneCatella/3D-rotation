-- Up/Down counter
--
-- it represents the component in charge of
-- generating an angle every time the rising edge
-- of the clock and the enable signal its ON.
--
-- the new angle generated its "delta_phi" UP or DOWN
-- from respect to the previous angle

library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.numeric_std.all;

entity up_down_counter is
	port(
		clk      : in  std_logic;
		rst      : in  std_logic;
		up_sw    : in  std_logic;
		down_sw  : in  std_logic;
		angle    : out std_logic_vector(16 downto 0);
		enable   : in  std_logic
	);
end entity up_down_counter;

architecture up_down_counter_arq of up_down_counter is

	constant ANGLE_SIZE : natural := 17;

	constant ZERO          : std_logic_vector(ANGLE_SIZE - 1 downto 0) := (others => '0');
	constant POS_DELTA_PHI : std_logic_vector(ANGLE_SIZE - 1 downto 0)
		:= std_logic_vector(to_unsigned(256, ANGLE_SIZE));
	constant NEG_DELTA_PHI : std_logic_vector(ANGLE_SIZE - 1 downto 0)
		:= std_logic_vector(to_signed(-256, ANGLE_SIZE));

	signal sw_input : std_logic_vector(1 downto 0);

	signal delta_phi     : std_logic_vector(ANGLE_SIZE - 1 downto 0);
	signal next_angle    : std_logic_vector(ANGLE_SIZE - 1 downto 0);
	signal current_angle : std_logic_vector(ANGLE_SIZE - 1 downto 0) := ZERO;

begin

	sw_input <= up_sw & down_sw;

	delta_phi <= ZERO          when sw_input = "00" else
				 NEG_DELTA_PHI when sw_input = "01" else
				 POS_DELTA_PHI when sw_input = "10" else
				 ZERO          when sw_input = "11";

	next_angle <= std_logic_vector(signed(current_angle) + signed(delta_phi));

	ANGLE_MEM : entity work.register_mem
		generic map(
			N => ANGLE_SIZE
		)
		port map(
			clk      => clk,
			rst      => rst,
			enable   => enable,
			data_in  => next_angle,
			data_out => current_angle
		);

	angle <= current_angle;

end architecture up_down_counter_arq;
