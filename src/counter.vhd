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
-- Description : Slighly modified counter,
--               It counts up to overflow_val and when 
--               that value is reached the output 
--               signal tc is set to 1
--               until a reset (active high) occurs.
---------------------------------------------
-- Update      :
---------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 


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
				-- tc <= '0'; -- comment this out in order to leave tc set to 1 until a reset occurs!
				              -- otherwhise tc only pulses for a clock cycle.
			end if;

			if count=overflow_val then
				tc <= '1';
				count := 0;
			end if;
		end if;
	end process;

end architecture ; -- beh

