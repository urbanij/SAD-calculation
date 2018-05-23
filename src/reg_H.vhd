---------------------------------------------
-- Title       : reg_H
-- Project     : Final project: SAD Calculation
---------------------------------------------
-- File        : reg_H.vhd
-- Language    : VHDL
-- Author(s)   : Francesco Urbani
-- Company     : 
-- Created     : Tue May 22 21:02:34 CEST 2018
---------------------------------------------
-- Description : register with HOLD (additional signal)
---------------------------------------------
-- Update      :
---------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;


entity reg_H is
	generic (N : positive := 8); -- N BIT PIPO REGISTER
	port (
		clk     : in  std_logic;
		rst     : in  std_logic;
		d       : in  std_logic_vector(N-1 downto 0);
		hold    : in std_logic;
		q       : out std_logic_vector(N-1 downto 0)
	);
end reg_H;


architecture rtl of reg_H is

  component dff_H
	port (
        clk  : in  std_logic;
        rst  : in  std_logic; -- active high
        i    : in  std_logic; -- INPUT
        hold : in std_logic;  -- HOLD. if 1 the output q is fed back into the d input of the flip-flop.
        q    : out std_logic -- OUTPUT
    );
	end component dff_H;

	begin

	regH_gen: for i in 0 to N-1 generate
		i_dffH : dff_H
			port map (clk, rst, d(i), hold, q(i));
	end generate regH_gen;
  
end rtl;

