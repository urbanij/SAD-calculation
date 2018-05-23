---------------------------------------------
-- Title       : tb_upcounter
-- Project     : Final project: SAD Calculation
---------------------------------------------
-- File        : tb_upcounter.vhd
-- Language    : VHDL
-- Author(s)   : Francesco Urbani
-- Company     : 
-- Created     : Sun May 20 00:09:20 CEST 2018
---------------------------------------------
-- Description :
---------------------------------------------
-- Update      :
---------------------------------------------



library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; -- needed for unsigned

entity tb_upcounter is
end tb_upcounter;

architecture beh of tb_upcounter is

	component upcounter
		generic (Nbit : natural := 8); -- counter MOD 2^Nbit
		port (
			count_puls   : in std_logic;
			count_enable : in std_logic;
			rst          : in std_logic;
			q            : out std_logic_vector(Nbit-1 downto 0);
			tc           : out std_logic
		);
	end component upcounter;

	signal clk          : std_logic := '0';
	signal count_enable : std_logic := '1';
	signal rst          : std_logic := '1';

	constant clk_T  : time := 10 ns;  
	signal   clk_go : std_logic := '1';

  
begin
  
	clk <= not clk after clk_T/2 when clk_go='1' else '0';

	i_dut: upcounter
		port map (clk, count_enable, rst, open, open);

	drive_p: process
	begin
		wait for 21 ns;
		count_enable <= '1';
		wait for 221 ns;
		rst <= '0';
		wait for 90 ns;
		rst <= '1';
		wait for 18 ns;
		rst <= '0';
		wait for 77 ns;
		count_enable <= '0';
		wait for 88 ns;
		count_enable <= '1';
		wait for 4302 ns;

		rst <= '1';
		wait for 114 ns;
		rst <= '0';
		wait for 333 ns;
		count_enable <= '0';
		wait for 992 ns;
		count_enable <= '1';
		wait for 4333 ns;



		clk_go <= '0';
		wait;
	end process drive_p;

end beh;
