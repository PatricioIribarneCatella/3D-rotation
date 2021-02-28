
library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.numeric_std.all;

entity axes_tb is
end entity axes_tb;

architecture axes_tb_arq of axes_tb is

    constant DATA_SIZE_TB : natural := 1;
    constant ADDR_SIZE_TB : natural := 4;

    signal clk_aux : std_logic := '0';
    signal rst_aux : std_logic := '1';

    signal address_aux : std_logic_vector(ADDR_SIZE_TB - 1 downto 0) := "0000";
    signal data_aux    : std_logic_vector(DATA_SIZE_TB - 1 downto 0);

begin

    rst_aux     <= '0' after 10 ns;
    clk_aux     <= not clk_aux after 20 ns;
    address_aux <= "0001" after 40 ns,
                   "0010" after 80 ns,
                   "0011" after 120 ns,
                   "0100" after 160 ns,
                   "0101" after 200 ns,
                   "0110" after 240 ns,
                   "0111" after 280 ns,
                   "1000" after 320 ns,
                   "1001" after 360 ns,
                   "1010" after 400 ns,
                   "1011" after 440 ns,
                   "1100" after 480 ns,
                   "1101" after 520 ns,
                   "1110" after 560 ns,
                   "1111" after 600 ns;

  DUT: entity work.axes
        port map (
            clk     => clk_aux,
            rst     => rst_aux,
            data    => data_aux,
            address => address_aux
        );

end architecture axes_tb_arq;
