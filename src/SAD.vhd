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
-- Description :
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
		Nbit       : positive := 8;		-- # of bits needed to represent the value of each pixel
		
		SAD_bits    : positive := 16 	    -- # of bits needed to represent the output
	);
	port (
		CLK        : in  std_logic;	                        -- CLK, active high
		RST        : in  std_logic;	                        -- RST, active high
		PA         : in  std_logic_vector(Nbit-1 downto 0);	-- input pixel value image A
		PB         : in  std_logic_vector(Nbit-1 downto 0);	-- input pixel value image B
		EN         : in  std_logic;	                        -- EN
		SAD        : out std_logic_vector(SAD_bits-1 downto 0);	-- ouput SAD
		DATA_VALID : out std_logic	                        -- specify if the output SAD is valid or not
	);
end entity SAD;




architecture struct of SAD is
	
	-- DECLARING COMPONENTS

	component reg is
		generic (N : positive); -- N BIT PIPO REGISTER
		port (
			clk     : in  std_logic;
			rst     : in  std_logic;
			d       : in  std_logic_vector(N-1 downto 0);
			q       : out std_logic_vector(N-1 downto 0)
		);
	end component;

	component upcounter is
		generic (Nbit : natural);
		port (
			count_puls   : in std_logic;
			count_enable : in std_logic;
			rst          : in std_logic;
			q            : out std_logic_vector(Nbit-1 downto 0);
			tc           : out std_logic
		);
	end component;

	component subtractor is
		generic (Nbit : positive);
		port (
			a : in std_logic_vector(Nbit-1 downto 0);
			b : in std_logic_vector(Nbit-1 downto 0);
			s : out std_logic_vector(Nbit-1 downto 0) -- sub/difference output
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

	component SR_latch is
		port (
			S     : in std_logic;
			R     : in std_logic;
			Q     : out std_logic;
			not_Q : out std_logic
		) ;
	end component;


	-- intermediate signals
	signal padding          : std_logic_vector(SAD_bits-Nbit-1 downto 0); -- turn the input to the subtractor into M bits, i.e. adds M-N bits ahead of PA/PB respectively
	signal PA_to_sub_nbit   : std_logic_vector(Nbit-1 downto 0); -- connection from the out of the reg on the PA side to the subtractor
	signal PB_to_sub_nbit   : std_logic_vector(Nbit-1 downto 0); -- connection from the out of the reg on the PB side to the subtractor
	signal PA_to_sub_mbit   : std_logic_vector(SAD_bits-1 downto 0); -- turning PA to M bits
	signal PB_to_sub_mbit   : std_logic_vector(SAD_bits-1 downto 0); -- turning PB to M bits

	signal sub_to_rca       : std_logic_vector(SAD_bits-1 downto 0); -- connection from the out of the subtractor    to one input of the rca
	signal reg_to_rca       : std_logic_vector(SAD_bits-1 downto 0); -- connection from the out of the loop register to one input of the rca

	
	signal rca_out          : std_logic_vector(SAD_bits-1 downto 0); -- rca output wire
	
	signal mux_to_reg_out_wire   : std_logic_vector(SAD_bits-1 downto 0);
	
	signal rst_input_registers : std_logic;

	signal sad_wire         : std_logic_vector(SAD_bits-1 downto 0); -- output register output (i.e. the actual SAD signal)
	signal tc_wire          : std_logic;
	signal s_latch_wire     : std_logic; -- from AND gate to S of SR latch
	signal hold_wire        : std_logic; -- from /Q of SR latch to HOLD of output register. This is also DATA_VALID
	signal sr_q_wire        : std_logic; -- from Q of SR latch to OR. this coincides with DATA_VALID


begin
	
	
	rst_input_registers <= (not RST) nand EN;
	hold_wire    <= EN        nand (not sr_q_wire);
	s_latch_wire <= (not RST) and  tc_wire;



	reg_PA : reg
		generic map(Nbit)
		port map (CLK, rst_input_registers, PA, PA_to_sub_nbit);

	reg_PB : reg
		generic map(Nbit)
		port map (CLK, rst_input_registers, PB, PB_to_sub_nbit);

	gen_padding : for i in 0 to SAD_bits-Nbit-1 generate
		padding(i) <= '0';
	end generate;

	PA_to_sub_mbit <= padding & PA_to_sub_nbit;
	PB_to_sub_mbit <= padding & PB_to_sub_nbit;



	sub: subtractor
		generic map(SAD_bits)
		port map(PA_to_sub_mbit, PB_to_sub_mbit, sub_to_rca);

	add: rca
		generic map(SAD_bits)
		port map(sub_to_rca, reg_to_rca, '0', rca_out, open);

	reg_loop: reg
		generic map(SAD_bits)
		port map (CLK, RST, rca_out, reg_to_rca);

	mux1 : mux2to1
		generic map(SAD_bits)
		port map(rca_out, sad_wire, hold_wire, mux_to_reg_out_wire);

	reg_out: reg
		generic map(SAD_bits)
		port map (CLK, RST, mux_to_reg_out_wire, sad_wire);

	cnt: upcounter
		generic map(8) -- warning: review this  -- [ ceil(log2(px^2)) ?]
		port map(CLK, EN, RST, open, tc_wire);

	sr : SR_latch
		port map(s_latch_wire, RST, sr_q_wire, open);

	
	
	SAD        <= sad_wire;
	DATA_VALID <= sr_q_wire;

end architecture;




--architecture beh of SAD is

--	signal sumdiffs : std_logic_vector (M-1 downto 0);	-- it mantains the sum of all the absolute differences until now, starting from the RST
--	signal op_count : integer;	-- it counts the number of operations performed until now, starting from the RST
--	constant zeros : std_logic_vector(M-N-1 downto 0) := (others => '0'); -- constant string of 0s; it is used to extend the inputs
	
--	begin
--		SAD_calc : process (CLK, RST)  
--		-- internal variables
--		variable extPA : std_logic_vector(M-1 downto 0);	-- it adapts the input 'PA' to the output length
--		variable extPB : std_logic_vector(M-1 downto 0);	-- it adapts the input 'PB' to the output length
--		variable diff : std_logic_vector(M-1 downto 0);		-- it keeps the difference between 'PA' and 'PB' 
--			begin
--				-- RST event; it clears the output vars and the internal ones
--				if (RST = '1') then
--					DATA_VALID <= '0';
--					op_count <= 0;
--					extPA := (others => '0');
--					extPB := (others => '0');
--					diff := (others => '0');
--					sumdiffs <= (others => '0');
--				-- CLK positive edge; perform the computation
--				elsif(CLK = '1' and CLK'event) then
--					--DATA_VALID <= '0';
--					-- it checks the 'EN' input; it skips all the operations if the latter is equal to 0
--					if(EN = '1') then
--						-- SAD computation is finished; it sets 'DATA_VALID' to 1	
						

--						extPA := zeros & PA;
--						extPB := zeros & PB;

--						if unsigned(extPa) >= unsigned(extPb) then
--							diff := std_logic_vector( unsigned(extPA) - unsigned(extPB) );
--						else
--							diff := std_logic_vector( unsigned(extPB) - unsigned(extPA) );
--						end if;

--						-- it computes the difference between the extended inputs
--						-- diff := std_logic_vector(unsigned(extPA) - unsigned(extPB));
--						-- it checks if the result is positive or not, and performs the abs eventually
--						-- negative result; it changes the sign of the difference
--						-- if(diff(8) = '1') then
--						-- diff := std_logic_vector(-(signed(diff)));
--						-- end if;
--						-- it adds the current difference to the ones computed until now

--						if(op_count + 1 >= Npixel) then
--							DATA_VALID <= '1';
--							sumdiffs <= std_logic_vector( unsigned(sumdiffs) );
--						else
--							sumdiffs <= std_logic_vector( unsigned(sumdiffs) + unsigned(diff) );
--						end if;

						
--						-- it increments the 'op_cont' and set the output
--						op_count <= op_count + 1;
--					end if;
--				end if;
--			end process;
--			SAD <= sumdiffs;
--end beh;



