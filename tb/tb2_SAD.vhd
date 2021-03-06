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
use ieee.numeric_std.all;


entity tb2_SAD is
end entity tb2_SAD; -- tb2_SAD


architecture struct of tb2_SAD is
	

	component SAD is
		generic (
			Npixel     :     positive := 16;                    -- total # of pixels of the image
			Nbit       :     positive := 8;                     -- # bits needed to represent the value of each pixel
			SAD_bits   :     positive := 16                     -- # of bits needed to represent the output
		);
		port (
			CLK        : in  std_logic;	                        -- CLK, active on rising edge
			RST        : in  std_logic;	                        -- RST, active high
			EN         : in  std_logic;	                        -- enable input
			PA         : in  std_logic_vector(Nbit-1 downto 0);	-- input pixel value image A
			PB         : in  std_logic_vector(Nbit-1 downto 0);	-- input pixel value image B

			SAD        : out std_logic_vector(SAD_bits-1 downto 0);	-- ouput SAD value
			DATA_VALID : out std_logic	                        -- specifies whether the output SAD is valid or not
		);
	end component SAD;


	constant Npixel  : positive := 256;
	constant Nbit    : positive := 8;
	constant Mbit    : positive := 16;
	constant clk_per : time     := 5 ns;

	signal clk       : std_logic := '0';
	signal reset     : std_logic ;
	signal enable    : std_logic := '1';
	signal PA        : std_logic_vector(Nbit-1 downto 0);
	signal PB        : std_logic_vector(Nbit-1 downto 0); 
	
	signal testing   : Boolean   := True;




begin
	clk <= not clk after clk_per/2 when testing;-- ELSE '0';


	sad_i: SAD
		generic map(Npixel, Nbit, Mbit)
		port map(clk, reset, enable, PA, PB, open, open);


	drive_p: process
	  	begin
	  		wait for 12 ns;
			
			
			PA <= x"01";
			PB <= x"00";
		
	  		wait for 7330 ns;
	  		testing <= False;
	  		wait;
	  	end process;

	  	
	  	drive_rst: process
	  	begin
	  		wait for 211 ns;
	  		wait until rising_edge(clk);
	  		reset <= '0';
	  		wait until rising_edge(clk);
	  		wait until rising_edge(clk);
	  		wait until rising_edge(clk);
	  		wait until rising_edge(clk);
	  		wait until rising_edge(clk);
	  		wait until rising_edge(clk);
	  		wait until rising_edge(clk);
	  		wait for 66 ns;
	  		reset <= '1';
	  		wait until rising_edge(clk);
	  		wait until rising_edge(clk);
	  		wait until rising_edge(clk);
	  		wait until rising_edge(clk);
	  		reset <= '0';
	  		wait for 2200 ns;
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

end architecture;

