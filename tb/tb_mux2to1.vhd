---------------------------------------------
-- Title       : tb_mux2to1
-- Project     : Final project: SAD Calculation
---------------------------------------------
-- File        : tb_mux2to1.vhd
-- Language    : VHDL
-- Author(s)   : Francesco Urbani
-- Company     : 
-- Created     : Wed May 16 20:21:16 CEST 2018
---------------------------------------------
-- Description : 
---------------------------------------------
-- Update      :
---------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity tb_mux2to1 is
end entity ; -- tb_mux2to1

architecture arch of tb_mux2to1 is
	component mux2to1 is
		generic (Nbit : in positive := 8);
		port (
			i0   : in std_logic_vector(Nbit-1 downto 0);
			i1   : in std_logic_vector(Nbit-1 downto 0);
			s    : in std_logic;
			f    : out std_logic_vector(Nbit-1 downto 0)
		) ;
	end component;
	
	constant Nbit : positive := 8;

	signal i0 : std_logic_vector(Nbit-1 downto 0) := X"7A";
	signal i1 : std_logic_vector(Nbit-1 downto 0) := X"15";
	signal s : std_logic := '0';
	

begin
	dut: mux2to1
	generic map(Nbit)
	port map(i0, i1, s, open);

	drive_en : process
	  	begin
  			wait for 44 ns;
	  		s <= '1';
	  		wait for 89 ns;
	  		s <= '0';
	  		wait for 71 ns;
			s <= '1';
	  		wait for 1111 ns;
	  		wait;
	  	end process;

end architecture ; -- arch