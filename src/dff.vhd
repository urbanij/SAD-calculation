---------------------------------------------
-- Title       : dff
-- Project     : Final project: SAD Calculation
---------------------------------------------
-- File        : dff.vhd
-- Language    : VHDL
-- Author(s)   : Francesco Urbani
-- Company     : 
-- Created     : Thu May  3 16:00:02 CEST 2018
---------------------------------------------
-- Description : D flip-flop
---------------------------------------------
-- Update      :
---------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;

-- D flip flop
entity dff is
    port (
        clk  : in  std_logic;
        rst  : in  std_logic; -- active high
        d    : in  std_logic;
        q    : out std_logic
    );

end dff;


architecture beh of dff is
begin

    dff_p: process(clk, rst)
        begin
            if rst='1' then 
                q <= '0';
            elsif (clk='1' and clk'event) then
                q <= d;
            end if;
        end process dff_p;
end beh;
