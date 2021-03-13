
library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.numeric_std.all;

entity coordinate_to_vector_tb is
end entity coordinate_to_vector_tb;

architecture coordinate_to_vector_tb_arq of coordinate_to_vector_tb is

    constant DATA_SIZE_TB : natural := 1;
	constant COORD_SIZE_TB : natural := 16;
    constant PIXEL_SIZE_TB : natural := 3;
	constant ADDR_SIZE_TB : natural := PIXEL_SIZE_TB * 2;

    signal clk_aux : std_logic := '0';
    signal rst_aux : std_logic := '1';

    signal data_aux : std_logic_vector(DATA_SIZE_TB - 1 downto 0) := "0";

    -- x = 0.875 -> pixel_x = 7
	signal x_aux : std_logic_vector(COORD_SIZE_TB - 1 downto 0)
		:= std_logic_vector(to_unsigned(14336, COORD_SIZE_TB));
    -- y = 0.625 -> pixel_y = 1
	signal y_aux : std_logic_vector(COORD_SIZE_TB - 1 downto 0)
		:= std_logic_vector(to_unsigned(10240, COORD_SIZE_TB));

	signal address_out_aux : std_logic_vector(ADDR_SIZE_TB - 1 downto 0);

	signal start_aux : std_logic := '0';
   	signal done_aux : std_logic;

begin

    rst_aux  <= '0' after 10 ns;
    clk_aux  <= not clk_aux after 20 ns;
	start_aux <= '1' after 10 ns, '0' after 200 ns;

  DUT: entity work.coordinate_to_vector
		generic map(
			ADDR_SIZE => ADDR_SIZE_TB,
			DATA_SIZE => DATA_SIZE_TB,
			COORD_SIZE => COORD_SIZE_TB
		)
        port map (
            clk   => clk_aux,
            rst   => rst_aux,
			x => x_aux,
			y => y_aux,
			data_out => data_aux,
			address_out => address_out_aux,
			data_available => start_aux,
			done => done_aux
        );

end architecture coordinate_to_vector_tb_arq;
