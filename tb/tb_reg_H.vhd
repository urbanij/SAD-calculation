---------------------------------------------
-- Title       : tb_reg_H
-- Project     : Final project: SAD Calculation
---------------------------------------------
-- File        : tb_reg_H.vhd
-- Language    : VHDL
-- Author(s)   : Francesco Urbani
-- Company     : 
-- Created     : Tue May 22 21:03:02 CEST 2018
---------------------------------------------
-- Description :
---------------------------------------------
-- Update      :
---------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity tb_reg_H is
end tb_reg_H;


architecture rtl of tb_reg_H is

	constant N       : positive  := 8;

	component reg_H is
		generic (N : positive := 8);
		port (
			clk     : in  std_logic;
			rst     : in  std_logic;
			d       : in  std_logic_vector(N-1 downto 0);
			hold    : in std_logic;
			q       : out std_logic_vector(N-1 downto 0)
		);
	end component;


	signal clk_ext : std_logic := '0';
	signal reset   : std_logic := '0';
	signal d_in    : std_logic_vector(N-1 downto 0);
	signal hold    : std_logic := '0';
	

	signal   Testing : Boolean   := True;
	constant clk_per :  TIME     := 5 ns;  -- clk period


	begin 
		clk_ext <= NOT clk_ext AFTER clk_per/2 WHEN Testing;-- ELSE '0';

		i_dut: reg_H 
			generic map (N)
			port map(clk_ext, reset, d_in, hold, open);


		drive_p: process
	  	begin
	  		d_in <= "11111001";
	  		wait for 50 ns;

	  		d_in <= "00001001";
	  		wait for 2 ns;

	  		reset   <= '1';
	  		wait for 44 ns;

	  		reset <= '0';
	  		wait for 22 ns;
	  		d_in <= "00000111";
	  		wait for 100 ns;

	  		d_in <= "00000111";
	  		wait for 8 ns;
	  		d_in <= "01010110";
	  		wait for 13 ns;
			d_in <= "01011111";	
			wait for 64 ns;

	  		wait for 123 ns;

	  		d_in <= "10000111";
	  		wait for 33 ns;

	  		Testing <= False;
	  		wait;
	  	end process;

	  	hold_proc : process
	  	begin 
	  		wait for 33 ns;
	  		hold <= '1';
	  		wait for 44 ns;
	  		hold <= '0';
	  		wait for 93 ns;
	  		hold <= '1';
	  		wait for 312 ns;
	  		hold <= '0';
	  		wait for 211 ns;
	  		
	  		wait ;
	  	end process;

end rtl;


