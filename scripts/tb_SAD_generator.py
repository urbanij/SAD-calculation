#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""
Created on Fri May 18 15:41:14 CEST 2018

@project     : Final project: SAD Calculation
@author(s)   : Francesco Urbani
@file        : tb_SAD_generator.py
@descritpion : Python model for the SAD calculation algorithm written in VHDL.
               It performs a model of the systems and it generates a coherent test bench.

               2^N >= 255 * px^2
"""

import sys
import time
import numpy as np
from pylab import *

def insert_N_and_px():
	N =int(input("N  = "))
	px=int(input("px = "))
	return N, px


# -----------------------------
SHOW_PLOT = 0  # set to 1 to show the plot
# N         = 8  # bits
# px        = 16 # num pixels. actually 16*16 is the num of pixels
# -----------------------------



now_ = time.ctime()[:20] + time.tzname[1] + " " + time.ctime()[20:]

prompt_ = input("\nWARNING\nYou're about to overwrite the file tb_SAD.vhd.\nDo you want to proceed? [y/n]\n")
try:
	if prompt_.lower() == "y":
		N, px = insert_N_and_px()
		if N < 1 or px < 1:
			print ("Aborting...")
			quit()	
		else:
			print ("tb_SAD.vhd updated.")
	else:
		print ("Aborting...")
		quit()
except Exception as e:
	print ("Aborting...")
	quit()



# creates two square matrices called PA and PB of size px, 
# with integer elements in the range [0, 2**N)
PA = int_(2**N * np.random.random((px, px)))
PB = int_(2**N * np.random.random((px, px)))

DIFF = abs(PA-PB)



# turn matrices into arrays
PA_array = np.asarray(PA).reshape(-1)
PB_array = np.asarray(PB).reshape(-1)

DIFF_array = np.asarray(DIFF).reshape(-1)
SAD_sequence = []
for i in range(0, px**2):
	SAD_sequence.append(np.sum(DIFF_array[:i+1]))
SAD_sequence = np.array(SAD_sequence)
# print (SAD_sequence)
SAD = SAD_sequence.reshape((px,px))
print (SAD)

# sum the values into SAD_array alltogether
SAD_value = np.sum(DIFF_array)

# print (SAD_array)


print ("SAD value = %d" %SAD_value)

M = int(np.ceil(np.log2((2**N-1) * px**2 ))) # minimum number of bit to correctly represent the SAD value
print ("Min num bits to represent correctly the SAD value = " + str(M))

SAD_value_bin = np.binary_repr(SAD_value, width=M)

# to show the matrices PA, PB and SAD in the initial comment of the test bench
PA_string = ""
for i in range(0, px):
	PA_string += "\n--     "+str(PA[i])

PB_string = ""
for i in range(0, px):
	PB_string += "\n--     "+str(PB[i])

DIFF_string = ""
for i in range(0, px):
	DIFF_string += "\n--     "+str(DIFF[i])

SAD_string = ""
for i in range(0, px):
	SAD_string += "\n--     "+str(SAD[i])



# filling the test bench file
tb = "\
---------------------------------------------\n\
-- Title       : tb_SAD\n\
-- Project     : Final project: SAD Calculation\n\
---------------------------------------------\n\
-- File        : tb_SAD.vhd\n\
-- Language    : VHDL\n\
-- Author(s)   : Francesco Urbani\n\
-- Company     : \n\
-- Created     : " + now_ + "\n\
---------------------------------------------\n\
-- Description : Autogenerated test bench for SAD.vhd\n\
---------------------------------------------\n\
-- Update      :\n\
---------------------------------------------\n\
\n\
-- THIS TEST BENCH IS AUTOGENERATED FROM SAD_model.py\n\
-- WARNING! All changes made in this file might be lost!\n\
\n\
\n\
\n\
-- INPUTS:\n\
-- N  = " + str(N) + " bit\n\
-- px = " + str(px) + "\n\
\n\
-- M_min := min num bits to correctly represent SAD\n\
-- M_min = ceil( log2( (2**N-1) * px**2 )) = \n\
--       = ceil( log2( " + str(2**N-1) + " * "+ str(px*px) +" )) = \n\
--       = " + str(M) + "\n\
\n\
\n\
-- PA = " + str(PA_string) + "\n\
-- PB = " + str(PB_string) + "\n\
\n\
-- OUTPUT:\n\
-- DIFF = " + str(DIFF_string) + "\n\
\n\
"
# -- SAD = " + str(SAD_string) + "\n\
tb+="-- SAD_value = sum(SAD) = " + str(SAD_value) + " = \"" + str(SAD_value_bin) + "\"\n\
\n\
\n\
\n\
library ieee;\n\
use ieee.std_logic_1164.all;\n\
--use ieee.std_logic_unsigned.all;\n\
--use ieee.numeric_std.all;\n\
\n\
\n\
entity tb_SAD is\n\
end entity tb_SAD; -- tb_SAD\n\
\n\
\n\
architecture struct of tb_SAD is\n\
	\n\
	component SAD is\n\
		generic(\n\
			N          : positive := " + str(N) + ";\n\
			M          : positive := " + str(M) + "\n\
		);\n\
		port(\n\
			CLK        : in  std_logic;\n\
			RST        : in  std_logic;\n\
			EN         : in  std_logic;\n\
			PA         : in  std_logic_vector(N-1  downto 0);\n\
			PB         : in  std_logic_vector(N-1  downto 0);\n\
			\n\
			SAD        : out std_logic_vector(M-1 downto 0); \n\
			DATA_VALID : out std_logic\n\
		);\n\
	end component SAD;\n\
\n\
\n\
	constant Nbit    : positive := " + str(N) + ";\n\
	constant Mbit    : positive := " + str(M) + ";\n\
	constant clk_per : time     := 5 ns;\n\
\n\
	signal clk       : std_logic := '0';\n\
	signal reset     : std_logic ;\n\
	signal enable    : std_logic ;\n\
	signal PA        : std_logic_vector(Nbit-1 downto 0) := \"" + np.binary_repr(0, width=N) + "\";\n\
	signal PB        : std_logic_vector(Nbit-1 downto 0) := \"" + str('X'*N) + "\";\n\
	\n\
	signal testing   : Boolean   := True;\n\
\n\
\n\
\n\
\n\
begin\n\
	clk <= not clk after clk_per/2 when testing;-- ELSE '0';\n\
\n\
\n\
	sad_i: SAD\n\
		generic map(Nbit, Mbit)\n\
		port map(clk, reset, enable, PA, PB, open, open);\n\
\n\
\n\
	drive_p: process\n\
	  	begin\n\
			\n\
			\n\
			wait for 23 ns;\n\
			reset <= '1';\n\
			enable <= '0';\n\
			wait until rising_edge(clk);\n\
			PB <= \"" + np.binary_repr(0, width=N) + "\";\n\
			wait for 40 ns;\n\
			reset <= '0';\n\
			wait until rising_edge(clk);\n\
			enable <= '1';\n\
			wait until rising_edge(clk);\n\
"

for i in range(0, px**2): # px**2 is the size of PA_array and PB_array
	tb += '\n\t\t\tPA <= "' + np.binary_repr(PA_array[i], width=N) + '";'
	tb += '\n\t\t\tPB <= "' + np.binary_repr(PB_array[i], width=N) + '";'
	tb += '\n\t\t\twait until rising_edge(clk);'
	tb += '\n'

tb += "\
			----------------------------------------\n\
			wait for 50 ns;\n\
			reset <= '1';\n\
			wait for 72 ns;\n\
			reset <='0';\n\
			----------------------------------------\n\
"


for i in range(0, px**2): # px**2 is the size of PA_array and PB_array
	# insert "random" enable swtching 
	if i==int(0.1 * px**2):
		tb += "\n\t\t\tenable <= '0';"
	if i==int(0.2 * px**2):
		tb += "\n\t\t\tenable <= '1';"

	if i==int(0.4 * px**2):
		tb += "\n\t\t\treset <= '1';"
	if i==int(0.42 * px**2):
		tb += "\n\t\t\treset <= '0';"

	tb += '\n\t\t\tPA <= "' + np.binary_repr(PA_array[i], width=N) + '";'
	tb += '\n\t\t\tPB <= "' + np.binary_repr(PB_array[i], width=N) + '";'
	tb += '\n\t\t\twait until rising_edge(clk);'
	tb += '\n'



tb += "\n\
			----------------------------------\n\
\n\
\n\
	  		wait for 190 ns;\n\
	  		testing <= False;\n\
	  		wait;\n\
	  	end process;\n\
\n\
	  	--drive_rst: process\n\
	  	--begin\n\
	  	--	wait for 80 ns;\n\
	    --	reset <= '1';\n\
	  	--	wait for 40 ns;\n\
	  	--	reset <= '0';\n\
	  	--	wait until rising_edge(clk);\n\
	  	--	wait;\n\
	  	--end process;\n\
\n\
\n\
	  	--drive_en : process\n\
	  	--begin\n\
  		--	wait for 44 ns;\n\
	  	--	enable <= '1';\n\
	  	--	wait for 89 ns;\n\
	  	--	enable <= '0';\n\
	  	--	wait for 71 ns;\n\
		--	enable <= '1';\n\
	  	--	wait for 1111 ns;\n\
	  	--	wait;\n\
	  	--end process;\n\
\n\
end architecture;\n\
\n\
"

with open("../tb/tb_SAD.vhd", "w") as f:
	f.write(tb)


# plot if SHOW_PLOT == 1
if SHOW_PLOT==1:
	grid(True)
	plot(PA_array,  'ob', markersize=2, label="PA")
	plot(PB_array,  'og', markersize=2, label="PB")
	plot(SAD_array, 'or', markersize=2, label="SAD = " + str(SAD_value))
	legend()
	show()

