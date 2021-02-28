
library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.numeric_std.all;

entity vector_eraser_tb is
end entity vector_eraser_tb;

architecture vector_eraser_tb_arq of vector_eraser_tb is

    constant DATA_SIZE_TB : natural := 1;
    constant ADDR_SIZE_TB : natural := 4;

    signal clk_aux : std_logic := '0';
    signal rst_aux : std_logic := '1';

    signal address_out_aux : std_logic_vector(ADDR_SIZE_TB - 1 downto 0);
    signal data_out_aux    : std_logic_vector(DATA_SIZE_TB - 1 downto 0);

    signal clear_done_aux  : std_logic;
    signal clear_start_aux : std_logic := '1';

begin

    rst_aux <= '0' after 10 ns;
    clk_aux <= not clk_aux after 20 ns;

  DUT: entity work.vector_eraser
        port map (
            clk   => clk_aux,
            rst   => rst_aux,
            data_out => data_out_aux,
            address_out => address_out_aux,
            clear_start => clear_start_aux,
            clear_done => clear_done_aux
        );

end architecture vector_eraser_tb_arq;
