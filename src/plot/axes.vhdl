-- axes
-- 
-- represents the static image of the plot axes
--
-- simulates a ROM memory that it can only be read
-- by the plotting logic to render the "axes"
-- in each frame
--
-- the implementation its not a ROM memory because
-- the image its very "lightweight" in the sense that
-- it contains "one"s only in the pixels that represents
-- the axes. All the other are "zeros"
--
-- those pixels can be translated from the `address` value
-- in run-time, so there is no need to store the hole picture

library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.numeric_std.all;

entity axes is
	generic(
		ADDR_SIZE : natural := 4;
		DATA_SIZE : natural := 1
	);
	port(
		data     : out std_logic_vector(DATA_SIZE - 1 downto 0);
		address  : in std_logic_vector(ADDR_SIZE - 1 downto 0);
		clk      : in std_logic;
		rst      : in std_logic
	);
end entity axes;

architecture axes_arq of axes is

	constant ADDR_HALF_SIZE  : natural := ADDR_SIZE / 2;
	constant IMAGE_HALF_SIZE : natural := (2**ADDR_HALF_SIZE) / 2;

begin

	reader : process (clk, rst) is
	begin
		if rst = '1' then
			data <= (others => '0');
		elsif rising_edge(clk) then
			if to_integer(unsigned(address(ADDR_SIZE - 1 downto ADDR_HALF_SIZE))) = IMAGE_HALF_SIZE or
			   to_integer(unsigned(address(ADDR_SIZE - 1 downto ADDR_HALF_SIZE))) = IMAGE_HALF_SIZE - 1 then
				data <= std_logic_vector(to_unsigned(1, DATA_SIZE));
			elsif to_integer(unsigned(address(ADDR_HALF_SIZE - 1 downto 0))) = IMAGE_HALF_SIZE or
				  to_integer(unsigned(address(ADDR_HALF_SIZE - 1 downto 0))) = IMAGE_HALF_SIZE - 1 then
				data <= std_logic_vector(to_unsigned(1, DATA_SIZE));
			else
				data <= (others => '0');
			end if;
		end if;		
	end process;

end architecture axes_arq;
