---------------------------------------------
-- Title       : mux2to1
-- Project     : Final project: SAD Calculation
---------------------------------------------
-- File        : mux2to1.vhd
-- Language    : VHDL
-- Author(s)   : Francesco Urbani
-- Company     : 
-- Created     : Wed May 16 20:21:16 CEST 2018
---------------------------------------------
-- Description : Mux for DDFS_Q_LUT
---------------------------------------------
-- Update      :
---------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity mux2to1 is
	generic (Nbit : in positive := 8);
	port (
		i0   : in std_logic_vector(Nbit-1 downto 0);
		i1   : in std_logic_vector(Nbit-1 downto 0);
		s    : in std_logic;
		f    : out std_logic_vector(Nbit-1 downto 0)
	) ;
end entity ;


architecture arch of mux2to1 is
begin
	f <= i0 when s='0' else i1;
end architecture ; -- arch