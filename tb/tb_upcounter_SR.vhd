---------------------------------------------
-- Title       : Test bench of counter followed by the SR latch
-- Project     : Final project: SAD Calculation
---------------------------------------------
-- File        : tb_upcounter_SR.vhd
-- Language    : VHDL
-- Author(s)   : Francesco Urbani
-- Company     : 
-- Created     : Wed May 23 10:43:25 CEST 2018
---------------------------------------------
-- Description : 
---------------------------------------------
-- Update      : Wed May 23 11:06:15 CEST 2018: Not working
--               
---------------------------------------------

-- This test bench is supposed to test both the counter and
-- the SR latch together. The counter sets the signal called tc to 1
-- right before overflowing (i.e. @ 255 since its a 8 bit counter.).
-- My wish is to have a signal fixed to 1 when the overflow is occured
-- until a reset is triggered.


library IEEE;
use IEEE.std_logic_1164.all;

entity tb_upcounter_SR is
end entity ; -- tb_upcounter_SR


architecture arch of tb_upcounter_SR is
	
	constant N : positive := 8;


	component upcounter is
		generic (Nbit : natural := 8);
		port (
			count_puls   : in std_logic;
			count_enable : in std_logic;
			rst          : in std_logic;
			q            : out std_logic_vector(Nbit-1 downto 0);
			tc           : out std_logic
		);
	end component;


	component SR_latch is
		port (
				S     : in std_logic;
				R     : in std_logic;
				Q     : out std_logic;
				not_Q : out std_logic
			) ;
	end component;
		
	signal clk_ext : std_logic;
	signal rst_ext : std_logic;
	signal EN_ext  : std_logic;
	signal tc_wire : std_logic;

	constant clk_T  : time := 10 ns;  
	signal   clk_go : std_logic := '1';

begin
	clk_ext <= not clk_ext after clk_T/2 when clk_go='1' else '0';

	counter : upcounter
		generic map(N)
		port map(clk_ext, EN_ext, rst_ext, open, tc_wire);

	SR : SR_latch
		port map(tc_wire, rst_ext, open, open);
	
	

	proc : process
	begin
		wait for 20 ns;
		rst_ext <= '0';
		wait for 33 ns;
		EN_ext <= '1';

		wait for 414 ns;

		wait;
		
	end process;
end architecture ; -- arch