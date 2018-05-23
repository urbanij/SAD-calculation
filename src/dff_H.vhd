---------------------------------------------
-- Title       : dff_H
-- Project     : Final project: SAD Calculation
---------------------------------------------
-- File        : dff_H.vhd
-- Language    : VHDL
-- Author(s)   : Francesco Urbani
-- Company     : 
-- Created     : Tue May 22 20:32:52 CEST 2018
---------------------------------------------
-- Description : D flip-flop with HOLD
---------------------------------------------
-- Update      :
---------------------------------------------



library IEEE;
use IEEE.std_logic_1164.all;

-- D flip flop
entity dff_H is
    port (
        clk  : in  std_logic;
        rst  : in  std_logic; -- active high
        i    : in  std_logic; -- INPUT
        hold : in std_logic;  -- HOLD. if 1 the output q is fed back into the d input of the flip-flop.
        q    : out std_logic -- OUTPUT
    );

end dff_H;


architecture beh of dff_H is
begin

    dff_p: process(clk, rst)
        begin
            if rst='1' then 
                q <= '0';
            elsif (clk='1' and clk'event) then -- rising_edge(clk) eqiv to (clk='1' and clk'event)


            	-- the following if statement models a 2x1 MUX. 
            	-- hold acts as the control signal for the MUX.
            	-- if hold is set (1) q is fed back into d of the flip-flop
            	-- otherwise the external signal (i) goes into the flip-flop like a normal flip-flop.
                if hold='0' then
                	q <= i; 
                end if;

            end if;
        end process dff_p;
end beh;
