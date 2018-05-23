---------------------------------------------
-- Title       : tb_subtractor
-- Project     : Final project: SAD Calculation
---------------------------------------------
-- File        : tb_subtractor.vhd
-- Language    : VHDL
-- Author(s)   : Francesco Urbani
-- Company     : 
-- Created     : Sun May 20 22:55:03 CEST 2018
---------------------------------------------
-- Description :
---------------------------------------------
-- Update      :
---------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
-- use ieee.std_logic_unsigned.all;
 use ieee.numeric_std.all;

entity tb_subtractor is
end tb_subtractor;


architecture arch of tb_subtractor is
	
	component subtractor is
		generic (Nbit : positive );
		port (
			a : in std_logic_vector(Nbit-1 downto 0);
			b : in std_logic_vector(Nbit-1 downto 0);
			s : out std_logic_vector(Nbit-1 downto 0) -- sub/difference output
		);
	end component;
	


	constant Nbit : positive := 16;
	signal a : std_logic_vector(Nbit-1 downto 0);
	signal b : std_logic_vector(Nbit-1 downto 0);
	constant time_interv : time := 25 ns;


begin
	i_pas : subtractor
		port map(a, b, open);

	drive_p: process
	begin
		a <= X"1020";
		b <= X"1031";
		wait for time_interv;

		a <= X"0110";
		b <= X"0231";
		wait for time_interv;

		a <= X"4110";
		b <= X"4110";
		wait for time_interv;

		a <= X"1D90";
		b <= X"1C01";
		wait for time_interv;


		a <= X"1110";
		b <= X"1001";
		wait for time_interv;

		a <= X"1000";
		b <= X"000F";
		wait for time_interv;
		
		a <= X"0004";
		b <= X"0A0F";
		wait for time_interv;
		
		a <= X"00FF";
		b <= X"02A0";
		wait for time_interv;
		
		a <= X"1000";
		b <= X"0101";
		wait for time_interv;

		a <= X"1111";
		b <= X"0001";
		wait for time_interv;

		a <= X"1101";
		b <= X"1111";
		wait for time_interv;

		a <= X"1C01";
		b <= X"1011";
		wait for time_interv;

		wait;
	end process drive_p;


end architecture ; -- arch
