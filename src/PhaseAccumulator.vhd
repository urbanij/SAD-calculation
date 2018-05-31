---------------------------------------------
-- Title       : PhaseAccumulator
-- Project     : Final project: SAD Calculation
---------------------------------------------
-- File        : PhaseAccumulator.vhd
-- Language    : VHDL
-- Author(s)   : Francesco Urbani
-- Company     : 
-- Created     : Thu May  3 15:50:48 2018
---------------------------------------------
-- Description :
---------------------------------------------
-- Update      :
---------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity PhaseAccumulator is
	generic (N : positive := 16);
	port(
		clk    : in  std_logic;
		rst    : in  std_logic;
		pa_in  : in  std_logic_vector(N-1 downto 0);
		pa_out : out std_logic_vector(N-1 downto 0)
	);
end entity PhaseAccumulator;


architecture struct of PhaseAccumulator is

	component PIPOreg is
		generic (N : positive);
		port (
			clk     : in  std_logic;
			rst     : in  std_logic;
			d       : in  std_logic_vector(N-1 downto 0);
			q       : out std_logic_vector(N-1 downto 0)
		);
	end component PIPOreg;

	component rca is
		generic (N : positive);
		port (
			x   : in  std_logic_vector(N -1 downto 0);
			y   : in  std_logic_vector(N -1 downto 0);
			c0  : in  std_logic;
			s   : out std_logic_vector(N -1 downto 0);
			cn  : out std_logic
		) ;
	end component rca;

	-- defining two auxiliary signals
	signal kfw_s       : std_logic_vector(N-1 downto 0); -- wire on the "feedback loop" between the register and the RCA input
	signal kfw_next    : std_logic_vector(N-1 downto 0); -- wire between RCA and PIPOreg


	begin
	
	i_adder: rca
	    generic map (N)
	    port map (pa_in, kfw_s, '0', kfw_next, open);
	
	
	i_reg: PIPOreg 
		generic map(N)
		port map(clk, rst, kfw_next, kfw_s);

	pa_out <= kfw_s;

end architecture struct;
