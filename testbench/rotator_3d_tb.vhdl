
library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.numeric_std.all;

entity rotator_3d_tb is
end entity rotator_3d_tb;

architecture rotator_3d_tb_arq of rotator_3d_tb is

    constant N_TB : natural := 16;

    signal clk_aux  : std_logic := '0';
    signal rst_aux  : std_logic := '1';
    signal start_aux : std_logic := '1';
    signal done_aux : std_logic;

    -- x: 1
    signal x_in_aux : std_logic_vector(N_TB - 1 downto 0) := std_logic_vector(to_unsigned(16384, N_TB));
    -- y: 0
    signal y_in_aux : std_logic_vector(N_TB - 1 downto 0) := std_logic_vector(to_unsigned(0, N_TB));
    -- z: 0
    signal z_in_aux : std_logic_vector(N_TB - 1 downto 0) := std_logic_vector(to_unsigned(0, N_TB));

    -- ang: 10
    signal alpha_aux : std_logic_vector(N_TB downto 0) := std_logic_vector(to_unsigned(3641, N_TB + 1));
    -- ang: 10
    signal beta_aux  : std_logic_vector(N_TB downto 0) := std_logic_vector(to_unsigned(3641, N_TB + 1));
    -- ang: 10
    signal gamma_aux : std_logic_vector(N_TB downto 0) := std_logic_vector(to_unsigned(3641, N_TB + 1));

    signal x_out_aux : std_logic_vector(N_TB - 1 downto 0);
    signal y_out_aux : std_logic_vector(N_TB - 1 downto 0);
    signal z_out_aux : std_logic_vector(N_TB - 1 downto 0);

begin

    rst_aux  <= '0' after 10 ns;
    start_aux <= '0' after 40 ns;
    clk_aux  <= not clk_aux after 20 ns;

  DUT: entity work.rotator_3d
        port map (
            clk   => clk_aux,
            rst   => rst_aux,
            start => start_aux,
            x_in  => x_in_aux,
            y_in  => y_in_aux,
            z_in  => z_in_aux,
            alpha => alpha_aux,
            beta  => beta_aux,
            gamma => gamma_aux,
            x_out => x_out_aux,
            y_out => y_out_aux,
			z_out => z_out_aux,
            done  => done_aux
        );

end architecture rotator_3d_tb_arq;
