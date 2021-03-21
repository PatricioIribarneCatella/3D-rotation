-- shifter
--
-- it represents the component in charge of
-- performing a "right" shift considering the
-- "count" value as the number of times to shift
-- the original value to the right

library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.numeric_std.all;

entity shifter is
	generic(
		N : natural := 4
	);
	port(
		data_in  : in std_logic_vector(N - 1 downto 0);
		data_out : out std_logic_vector(N - 1 downto 0);
		count    : in integer
	);
end entity shifter;

architecture shifter_arq of shifter is
begin
	sign_shifter : process (data_in, count) is
	begin
		data_out <= std_logic_vector(shift_right(unsigned(data_in), count));

		if (data_in(N - 1) = '1') and (count > 0) then
			data_out(N - 1 downto (N - count)) <= (others => '1');
		end if;
	end process;
end architecture shifter_arq;
