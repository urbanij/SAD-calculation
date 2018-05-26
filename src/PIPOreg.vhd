---------------------------------------------
-- Title       : PIPOreg
-- Project     : Final project: SAD Calculation
---------------------------------------------
-- File        : PIPOreg.vhd
-- Language    : VHDL
-- Author(s)   : Francesco Urbani
-- Company     : 
-- Created     : Thu May  3 16:00:02 CEST 2018
---------------------------------------------
-- Description : Parallel-in, parallel-out unidirectional shift register
---------------------------------------------
-- Update      : 
---------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;


entity PIPOreg is
	generic (N : positive := 8); -- N BIT PIPO REGISTER
	port (
		clk     : in  std_logic;
		rst     : in  std_logic;
		d       : in  std_logic_vector(N-1 downto 0);
		q       : out std_logic_vector(N-1 downto 0)
	);
end PIPOreg;


architecture rtl of PIPOreg is

  component dff
	port (
        clk  : in  std_logic;
        rst  : in  std_logic; -- active high
        d    : in  std_logic;
        q    : out std_logic
    );
	end component dff;

	begin

	reg_gen: for i in 0 to N-1 generate
		i_dff : dff
			port map (clk, rst, d(i), q(i));
	end generate reg_gen;
  
end rtl;


