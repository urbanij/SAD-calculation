---------------------------------------------
-- Title       : counter
-- Project     : Final project: SAD Calculation
---------------------------------------------
-- File        : counter.vhd
-- Language    : VHDL
-- Author(s)   : Francesco Urbani
-- Company     : 
-- Created     : Sat May 19 23:53:22 CEST 2018
---------------------------------------------
-- Description : counter used to check if 2^Nbit cycles have passed. When tc activates DATA_VALID of SAD goes to 1.
---------------------------------------------
-- Update      :
---------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; -- needed for unsigned


-- usual counter which counts up to 2^Nbit -1 with
-- an additional output port called tc which becomes 1 if every bit of q is 1.
entity counter is
	generic (
			overflow_val : natural := 25
		);
	port (
		count_puls   : in std_logic;
		count_enable : in std_logic;
		rst          : in std_logic;
		tc           : out std_logic
	);
end entity ; -- counter


--architecture beh of counter is
--	signal internal : unsigned(Nbit-1 downto 0);
	
--	begin
--		process(count_puls)
--		begin		
--			if (count_puls='1' and count_puls'event) then
--				if (rst = '1') then
--					internal <= (others => '0');
--				elsif (count_enable = '1') then
--					internal <= internal + 1;
--				end if;

--			end if;

--		end process;

--		q  <= std_logic_vector(internal);
--		tc <= '1' when internal = (2**Nbit-1) else '0'; --same way of writing it.

--end architecture ; -- beh




architecture beh of counter is
	
begin
	
	process(count_puls)
	variable count : natural := 0;
	begin
		if (count_puls='1' and count_puls'event) then
			if (rst = '1') then
				count := 0;
				tc <= '0';
			elsif (count_enable = '1') then
				count := count + 1;
				--tc <= '0'; -- comment this out in order to leave tc set to 1 until a reset occurs!
				             -- otherwhise tc only pulses for a clock cycle.
			end if;

			if count=overflow_val then
				tc <= '1';
				count := 0;
			end if;
		end if;
	end process;

end architecture ; -- beh

