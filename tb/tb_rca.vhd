---------------------------------------------
-- Title       : tb_rca
-- Project     : Final project: SAD Calculation
---------------------------------------------
-- File        : tb_rca.vhd
-- Language    : VHDL
-- Author(s)   : francescourbani
-- Company     : 
-- Created     : Sat May  5 18:52:03 CEST 2018
---------------------------------------------
-- Description :
---------------------------------------------
-- Update      :
---------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
-- use ieee.std_logic_unsigned.all;
 use ieee.numeric_std.all;


entity tb_rca is
end entity ; -- tb_rca


architecture struct of tb_rca is
	
	component rca is
		generic (
			N : positive
		);

		port (
			x   : in  std_logic_vector(N-1 downto 0);
			y   : in  std_logic_vector(N-1 downto 0);
			c0  : in  std_logic;

			s   : out std_logic_vector(N-1 downto 0);
			cn  : out std_logic
		) ;
	end component;

	constant N       : positive                       := 16;
	signal   c       : std_logic                      := '0';
	signal   x_ext   : std_logic_vector(N-1 downto 0) ;
	signal   y_ext   : std_logic_vector(N-1 downto 0) ;


begin
	
	dut: rca 
		generic map (N)
		port map (x_ext, y_ext, c, open ,open);


		drive_p: process
	  	begin
	  		x_ext <= X"1200";
	  		y_ext <= X"F011";
	  		wait for 50 ns;

	  		c <= '1';

	  		wait for 23 ns;

	  		x_ext <= X"0012";
	  		wait for 19 ns;
	  		y_ext <= X"4A21";
	  		x_ext <= X"01FF";
	  		wait for 100 ns;
	  		c <= '0';
	  		wait for 33 ns;
	  		wait;

	  	end process;


	  	-- COVERAGE:
		-- figura di merito per determinare quanto il test bench copre tutte le casistiche
		-- si usa in progetti grandi
		-- coverage 100% significa che tutti i casi sono stati coperti dal test bench.


end architecture ; -- struct





