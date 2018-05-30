---------------------------------------------
-- Title       : SISOreg
-- Project     : Final project: SAD Calculation
---------------------------------------------
-- File        : SISOreg.vhd
-- Language    : VHDL
-- Author(s)   : Francesco Urbani
-- Company     : 
-- Created     : Sat May 26 15:16:50 CEST 2018
---------------------------------------------
-- Description : Serial-in, serial-out unidirectional shift register
---------------------------------------------
-- Update      :
---------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
--use ieee.std_logic_unsigned.all;
--use ieee.numeric_std.all;


entity SISOreg is
	generic (N  : positive := 3);
	port (
		SI   : in std_logic;
		clk  : in std_logic;
		rst  : in std_logic;
		SO   : out std_logic
	);
end entity ; -- SISOreg


architecture arch of SISOreg is
	
	component dff is
		port (
	        clk  : in  std_logic;
	        rst  : in  std_logic; -- active high
	        d    : in  std_logic;
	        q    : out std_logic
	    );
    end component;
	

	signal wire : std_logic_vector(N downto 0); -- intermediate wire


begin

	wire(0) <= SI;

	SISOgen: for i in 0 to N-1 generate
		i_dff : dff
			port map(clk, rst, wire(i), wire(i+1) );
	end generate SISOgen;

	SO <= wire(N);

end architecture ; -- arch