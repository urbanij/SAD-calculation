---------------------------------------------
-- Title       : counter
-- Project     : Final project: SAD Calculation
---------------------------------------------
-- File        : counter.vhd
-- Language    : VHDL
-- Author(s)   : Francesco Urbani
-- Company     : 
-- Created     : Fri May 18 16:23:33 CEST 2018
---------------------------------------------
-- Description :
---------------------------------------------
-- Update      :
---------------------------------------------


library ieee;
use ieee.std_logic_1164.all;


entity tb_tff is
end tb_tff;

architecture beh of tb_tff is

	component tff
		port (
			clk     : in  std_logic;
			rst     : in  std_logic; 
			t       : in  std_logic;
			q       : out std_logic
		);
	end component tff;

	signal clk    : std_logic := '0';
	signal rst    : std_logic;
	signal t     : std_logic;

	constant clk_T  : time := 100 ns;  
	signal   clk_go : std_logic;

  
begin
  
	clk <= not clk after clk_T/2 when clk_go='1' else '0';

	i_dut: tff
		port map (clk, rst, t, open);

	drive_p: process
	begin
		rst     <= '1';
		t      <= '0';
		clk_go  <= '1';
		wait for 123 ns;    
		rst     <= '0';
		t      <= '1';
		wait for 32 ns;
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		wait for 92 ns;
		t      <= '0';
		wait for 123 ns;
		rst     <= '1';
		wait until rising_edge(clk);
		t<= '0';
		wait for 123 ns;
		clk_go  <= '0';
		wait;
	end process drive_p;

end beh;
