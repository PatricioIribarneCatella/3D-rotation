-- register mem
--
-- it represents the component in charge of
-- modelling a memory of size "N"

library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.numeric_std.all;

entity register_mem is
	generic(
		N: natural := 8
	);
	port(
		clk      : in std_logic;
		rst      : in std_logic;
		data_in  : in std_logic_vector(N - 1 downto 0);
		data_out : out std_logic_vector(N - 1 downto 0)
	);
end entity register_mem;

architecture register_mem_arq of register_mem is
begin

	process(clk, rst)
	begin
		if rst = '1' then
			data_out <= (others => '0');
		elsif rising_edge(clk) then
			data_out <= data_in;
		end if;
	end process;

end architecture register_mem_arq;
