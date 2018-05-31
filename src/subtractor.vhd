---------------------------------------------
-- Title       : subtractor
-- Project     : Final project: SAD Calculation
---------------------------------------------
-- File        : subtractor.vhd
-- Language    : VHDL
-- Author(s)   : Francesco Urbani
-- Company     : 
-- Created     : Sun May 20 22:55:03 CEST 2018
---------------------------------------------
-- Description : Nbit (absolute value) subtractor
---------------------------------------------
-- Update      :
---------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
--use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity subtractor is
	generic (Nbit : positive := 16);
	port (
		a : in  std_logic_vector(Nbit-1 downto 0);
		b : in  std_logic_vector(Nbit-1 downto 0);
		s : out std_logic_vector(Nbit-1 downto 0) -- sub/difference output
	);
end entity ; -- subtractor


architecture beh of subtractor is
	begin
		subtr_proc: process (a, b)
		begin
			if unsigned(a) >= unsigned(b) then
				s <= std_logic_vector( unsigned(a) - unsigned(b) );
			else
				s <= std_logic_vector( unsigned(b) - unsigned(a) );
			end if;
		end process;

end architecture ; -- beh
