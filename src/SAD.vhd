---------------------------------------------
-- Title       : SAD
-- Project     : Final project: SAD Calculation
---------------------------------------------
-- File        : SAD.vhd
-- Language    : VHDL
-- Author(s)   : Francesco Urbani
-- Company     : 
-- Created     : Fri May 18 16:23:33 CEST 2018
---------------------------------------------
-- Description : Actual SAD calculator (top level)
---------------------------------------------
-- Update      : 
---------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;



entity SAD is
	generic (
		Npixel     :     positive := 16;                    -- total # of pixels of the image
		Nbit       :     positive := 8;                     -- # bits needed to represent the value of each pixel
		SAD_bits   :     positive := 16                     -- # of bits needed to represent the output
	);
	port (
		CLK        : in  std_logic;	                        -- CLK, active on rising edge
		RST        : in  std_logic;	                        -- RST, active high
		PA         : in  std_logic_vector(Nbit-1 downto 0);	-- input pixel value image A
		PB         : in  std_logic_vector(Nbit-1 downto 0);	-- input pixel value image B
		EN         : in  std_logic;	                        -- enable input

		SAD        : out std_logic_vector(SAD_bits-1 downto 0);	-- ouput SAD value
		DATA_VALID : out std_logic	                        -- specifies whether the output SAD is valid or not
	);
end entity SAD;


architecture struct of SAD is
	
	-- DECLARING COMPONENTS NEEDED.

	component PIPOreg is
		generic (N : positive); -- N BITS PIPO REGISTER
		port (
			clk     : in  std_logic;
			rst     : in  std_logic;
			d       : in  std_logic_vector(N-1 downto 0);
			q       : out std_logic_vector(N-1 downto 0)
		);
	end component;

	component PhaseAccumulator is
		generic (N : positive );
		port(
			clk    : in  std_logic;
			rst    : in  std_logic;
			pa_in  : in  std_logic_vector(N-1 downto 0);
			pa_out : out std_logic_vector(N-1 downto 0)
		);
	end component;


	component counter is
		generic ( overflow_val : natural );
		port (
			count_puls   : in std_logic;
			count_enable : in std_logic;
			rst          : in std_logic;
			tc           : out std_logic
		);
	end component;

	component subtractor is
		generic (Nbit : positive);
		port (
			a : in  std_logic_vector(Nbit-1 downto 0);
			b : in  std_logic_vector(Nbit-1 downto 0);
			s : out std_logic_vector(Nbit-1 downto 0) 
		);
	end component;


	component mux2to1 is
		generic (Nbit : in positive );
		port (
			i0   : in  std_logic_vector(Nbit-1 downto 0);
			i1   : in  std_logic_vector(Nbit-1 downto 0);
			s    : in  std_logic;
			f    : out std_logic_vector(Nbit-1 downto 0)
		) ;
	end component ;


	-- intermediate signals
	signal padding               : std_logic_vector(SAD_bits-Nbit-1 downto 0); 
                                   -- turns the signal out off the subractor to a number of bits 
                                   -- coherent with the downstream signal

	signal PA_to_sub_nbit        : std_logic_vector(Nbit-1 downto 0);          
                                   -- connection from the out of the reg on the PA side to the subtractor

	signal PB_to_sub_nbit        : std_logic_vector(Nbit-1 downto 0);          
                                   -- connection from the out of the reg on the PB side to the subtractor

	signal sub_out_nbits         : std_logic_vector(Nbit-1 downto 0); 
                                   -- signal out of the subtractor (Nbit)

	signal pa_in                 : std_logic_vector(SAD_bits-1 downto 0);
                                   -- input to the phase accumulator

	signal pa_out                : std_logic_vector(SAD_bits-1 downto 0); 
                                   -- phase accumulator output wire
	
	signal mux_to_reg_out_wire   : std_logic_vector(SAD_bits-1 downto 0);
                                   -- connection from the multiplex to the output PIPO register
	
	signal rst_input_registers   : std_logic;
                                   -- reset input signal to the two heading PIPO registers

	signal sad_wire              : std_logic_vector(SAD_bits-1 downto 0); 
                                   -- output-register output (i.e. the actual SAD signal)
	
	signal tc_wire               : std_logic; 
	                               -- output of the counter
	signal hold_wire             : std_logic; 
	                               -- input to the MUX control signal. 
	                               -- it also coincides with DATA_VALID
	
	constant counter_of_value    : positive := Npixel+3; 
	                               -- counter overflow value, "+2" takes into account
	                               -- the delay caused by the upper chain, i.e.
	                               -- to get from PA to SAD.


begin
		
	rst_input_registers <= EN nand (not RST);
	hold_wire           <= EN nand (not tc_wire);


	reg_PA : PIPOreg
		generic map(Nbit)
		port map (CLK, rst_input_registers, PA, PA_to_sub_nbit);

	reg_PB : PIPOreg
		generic map(Nbit)
		port map (CLK, rst_input_registers, PB, PB_to_sub_nbit);


	-- generating some zeros to make the padding.
	gen_padding : for i in 0 to SAD_bits-Nbit-1 generate
		padding(i) <= '0';
	end generate;


	-- merging padding and sub_out_nbits to make a new signal called pa_in
	-- which enters the phase accumlator
	pa_in <= padding & sub_out_nbits;

	-- subtractor instance
	sub: subtractor
		generic map(Nbit)
		port map(PA_to_sub_nbit, PB_to_sub_nbit, sub_out_nbits);

	phaseacc: PhaseAccumulator
		generic map(SAD_bits)
		port map(CLK, RST, pa_in, pa_out);


	-- multiplexer on the output register side. 
	-- Needed to freeze the SAD signal when ENABLE is 0 and when the SAD computation is completed.
	mux1 : mux2to1
		generic map(SAD_bits)
		port map(pa_out, sad_wire, hold_wire, mux_to_reg_out_wire);

	reg_out: PIPOreg
		generic map(SAD_bits)
		port map (CLK, RST, mux_to_reg_out_wire, sad_wire);


	-- counter instance
	-- it counts up to counter_of_value, after that it sets its output to 1,
	-- hence the DATA_VALID signal of the system is high and the SAD value is frozen.
	cnt: counter
		generic map(counter_of_value)
		port map(CLK, EN, RST, tc_wire);

	
	-- connection of the intermediate signals to the output of the SAD.
	SAD        <= sad_wire;
	DATA_VALID <= tc_wire;


end architecture;
