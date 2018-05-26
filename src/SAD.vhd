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
-- Description : Actual SAD calculator (top level file)
---------------------------------------------
-- Update      :
---------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
-- use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;



entity SAD is
	generic (
		Npixel     : positive := 16;	-- total # of pixels of the image
		Nbit       : positive := 8;		-- # bits needed to represent the value of each pixel
		SAD_bits   : positive := 16 	-- # of bits needed to represent the output
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
		generic (N : positive); -- N BIT PIPO REGISTER
		port (
			clk     : in  std_logic;
			rst     : in  std_logic;
			d       : in  std_logic_vector(N-1 downto 0);
			q       : out std_logic_vector(N-1 downto 0)
		);
	end component;

	component counter is
		generic (
			overflow_val : natural := 25
		);
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
			a : in std_logic_vector(Nbit-1 downto 0);
			b : in std_logic_vector(Nbit-1 downto 0);
			s : out std_logic_vector(Nbit-1 downto 0) 
		);
	end component;
	
	component rca is
		generic (N : positive);
		port (
			x   : in  std_logic_vector(N -1 downto 0);
			y   : in  std_logic_vector(N -1 downto 0);
			c0  : in  std_logic;

			s   : out std_logic_vector(N -1 downto 0);
			cn  : out std_logic
		) ;
	end component;

	component mux2to1 is
		generic (Nbit : in positive );
		port (
			i0   : in std_logic_vector(Nbit-1 downto 0);
			i1   : in std_logic_vector(Nbit-1 downto 0);
			s    : in std_logic;
			f    : out std_logic_vector(Nbit-1 downto 0)
		) ;
	end component ;

	component SISOreg is
		generic (N  : positive := 3);
		port (
			SI   : in std_logic;
			clk  : in std_logic;
			rst  : in std_logic;
			SO   : out std_logic
		);

	end component;



	-- intermediate signals
	signal padding               : std_logic_vector(SAD_bits-Nbit-1 downto 0); 
                                   -- turns the signal out off the subractor to a number of bits 
                                   -- coherent with the following signals
	signal PA_to_sub_nbit        : std_logic_vector(Nbit-1 downto 0);          
                                   -- connection from the out of the reg on the PA side to the subtractor
	signal PB_to_sub_nbit        : std_logic_vector(Nbit-1 downto 0);          
                                   -- connection from the out of the reg on the PB side to the subtractor

	signal sub_to_rca_nbits      : std_logic_vector(Nbit-1 downto 0); 
                                   -- signal out of the subtractor
	signal sub_to_rca_SADbits    : std_logic_vector(SAD_bits-1 downto 0);
                                   -- signal out of the subtractor with SAD_bits (i.e. zeros on top)
	signal reg_to_rca            : std_logic_vector(SAD_bits-1 downto 0); 
                                   -- connection from the out of the loop register to one input of the rca

	signal counter_in            : std_logic; 
                                   -- input to the counter enable pin

	signal rca_out               : std_logic_vector(SAD_bits-1 downto 0); 
                                   -- rca output wire
	
	signal mux_to_reg_out_wire   : std_logic_vector(SAD_bits-1 downto 0);
                                   -- connection from the multiplex to the output PIPO register
	
	signal rst_input_registers   : std_logic;
                                   -- reset input signal to the heading PIPO registers 

	signal sad_wire              : std_logic_vector(SAD_bits-1 downto 0); 
                                   -- output-register output (i.e. the actual SAD signal)
	
	signal tc_wire               : std_logic; -- output of the counter
	signal hold_wire             : std_logic; -- input control signal of the output-MUX. This is also DATA_VALID




begin
	
	
	rst_input_registers <= (not RST) nand EN;
	hold_wire           <= EN        nand (not tc_wire);


	reg_PA : PIPOreg
		generic map(Nbit)
		port map (CLK, rst_input_registers, PA, PA_to_sub_nbit);

	reg_PB : PIPOreg
		generic map(Nbit)
		port map (CLK, rst_input_registers, PB, PB_to_sub_nbit);


	-- generating a bunch of zeros for the padding signal.
	gen_padding : for i in 0 to SAD_bits-Nbit-1 generate
		padding(i) <= '0';
	end generate;


	-- adding ahead of sub_to_rca_SADbits the padding in order to 
	-- make its length cohereng with the signals next to him.
	sub_to_rca_SADbits <= padding & sub_to_rca_nbits;

	-- subtractor instance
	sub: subtractor
		generic map(Nbit)
		port map(PA_to_sub_nbit, PB_to_sub_nbit, sub_to_rca_nbits);

	-- ripple carry adder instance
	add: rca
		generic map(SAD_bits)
		port map(sub_to_rca_SADbits, reg_to_rca, '0', rca_out, open);

	-- PIPO register on the loop side
	reg_loop: PIPOreg
		generic map(SAD_bits)
		port map (CLK, RST, rca_out, reg_to_rca);


	-- multiplexer on the output register side. 
	-- Needed to freeze the SAD signal when ENABLE is 0 and when the SAD computation is completed.
	mux1 : mux2to1
		generic map(SAD_bits)
		port map(rca_out, sad_wire, hold_wire, mux_to_reg_out_wire);

	reg_out: PIPOreg
		generic map(SAD_bits)
		port map (CLK, RST, mux_to_reg_out_wire, sad_wire);


	-- SISO register made of 2 D flip-flops. 
	-- Needed to delay the ENABLE signal going into the COUNT_ENABLE of the counter.
	-- This was necessary in order to sync the upper path of the SAD calculation
	-- and the COUNTER.
	siso: SISOreg
		generic map(2)
		port map(EN, CLK, RST, counter_in);

	-- counter. it counts up to Npixel * Npixel, after that it sets its output to 1,
	-- hence the DATA_VALID signal of the system is high and the SAD value is freezed.
	cnt: counter
		generic map(Npixel)
		port map(CLK, counter_in, RST, tc_wire);

	
	-- connection of the intermediate signals to the output of the SAD.
	SAD        <= sad_wire;
	DATA_VALID <= tc_wire;

end architecture;
