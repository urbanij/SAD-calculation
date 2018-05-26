---------------------------------------------
-- Title       : tb_PIPOreg
-- Project     : Final project: SAD Calculation
---------------------------------------------
-- File        : tb_PIPOreg.vhd
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

entity tb_PIPOreg is
end tb_PIPOreg;


architecture rtl of tb_PIPOreg is

	constant N       : positive := 8;

	component PIPOreg is
		generic (N : positive );
		port (
			clk     : in  std_logic;
			rst     : in  std_logic;
			d       : in  std_logic_vector(N-1 downto 0);
			q       : out std_logic_vector(N-1 downto 0)
		);
	end component;


	signal clk_ext : std_logic := '0';
	signal reset   : std_logic := '0';
	signal d_in    : std_logic_vector(N-1 downto 0);
	

	signal   Testing : Boolean   := True;
	constant clk_per :  TIME     := 20 ns;  -- clk period


	begin 
		clk_ext <= NOT clk_ext AFTER clk_per/2 WHEN Testing;-- ELSE '0';


		i_dut: PIPOreg 
			generic map (N)
			port map(clk_ext, reset, d_in, open);


		drive_p: process
	  	begin
	  		d_in <= "00000111";
	  		wait for 50 ns;

	  		d_in <= "00000001";
	  		wait for 2 ns;

	  		reset   <= '1';
	  		wait for 19 ns;

	  		reset <= '0';
	  		wait for 22 ns;

	  		d_in <= "00000111";
	  		wait for 100 ns;

	  		d_in <= "00000111";
	  		wait for 40 ns;

	  		d_in <= "10000111";
	  		wait for 33 ns;

	  		Testing <= False;
	  		wait;
	  	end process;
end rtl;


