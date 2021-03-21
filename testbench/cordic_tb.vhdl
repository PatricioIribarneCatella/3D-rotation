
library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.numeric_std.all;

entity cordic_tb is
end entity cordic_tb;

architecture cordic_tb_arq of cordic_tb is

    constant N_TB : natural := 16;

    signal clk_aux  : std_logic := '0';
    signal rst_aux  : std_logic := '1';
    signal load_aux : std_logic := '1';
    signal done_aux : std_logic;

    -- x: 1
    signal x_0_aux : std_logic_vector(N_TB - 1 downto 0) := std_logic_vector(to_unsigned(16384, N_TB));
    -- y: 0
    signal y_0_aux : std_logic_vector(N_TB - 1 downto 0) := std_logic_vector(to_unsigned(0, N_TB));

    -- ang: 10
    signal angle_aux : std_logic_vector(N_TB downto 0) := std_logic_vector(to_unsigned(3641, N_TB + 1));
    -- ang: 100
    --signal angle_aux : std_logic_vector(N_TB downto 0) := std_logic_vector(to_unsigned(36409, N_TB + 1));
    -- ang: 200
    --signal angle_aux : std_logic_vector(N_TB downto 0) := std_logic_vector(to_unsigned(72818, N_TB + 1));
    -- ang: 300
    --signal angle_aux : std_logic_vector(N_TB downto 0) := std_logic_vector(to_unsigned(109227, N_TB + 1));
    -- ang: -135
    --signal angle_aux : std_logic_vector(N_TB downto 0) := std_logic_vector(to_signed(-49152, N_TB + 1));

    signal x_aux : std_logic_vector(N_TB - 1 downto 0);
    signal y_aux : std_logic_vector(N_TB - 1 downto 0);

begin

    rst_aux  <= '0' after 10 ns;
    load_aux <= '0' after 40 ns;
    clk_aux  <= not clk_aux after 20 ns;

  DUT: entity work.cordic
        port map (
            clk   => clk_aux,
            rst   => rst_aux,
            load  => load_aux,
            x_0   => x_0_aux,
            y_0   => y_0_aux,
            angle => angle_aux,
            x     => x_aux,
            y     => y_aux,
            done  => done_aux
        );

end architecture cordic_tb_arq;
