-- vector eraser
--
-- it represents the component that its in charge of
-- deleting the entire DUAL PORT RAM vector representation
-- 
-- this its done because in each frame the VGA should
-- send an new entire picture of the vector without
-- showing the previous image of the vector
--
-- it takes it 2**ADDR_SIZE clock cycles to delete
-- the entire memory

library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.numeric_std.all;

entity vector_eraser is
	generic(
		ADDR_SIZE : natural := 4;
		DATA_SIZE : natural := 1
	);
	port(
		clk         : in std_logic;
		rst         : in std_logic;
		data_out    : out std_logic_vector(DATA_SIZE - 1 downto 0);
		address_out : out std_logic_vector(ADDR_SIZE - 1 downto 0);
		clear_done  : out std_logic;
		clear_start : in std_logic
	);
end entity vector_eraser;

architecture vector_eraser_arq of vector_eraser is

	constant ADDR_HALF_SIZE : natural := ADDR_SIZE / 2;

	-- vertical and horizontal counters
	signal v_count : unsigned(ADDR_HALF_SIZE - 1 downto 0) := (others => '0');
	signal h_count : unsigned(ADDR_HALF_SIZE - 1 downto 0) := (others => '0');

	-- state signal
	signal v_end, h_end : std_logic;
begin

	v_end <= '1' when to_integer(v_count) = 2**(ADDR_HALF_SIZE) - 1 else '0';
	h_end <= '1' when to_integer(h_count) = 2**(ADDR_HALF_SIZE) - 1 else '0';

	horizontal_counter : process (clk, rst) is
	begin
		if rst = '1' then
			h_count <= (others => '0');
		elsif rising_edge(clk) then
			if clear_start = '1' then
				if h_end = '1' then
					h_count <= (others => '0');
				else
					h_count <= h_count + 1;
				end if;
			end if;
		end if;
	end process;

	vertical_counter : process (clk, rst) is
	begin
		if rst = '1' then
			v_count <= (others => '0');
		elsif rising_edge(clk) then
			if clear_start = '1' and h_end = '1' then
				if v_end = '1' then
					v_count <= (others => '0');
				else
					v_count <= v_count + 1;
				end if;
			end if;
		end if;
	end process;

	eraser : process (clk, rst) is
	begin
		if rst = '1' then
			address_out <= (others => '0');
		elsif rising_edge(clk) then
			if clear_start = '1' then
				address_out <= std_logic_vector(v_count) & std_logic_vector(h_count);
				if (v_end = '1') and (h_end = '1') then
					clear_done <= '1';
				else
					clear_done <= '0';
				end if;
			end if;
		end if;

		data_out <= (others => '0');
	end process;

end architecture vector_eraser_arq;
