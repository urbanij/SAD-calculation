---------------------------------------------
-- Title       : SR_latch
-- Project     : Final project: SAD Calculation
---------------------------------------------
-- File        : SR_latch.vhd
-- Language    : VHDL
-- Author(s)   : Francesco Urbani
-- Company     : 
-- Created     : Wed May 23 10:25:49 CEST 2018
---------------------------------------------
-- Description : 
---------------------------------------------
-- Update      :
---------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity SR_latch is
	port (
		S     : in std_logic;
		R     : in std_logic;
		Q     : out std_logic;
		not_Q : out std_logic
	) ;
end entity ; -- SR_latch

architecture arch of SR_latch is

	

begin
	process(S, R)
	begin
		if (S='1' and R='0') then
			Q     <= '1';
			not_Q <= '0';
		elsif (S='0' and R='1') then
			Q     <= '0';
			not_Q <= '1';
		elsif (S='1' and R='1') then
			Q     <= 'U';
			not_Q <= 'U';
		-- else if (S='1' and R='1') Q+ = Q, /Q+ = /Q
		end if; 
	end process;

end architecture ; -- arch

