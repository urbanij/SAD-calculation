---------------------------------------------
-- Title       : tff
-- Project     : Final project: SAD Calculation
---------------------------------------------
-- File        : tff.vhd
-- Language    : VHDL
-- Author(s)   : Francesco Urbani
-- Company     : 
-- Created     : Fri May 18 16:23:33 CEST 2018
---------------------------------------------
-- Description : T flip flop
---------------------------------------------
-- Update      :
---------------------------------------------


library ieee;
use ieee.std_logic_1164.all;


entity tff is
	port (
        clk  : in  std_logic;
        rst  : in  std_logic; -- active high
        t    : in  std_logic;
        q    : out std_logic
    );
end entity ; -- tff

architecture arch of tff is

	component dff is
		port (
	        clk  : in  std_logic;
	        rst  : in  std_logic; -- active high
	        d    : in  std_logic;
	        q    : out std_logic
	    );
	end component;

	signal fb    : std_logic;
	signal txorq : std_logic;

begin
	
	txorq <= t xor fb;

	i_dff : dff
		port map (clk, rst, txorq, fb);

	q <= fb;
end architecture ; -- arch


