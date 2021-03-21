-- adder
--
-- it represents the component in charge of
-- adding two vectors depending on the operation
-- which could be:
--  operation = '0' -> sum
--  operation = '1' -> sub

library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.numeric_std.all;

entity adder is
	generic(
		N : natural := 4
	);
	port(
		a         : in std_logic_vector(N - 1 downto 0);
		b         : in std_logic_vector(N - 1 downto 0);
		res       : out std_logic_vector(N - 1 downto 0);
		operation : in std_logic
	);
end entity adder;

architecture adder_arq of adder is
begin

	res <= std_logic_vector(unsigned(a) + unsigned(b)) when operation = '0'
		   else std_logic_vector(unsigned(a) - unsigned(b));

end architecture adder_arq;
