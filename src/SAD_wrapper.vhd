---------------------------------------------
-- Title       : SAD_wrapper
-- Project     : Final project: SAD Calculation
---------------------------------------------
-- File        : SAD_wrapper.vhd
-- Language    : VHDL
-- Author(s)   : Francesco Urbani
-- Company     : 
-- Created     : Fri May 18 16:23:33 CEST 2018
---------------------------------------------
-- Description :
---------------------------------------------
-- Update      :
---------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
-- use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;


entity SAD_wrapper is
	generic (
		Npixel : integer := 256;	-- total # of pixels of the image
		N      : integer := 8;		-- # of bits needed to represent the value of each pixel
		M      : integer := 16 	    -- # of bits needed to represent the output
	);
	port (
		CLK : in std_logic;	-- CLK, active high
		RST : in std_logic;	-- RST, active high
		PA : in std_logic_vector(N-1 downto 0);	-- input pixel value image A
		PB : in std_logic_vector (N-1 downto 0);	-- input pixel value image B
		EN : in std_logic;	-- EN
		SAD : out std_logic_vector(M-1 downto 0);	-- ouput SAD
		DATA_VALID : out std_logic	-- specify if the output SAD is valid or not
		
	);
end entity SAD_wrapper;


architecture struct of SAD_wrapper is

	component SAD is
		generic (
			Npixel : integer := 256;	-- total # of pixels of the image
			N      : integer := 8;		-- # of bits needed to represent the value of each pixel
			M      : integer := 16 	    -- # of bits needed to represent the output
		);
		port (
			CLK : in std_logic;	-- CLK, active high
			RST : in std_logic;	-- RST, active high
			PA : in std_logic_vector(N-1 downto 0);	-- input pixel value image A
			PB : in std_logic_vector (N-1 downto 0);	-- input pixel value image B
			EN : in std_logic;	-- EN
			SAD : out std_logic_vector(M-1 downto 0);	-- ouput SAD
			DATA_VALID : out std_logic	-- specify if the output SAD is valid or not
			
		);
	end component;

	signal clk : std_logic;
	signal rst : std_logic;
	signal pa_ext : std_logic_vector(N-1 downto 0);	
	signal pb_ext : std_logic_vector(N-1 downto 0);	
	signal en : std_logic;

	constant px : integer := 256;
	constant N  : integer := 8;
	constant M  : integer := 16;
	

begin

	SAD_wr : SAD
		generic map(px, N, M)
		port map(clk, rst, pa_ext, pb_ext, en, open, open);
	
	
	
end architecture;

