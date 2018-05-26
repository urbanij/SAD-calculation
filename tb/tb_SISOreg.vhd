---------------------------------------------
-- Title       : tb_SISOreg
-- Project     : Final project: SAD Calculation
---------------------------------------------
-- File        : tb_SISOreg.vhd
-- Language    : VHDL
-- Author(s)   : Francesco Urbani
-- Company     : 
-- Created     : Thu May  3 16:00:02 CEST 2018
---------------------------------------------
-- Description :
---------------------------------------------
-- Update      :
---------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity tb_SISOreg is
end tb_SISOreg;


architecture rtl of tb_SISOreg is

	constant N       : positive := 3;

		

	component SISOreg is
		generic (N  : positive := 3);
		port (
			SI   : in std_logic;
			clk  : in std_logic;
			rst  : in std_logic;
			SO   : out std_logic
		);
	end component ; -- SISOreg


	signal clk_ext : std_logic := '0';
	signal reset   : std_logic := '0';
	signal Serial_in     : std_logic := '1';
	

	signal   Testing : Boolean   := True;
	constant clk_per :  TIME     := 6 ns;  -- clk period


	begin 
		clk_ext <= NOT clk_ext AFTER clk_per/2 WHEN Testing;-- ELSE '0';


		i_dut: SISOreg 
			generic map (N)
			port map(Serial_in, clk_ext, reset, open);


		drive_p: process
	  	begin
	  		Serial_in <= '1';
	  		wait for 50 ns;

	  		Serial_in <= '0';
	  		wait for 2 ns;

	  		reset   <= '1';
	  		wait for 19 ns;

	  		reset <= '0';
	  		wait for 22 ns;

	  		Serial_in <= '1';
	  		wait for 100 ns;

	  		Serial_in <= '0';
	  		wait for 40 ns;

	  		Serial_in <= '1';
	  		wait for 133 ns;

	  		Testing <= False;
	  		wait;
	  	end process;
end rtl;


