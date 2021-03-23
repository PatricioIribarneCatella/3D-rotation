-- 3D rotator
--
-- it represents the component in charge of
-- performing the 3D rotation of a vector
-- using the CORDIC algorithm
--
-- it uses 3 CORDIC components to rotate the vector
-- in its 3 axes: x, y and z

library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.numeric_std.all;

entity rotator_3d is
    port(
		clk   : in  std_logic;
		rst   : in  std_logic;
		start : in  std_logic;
		x_in  : in  std_logic_vector(15 downto 0);
		y_in  : in  std_logic_vector(15 downto 0);
		z_in  : in  std_logic_vector(15 downto 0);
		alpha : in  std_logic_vector(16 downto 0); -- one more bit to hold large angles
		beta  : in  std_logic_vector(16 downto 0); -- one more bit to hold large angles
		gamma : in  std_logic_vector(16 downto 0); -- one more bit to hold large angles
		x_out : out std_logic_vector(15 downto 0);
		y_out : out std_logic_vector(15 downto 0);
		z_out : out std_logic_vector(15 downto 0);
		done  : out std_logic
    );
end entity rotator_3d;

architecture rotator_3d_arq of rotator_3d is

	constant SIZE : natural := 16;

	signal done_rx, done_ry, done_rz : std_logic;

	signal x_out_rx, y_out_rx : std_logic_vector(SIZE - 1 downto 0);
	signal x_out_ry, y_out_ry : std_logic_vector(SIZE - 1 downto 0);
	signal x_out_rz, y_out_rz : std_logic_vector(SIZE - 1 downto 0);

	signal z_out_reg : std_logic_vector(SIZE - 1 downto 0);

begin

	CORDIC_Rx : entity work.cordic
		port map (
			clk   => clk,
			rst   => rst,
			start => start,
			x_0   => y_in,
			y_0   => z_in,
			angle => alpha,
			x     => x_out_rx,
			y     => y_out_rx,
			done  => done_rx
		);

	CORDIC_Ry : entity work.cordic
		port map (
			clk   => clk,
			rst   => rst,
			start => done_rx,
			x_0   => y_out_rx,
			y_0   => x_in,
			angle => beta,
			x     => x_out_ry,
			y     => y_out_ry,
			done  => done_ry
		);

	CORDIC_Rz : entity work.cordic
		port map (
			clk   => clk,
			rst   => rst,
			start => done_ry,
			x_0   => y_out_ry,
			y_0   => x_out_rx,
			angle => gamma,
			x     => x_out_rz,
			y     => y_out_rz,
			done  => done_rz
		);

	REG_MEM_Z : entity work.register_mem
		generic map(
			N => SIZE
		)
		port map(
			clk => clk,
			rst => rst,
			enable => done_ry,
			data_in => x_out_ry,
			data_out => z_out_reg
		);

	done <= done_rz;

	x_out <= x_out_rz;
	y_out <= y_out_rz;
	z_out <= z_out_reg;

end architecture rotator_3d_arq;
