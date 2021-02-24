
library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.numeric_std.all;

entity vector_tb is
end entity vector_tb;

architecture vector_tb_arq of vector_tb is

	constant DATA_SIZE_tb : natural := 1;
	constant ADDR_SIZE_tb : natural := 4;

	signal clk_aux  : std_logic := '0';
	signal rst_aux  : std_logic := '1';
	signal write_enable_aux : std_logic := '1';

	signal address_in_aux  : std_logic_vector(ADDR_SIZE_tb - 1 downto 0) := "0000";
	signal address_out_aux : std_logic_vector(ADDR_SIZE_tb - 1 downto 0) := "0000";

	signal data_in_aux  : std_logic_vector(DATA_SIZE_tb - 1 downto 0) := "1";
	signal data_out_aux : std_logic_vector(DATA_SIZE_tb - 1 downto 0);

begin

	rst_aux <= '0' after 10 ns;
	clk_aux <= not clk_aux after 20 ns;
	write_enable_aux <= '0'after 40 ns;

  DUT: entity work.vector
        port map (
			clk   => clk_aux,
			rst   => rst_aux,
			write_enable => write_enable_aux,
			data_in => data_in_aux,
			address_in => address_in_aux,
			data_out => data_out_aux,
			address_out => address_out_aux
        );

end architecture vector_tb_arq;
