---------------------------------------------
-- Title       : tb2_SAD
-- Project     : Final project: SAD Calculation
---------------------------------------------
-- File        : tb2_SAD.vhd
-- Language    : VHDL
-- Author(s)   : Francesco Urbani
-- Company     : 
-- Created     : Sun May 27 20:53:15 CEST 2018
---------------------------------------------
-- Description : Autogenerated test bench for SAD.vhd
---------------------------------------------
-- Update      :
---------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
--use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;


entity tb2_SAD is
end entity tb2_SAD; -- tb2_SAD


architecture struct of tb2_SAD is
	
	component SAD is
		generic(
			Npixel     : positive ;      -- total # of pixels of the image
			
			Nbit       : positive ;        -- # of bits needed to represent the value of each pixel
			SAD_bits   : positive  	-- # of bits needed to represent the output
		);
		port(
			CLK        : in  std_logic;
			RST        : in  std_logic;
			EN         : in  std_logic;
			PA         : in  std_logic_vector(Nbit-1  downto 0);
			PB         : in  std_logic_vector(Nbit-1  downto 0);
			
			SAD        : out std_logic_vector(SAD_bits-1 downto 0); 
			DATA_VALID : out std_logic
		);
	end component SAD;


	constant Npixel  : positive := 256;
	constant Nbit    : positive := 8;
	constant Mbit    : positive := 16;
	constant clk_per : time     := 5 ns;

	signal clk       : std_logic := '0';
	signal reset     : std_logic ;
	signal enable    : std_logic ;
	signal PA        : std_logic_vector(Nbit-1 downto 0) := "00000000";
	signal PB        : std_logic_vector(Nbit-1 downto 0) := "XXXXXXXX";
	
	signal testing   : Boolean   := True;




begin
	clk <= not clk after clk_per/2 when testing;-- ELSE '0';


	sad_i: SAD
		generic map(Npixel, Nbit, Mbit)
		port map(clk, reset, enable, PA, PB, open, open);


	drive_p: process
	  	begin
			
			
			PA <= x"00";
			PB <= x"01";
		
			----------------------------------


	  		wait for 7330 ns;
	  		testing <= False;
	  		wait;
	  	end process;

	  	
	  	drive_rst: process
	  	begin
	  		reset <= '0';
	  		wait until rising_edge(clk);
	  		wait until rising_edge(clk);
	  		wait until rising_edge(clk);
	  		wait until rising_edge(clk);
	  		wait until rising_edge(clk);
	  		wait until rising_edge(clk);
	  		reset <= '1';
	  		wait until rising_edge(clk);
	  		wait until rising_edge(clk);
	  		wait until rising_edge(clk);
	  		wait until rising_edge(clk);
	  		reset <= '0';
	  		wait for 1500 ns;
	  		reset <= '1';
	  		wait for 330 ns;
	  		reset <= '0';
	  		wait for 2000 ns;
	  		reset <= '1';
	  		wait for 100 ns;
	  		reset <= '0';
	  		wait for 3000 ns;

	  		wait;
	  	end process;



	  	drive_en : process
	  	begin
	  		enable <= '1';
	  		wait until rising_edge(clk);
	  		wait until rising_edge(clk);
	  		wait until rising_edge(clk);
	  		wait until rising_edge(clk);
	  		enable <= '0';
	  		wait until rising_edge(clk);
	  		wait until rising_edge(clk);
	  		
	  		
	  		enable <= '1';
	  		wait until rising_edge(clk);
	  		wait until rising_edge(clk);

	  		wait until rising_edge(clk);
	  		wait until rising_edge(clk);
	  		
	  		wait for 3000 ns;
	  		enable <= '0';
	  		wait until rising_edge(clk);
	  		wait until rising_edge(clk);
	  		wait until rising_edge(clk);
	  		wait until rising_edge(clk);
	  		wait until rising_edge(clk);
	  		wait until rising_edge(clk);
	  		wait until rising_edge(clk);
	  		enable <= '1';
	  		wait for 2400 ns;
	  	end process;

end architecture;

