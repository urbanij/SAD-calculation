---------------------------------------------
-- Title       : tb_PhaseAccumulator
-- Project     : Final project: SAD Calculation
---------------------------------------------
-- File        : tb_PhaseAccumulator.vhd
-- Language    : VHDL
-- Author(s)   : francescourbani
-- Company     : 
-- Created     : Mon May 14 11:18:18 CEST 2018
---------------------------------------------
-- Description :
---------------------------------------------
-- Updates     : 
---------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_phaseaccumulator is
end tb_phaseaccumulator;


architecture rtl of tb_phaseaccumulator is
	

	constant N       : positive := 16;

	component PhaseAccumulator is
		generic (N : positive := 16);
		port(
			clk    : in  std_logic;
			rst    : in  std_logic;
			pa_in  : in  std_logic_vector(N-1 downto 0);
			pa_out : out std_logic_vector(N-1 downto 0)
		);
	end component;

	signal clk_ext   : std_logic                      := '0';
	signal rst_ext   : std_logic                      := '1';
	signal pa_in_ext : std_logic_vector(N-1 downto 0) ;
	
	signal testing   : Boolean                         := True;
	constant clk_per :  TIME                           := 20 ns;  -- clk period


	begin 
		clk_ext <= not clk_ext after clk_per/2 when testing;-- ELSE '0';

		dut : PhaseAccumulator
		port map(clk_ext, rst_ext, pa_in_ext, open);


		drive_p: process
	  	begin

	  		wait for 52 ns;

	  		pa_in_ext <= x"11b1";
	  		wait for 50 ns;

	  		pa_in_ext <= x"ff4c";
	  		wait for 70 ns;

	  		rst_ext   <= '0';
	  		wait for 10 ns;

	  		pa_in_ext <= x"0001";
	  		wait for 50 ns;
	  		
	  		rst_ext <= '1';
	  		wait for 110 ns;
	  		rst_ext <= '0';

	  		wait for 1500 ns;

	  		pa_in_ext <= x"112f";
	  		wait for 32 ns;
	  		rst_ext <= '1';
	  		wait for 90 ns;
	  		rst_ext <= '0';

	  		wait for 800 ns;

	  		pa_in_ext <= x"0221";
	  		wait for 800 ns;

	  		testing <= False;
	  		wait;
	  	end process;

end rtl;

