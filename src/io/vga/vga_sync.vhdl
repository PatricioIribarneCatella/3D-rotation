-- vga_sync
--
-- it represents the controller for the VGA protocol
--
-- it generates the vertical and horizontal sync signals,
-- the number of the vertical and horizontal pixel
-- and the video_on signal which its "one" during the hole
-- process of generating a frame (the 640x480 pixels) and
-- then "zero"

library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.numeric_std.all;

entity vga_sync is
	port (
		clk		 : in std_logic;
		rst		 : in std_logic;
		hsync	 : out std_logic;
		vsync 	 : out std_logic;
		video_on : out std_logic;
		p_tick	 : out std_logic;
		pixel_x  : out std_logic_vector(9 downto 0); -- horizontal pixel count
		pixel_y  : out std_logic_vector(9 downto 0)	 -- vertical pixel count
	);
end vga_sync;

architecture vga_sync_arq of vga_sync is

	-- synchronism parameters for a VGA 640x480 area
	constant HD: integer := 640; -- horizontal visible area
	constant HF: integer:= 16; 	 -- horizontal front porch
	constant HB: integer:= 48; 	 -- horizontal back porch
	constant HR: integer:= 96; 	 -- horizontal return
	constant VD: integer := 480; -- vertical visible area
	constant VF: integer:= 10;   -- vertical front porch
	constant VB: integer := 33;  -- vertical back porch
	constant VR: integer := 2;   -- vertical return

	constant P : std_logic := '0';	-- polarity

	-- vertical and horizontal counters
	signal v_count : unsigned(9 downto 0) := (others => '0');
	signal h_count : unsigned(9 downto 0) := (others => '0');

	-- state signals
	signal h_end, v_end, pixel_tick: std_logic;

begin

	-- 25 MHz clock tick
	pixel_clock: process(clk, rst)
    begin
		if rst = '1' then
			pixel_tick <= '0';
        elsif rising_edge(clk) then
            pixel_tick <= not pixel_tick;
        end if;
    end process;

	-- mod 800 (total number of pixels in a line)
	horizontal_counter: process(clk, rst)
	begin
		if rst = '1' then
			h_count <= (others => '0');
		elsif rising_edge(clk) then
			if pixel_tick = '1' then -- 25 MHz tick
				if h_end = '1' then
					h_count <= (others => '0');
				else
					h_count <= h_count + 1;
				end if;
			end if;
		end if;
	end process;

	-- mod 525 (total number of lines in a frame)
	vertical_counter: process(clk, rst)
	begin
		if rst = '1' then
			v_count <= (others => '0');
		elsif rising_edge(clk) then
			if pixel_tick = '1' and h_end = '1' then -- 25 MHz tick
				if (v_end = '1') then
					v_count <= (others => '0');
				else
					v_count <= v_count + 1;			
				end if;
			end if;
		end if;
	end process;

	-- "1" when the horizontal counter reaches the end, otherwise "0"
	h_end <=
		'1' when to_integer(h_count) = (HD + HF + HB + HR - 1) else -- h_count = 799
		'0';

	-- "1" when the vertical counter reaches the end, otherwise "0"
	v_end <=
		'1' when to_integer(v_count) = (VD + VF + VB + VR - 1) else -- v_count = 524
		'0';

	sync_generator: process (clk, rst)
	begin
		if rst = '1' then
			vsync <= '0';
			hsync <= '0';
		elsif rising_edge(clk) then
			-- horizontal synchronism
			if (h_count >= (HD + HF) and (h_count <= (HD + HF + HR - 1))) then
				hsync <= P;
			else
				hsync <= not P;
			end if;
			-- vertical synchronism
			if (v_count >= (VD + VF) and (v_count <= (VD + VF + VR - 1))) then
				vsync <= P;
			else
				vsync <= not P;
			end if;
		end if;
	end process;

	video_on <= '1' when (h_count < HD) and (v_count < VD) else '0';
	pixel_x <= std_logic_vector(h_count);
	pixel_y <= std_logic_vector(v_count);
	p_tick <= pixel_tick;

end vga_sync_arq;
