---------------------------------------------
-- Title       : tb_dff
-- Project     : Final project: SAD Calculation
---------------------------------------------
-- File        : tb_dff.vhd
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

entity tb_dff is
end tb_dff;

architecture beh of tb_dff is

	component dff
		port (
			clk     : in  std_logic;
			rst     : in  std_logic; 
			d       : in  std_logic;
			q       : out std_logic
		);
	end component dff;

	signal clk    : std_logic := '0';
	signal rst    : std_logic;
	signal d      : std_logic;

	constant clk_T  : time := 100 ns;  
	signal   clk_go : std_logic;

  
begin
  
	clk <= not clk after clk_T/2 when clk_go='1' else '0';

	i_dut: dff
		port map (clk, rst, d, open);

	drive_p: process
	begin
		rst     <= '1';
		d       <= '0';
		clk_go  <= '1';
		wait for 123 ns;    
		rst     <= '0';
		d       <= '1';
		wait for 32 ns;
		d       <= '0';
		wait for 14 ns;
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		d       <= '1';
		wait until rising_edge(clk);
		wait for 92 ns;
		d       <= '0';
		wait for 123 ns;
		rst     <= '1';
		wait until rising_edge(clk);
		d <= '0';
		wait for 123 ns;
		clk_go  <= '0';
		wait;
	end process drive_p;

end beh;
