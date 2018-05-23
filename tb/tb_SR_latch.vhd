---------------------------------------------
-- Title       : SR_latch
-- Project     : Final project: SAD Calculation
---------------------------------------------
-- File        : SR_latch.vhd
-- Language    : VHDL
-- Author(s)   : Francesco Urbani
-- Company     : 
-- Created     : Wed May 23 10:32:27 CEST 2018
---------------------------------------------
-- Description : 
---------------------------------------------
-- Update      :
---------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity tb_SR_latch is
end entity ; -- tb_SR_latch

architecture arch of tb_SR_latch is
	component SR_latch is
		port (
				S     : in std_logic;
				R     : in std_logic;
				Q     : out std_logic;
				not_Q : out std_logic
			) ;
	end component;
		
	
	signal S_ext : std_logic;
	signal R_ext : std_logic;


begin
	dut : SR_latch
		port map(S_ext, R_ext, open, open);

	proc : process
	begin

		S_ext <= '0';
		R_ext <= '1';

		wait for 20 ns;
		S_ext <= '0';
		R_ext <= '0';
		
		wait for 20 ns;
		S_ext <= '1';
		R_ext <= '0';
		
		wait for 20 ns;
		S_ext <= '1';
		R_ext <= '0';
		
		wait for 30 ns;
		S_ext <= '1';
		R_ext <= '1';
		
		wait for 3 ns;
		S_ext <= '0';
		R_ext <= '0';
		
		wait for 20 ns;
		S_ext <= '0';
		R_ext <= '1';
		
		wait for 20 ns;
		S_ext <= '1';
		R_ext <= '0';
		
		wait for 20 ns;
		S_ext <= '1';
		R_ext <= '1';
		

		wait;
		
	end process;
end architecture ; -- arch