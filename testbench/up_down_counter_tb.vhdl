
library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.numeric_std.all;

entity up_down_counter_tb is
end entity up_down_counter_tb;

architecture up_down_counter_tb_arq of up_down_counter_tb is

	constant ANGLE_SIZE_TB : natural := 17;

    signal clk_aux : std_logic := '0';
    signal rst_aux : std_logic := '1';

	signal up_sw_aux      : std_logic := '1';
	signal down_sw_aux    : std_logic := '0';

	signal enable_aux : std_logic := '0';

	signal angle_aux : std_logic_vector(ANGLE_SIZE_TB - 1 downto 0);

begin

    rst_aux     <= '0' after 10 ns;
    clk_aux     <= not clk_aux after 20 ns;

	enable_aux <= '1' after 40 ns, '0' after 80 ns,
					  '1' after 120 ns, '0' after 160 ns,
					  '1' after 200 ns, '0' after 240 ns,
					  '1' after 280 ns, '0' after 320 ns;

	up_sw_aux   <= '0' after 80 ns, '1' after 240 ns;
	down_sw_aux <= '1' after 80 ns, '0' after 160 ns, '1' after 240 ns;

  DUT: entity work.up_down_counter
	port map (
		clk     => clk_aux,
		rst     => rst_aux,
		up_sw   => up_sw_aux,
		down_sw => down_sw_aux,
		angle   => angle_aux,
		enable  => enable_aux
	);

end architecture up_down_counter_tb_arq;
