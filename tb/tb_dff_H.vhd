---------------------------------------------
-- Title       : tb_dff_H
-- Project     : Final project: SAD Calculation
---------------------------------------------
-- File        : tb_dff_H.vhd
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

entity tb_dff_H is
end tb_dff_H;

architecture beh of tb_dff_H is

	component dff_H
		port (
	        clk  : in  std_logic;
	        rst  : in  std_logic; -- active high
	        i    : in  std_logic; -- INPUT
	        hold : in std_logic;  -- HOLD. if 1 the output q is fed back into the d input of the flip-flop.
	        q    : out std_logic -- OUTPUT
    );
	end component dff_H;

	signal clk    : std_logic := '0';
	signal rst    : std_logic;
	signal i      : std_logic := '1';
	signal hold   : std_logic := '0';

	constant clk_T  : time := 10 ns;
	constant input_toggle_time : time := 16 ns;
	signal   clk_go : std_logic;

  
begin
  
	clk <= not clk after clk_T/2 when clk_go='1' else '0';
	
	i <= not i after input_toggle_time/2 when clk_go='1' else '0';

	i_dut: dff_H
		port map (clk, rst, i, hold, open);

	drive_p: process
	begin
		rst     <= '1';
		
		clk_go  <= '1';
		wait for 123 ns;    
		rst     <= '0';
		wait for 33 ns;
		
		wait for 32 ns;
		
		wait for 14 ns;
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		
		wait until rising_edge(clk);
		wait for 88 ns;
		
		wait for 123 ns;
		rst     <= '1';
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		
		wait for 123 ns;
		clk_go  <= '0';
		wait;
	end process drive_p;

	hold_p :process
	begin
		wait for 164 ns;
		hold <= '1';
		wait for 44 ns;
		hold <= '0';
		wait for 92 ns;
		hold <= '1';
		wait for 18 ns;
		hold <= '0';

		wait; 
	end process;
end beh;
