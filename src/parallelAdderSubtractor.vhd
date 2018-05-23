---------------------------------------------
-- Title       : parallelAdderSubtractor
-- Project     : Final project: SAD Calculation
---------------------------------------------
-- File        : parallelAdderSubtractor.vhd
-- Language    : VHDL
-- Author(s)   : Francesco Urbani
-- Company     : 
-- Created     : Sun May 20 12:07:59 CEST 2018
---------------------------------------------
-- Description :
---------------------------------------------
-- Update      :
---------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
-- use ieee.std_logic_unsigned.all;
-- use ieee.numeric_std.all;

entity paralleladdersubtractor is
	generic (Nbit : positive := 16);
	port (
		a : in std_logic_vector(Nbit-1 downto 0);
		b : in std_logic_vector(Nbit-1 downto 0);
		ci : in std_logic; -- control input
		s : out std_logic_vector(Nbit-1 downto 0); -- sub/difference output
		c : out std_logic
	);
end entity ; -- paralleladdersubtractor

architecture arch of paralleladdersubtractor is
	
	component fa is
		port(
			x, y , cin    : in  std_logic;
			s, cout       : out std_logic
		);
	end component;

	signal intermediate : std_logic_vector(Nbit-1 downto -1);
	signal b_xor_ci     : std_logic_vector(Nbit-1 downto 0);

begin
		
	intermediate(-1) <= ci;

	GEN_pas: for i in 0 to Nbit-1 generate
		b_xor_ci(i) <= b(i) xor ci;
		i_FA: fa
			port map(b_xor_ci(i), a(i), intermediate(i-1), s(i), intermediate(i));
	end generate;

	


end architecture ; -- arch


