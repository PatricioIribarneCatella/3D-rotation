-- vector
--
-- represents the image of a vector (a.k.a a right line)
--
-- consist of a DUAL-PORT-RAM so that the rotation logic
-- can write to it when a new value has been generated
-- and the plotting logic can read from it to render a
-- a new vector line in each frame

library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.numeric_std.all;

entity vector is
	generic(
		ADDR_SIZE : natural := 4;
		DATA_SIZE : natural := 1
	);
	port(
		data_in      : in std_logic_vector(DATA_SIZE - 1 downto 0);
		address_in   : in std_logic_vector(ADDR_SIZE - 1 downto 0);
		data_out     : out std_logic_vector(DATA_SIZE - 1 downto 0);
		address_out  : in std_logic_vector(ADDR_SIZE - 1 downto 0);
		write_enable : in std_logic;
		clk          : in std_logic;
		rst          : in std_logic
	);
end entity vector;

architecture vector_arq of vector is

	subtype RAM_entry is std_logic_vector(DATA_SIZE - 1 downto 0);
	type Matrix is array(0 to 2**ADDR_SIZE - 1) of RAM_entry;

	signal ram : Matrix;

begin

	reader_writer : process (clk, rst) is
	begin
		if rst = '1' then
			data_out <= (others => '0');
		elsif rising_edge(clk) then
			if write_enable = '1' then
				-- write
				ram(to_integer(unsigned(address_in))) <= data_in;
			end if;
			-- read
			data_out <= ram(to_integer(unsigned(address_out)));
		end if;		
	end process;

end architecture vector_arq;
