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


architecture beh of SAD is

	signal sumdiffs : std_logic_vector (SAD_bits-1 downto 0);	-- it mantains the sum of all the absolute differences until now, starting from the RST
	signal op_count : integer;	-- it counts the number of operations performed until now, starting from the RST
	constant zeros : std_logic_vector(SAD_bits-Nbit-1 downto 0) := (others => '0'); -- constant string of 0s; it is used to extend the inputs
	
	begin
		SAD_calc : process (CLK, RST)  
		-- internal variables
		variable extPA : std_logic_vector(SAD_bits-1 downto 0);	-- it adapts the input 'PA' to the output length
		variable extPB : std_logic_vector(SAD_bits-1 downto 0);	-- it adapts the input 'PB' to the output length
		variable diff : std_logic_vector(SAD_bits-1 downto 0);		-- it keeps the difference between 'PA' and 'PB' 
			begin
				-- RST event; it clears the output vars and the internal ones
				if (RST = '1') then
					DATA_VALID <= '0';
					op_count <= 0;
					extPA := (others => '0');
					extPB := (others => '0');
					diff := (others => '0');
					sumdiffs <= (others => '0');
				-- CLK positive edge; perform the computation
				elsif(CLK = '1' and CLK'event) then
					--DATA_VALID <= '0';
					-- it checks the 'EN' input; it skips all the operations if the latter is equal to 0
					if(EN = '1') then
						-- SAD computation is finished; it sets 'DATA_VALID' to 1	
						

						extPA := zeros & PA;
						extPB := zeros & PB;

						if unsigned(extPa) >= unsigned(extPb) then
							diff := std_logic_vector( unsigned(extPA) - unsigned(extPB) );
						else
							diff := std_logic_vector( unsigned(extPB) - unsigned(extPA) );
						end if;

						-- it computes the difference between the extended inputs
						-- diff := std_logic_vector(unsigned(extPA) - unsigned(extPB));
						-- it checks if the result is positive or not, and performs the abs eventually
						-- negative result; it changes the sign of the difference
						-- if(diff(8) = '1') then
						-- diff := std_logic_vector(-(signed(diff)));
						-- end if;
						-- it adds the current difference to the ones computed until now

						if(op_count + 1 >= Npixel) then
							DATA_VALID <= '1';
							sumdiffs <= std_logic_vector( unsigned(sumdiffs) );
						else
							sumdiffs <= std_logic_vector( unsigned(sumdiffs) + unsigned(diff) );
						end if;

						
						-- it increments the 'op_cont' and set the output
						op_count <= op_count + 1;
					end if;
				end if;
			end process;
			SAD <= sumdiffs;
end beh;

