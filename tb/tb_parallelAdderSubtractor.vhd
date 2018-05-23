---------------------------------------------
-- Title       : parallelAdderSubtractor
-- Project     : Final project: SAD Calculation
---------------------------------------------
-- File        : parallelAdderSubtractor.vhd
-- Language    : VHDL
-- Author(s)   : Francesco Urbani
-- Company     : 
-- Created     : Sun May 20 12:38:47 CEST 2018
---------------------------------------------
-- Description :
---------------------------------------------
-- Update      :
---------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
-- use ieee.std_logic_unsigned.all;
-- use ieee.numeric_std.all;

entity tb_paralleladdersubtractor is
end tb_paralleladdersubtractor;


architecture arch of tb_paralleladdersubtractor is
	component paralleladdersubtractor is
		generic (Nbit : positive );
		port (
			a : in std_logic_vector(Nbit-1 downto 0);
			b : in std_logic_vector(Nbit-1 downto 0);
			ci : in std_logic; -- control input
			s : out std_logic_vector(Nbit-1 downto 0); -- sub/difference output
			c : out std_logic
		);
	end component;
	
	constant Nbit : positive := 16;

	signal a : std_logic_vector(Nbit-1 downto 0);
	signal b : std_logic_vector(Nbit-1 downto 0);
	signal ci : std_logic;



begin
	i_pas : paralleladdersubtractor
		port map(a, b, ci, open , open);



	drive_p: process
	begin

		a <= X"1110";
		b <= X"1001";
		ci <= '0';
		wait for 23 ns;

		a <= X"1000";
		b <= X"000F";
		ci <= '1';
		wait for 23 ns;
		
		
		a <= X"00FF";
		b <= X"02A0";
		ci <= '1';
		wait for 21 ns;
		

		a <= X"1000";
		b <= X"0101";
		ci <= '1';
		wait for 23 ns;

		a <= X"1000";
		b <= X"0101";
		ci <= '0';
		wait for 23 ns;

		a <= X"1111";
		b <= X"0001";
		ci <= '0';
		wait for 23 ns;

		a <= X"1101";
		b <= X"1111";
		ci <= '1';
		wait for 23 ns;

		a <= X"1C01";
		b <= X"1011";
		ci <= '1';
		wait for 23 ns;

		wait;
	end process drive_p;


end architecture ; -- arch
