
library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.numeric_std.all;

entity pre_processing_tb is
end entity pre_processing_tb;

architecture pre_processing_tb_arq of pre_processing_tb is

	constant SIZE_TB : natural := 16;

    -- x: 1
    signal x_0_aux : std_logic_vector(SIZE_TB - 1 downto 0)
		:= std_logic_vector(to_unsigned(16384, SIZE_TB));
    -- y: 0
    signal y_0_aux : std_logic_vector(SIZE_TB - 1 downto 0)
		:= std_logic_vector(to_unsigned(0, SIZE_TB));
    -- ang: 130
	signal angle_0_aux : std_logic_vector(SIZE_TB downto 0)
		:= std_logic_vector(to_unsigned(47332, SIZE_TB + 1));

	signal x_aux, y_aux : std_logic_vector(SIZE_TB - 1 downto 0);
	signal angle_aux : std_logic_vector(SIZE_TB - 1 downto 0);

begin

				   -- ang: 200
	angle_0_aux <= std_logic_vector(to_unsigned(72818, SIZE_TB + 1)) after 20 ns,
				   -- ang: 300
				   std_logic_vector(to_unsigned(109227, SIZE_TB + 1)) after 40 ns,
				   -- ang: -135
				   std_logic_vector(to_signed(-49152, SIZE_TB + 1)) after 60 ns;

  DUT: entity work.pre_processing
        port map (
			x_0 => x_0_aux,
			y_0 => y_0_aux,
			angle_0 => angle_0_aux,
			x => x_aux,
			y => y_aux,
			angle => angle_aux
        );

end architecture pre_processing_tb_arq;
