README
======

# compiling and visualizing.
Note: the following the folder organization:

`
.
├── .work
├── screenshots
├── scripts
├── src
├── tb
├── vivado
└── waveforms
`

`.work` contains the compiled files create by the compiler (`GHDL` in my case.)
`screenshots` contains the screenshots of whats relevant screenshotting.
`scripts` contains the scripts used to model the project or automate some stuff.
`src` contains the `.vhd` files of the components used.
`tb` contains the `.vhd` files of the test benches of the components above mentioned.
`vivado` contains the vivado project 
`waveforms` contains the `.vcd` file representing the waveforms of the simulations.


- Once into `SAD/`, move into `.work/` and:
1) 
`ghdl -i ../src/*`
`ghdl -i  ../tb/*`
to import the `.vhd` files into the project.

2)
`ghdl -m sad` to compile to top level component. 
(Subsitute `sad` with the name of whatever other component's entity name of your choice that you want to compile. If a component x is part of a top-level component, the component x will be compiled as well when compiling the top-level component without the neeed of compiling a bunch of separate components separately which would be fairly annoying.)

3)
`ghdl -m tb_sad` to compile the test bench of the top level component

4)
`ghdl -r tb_sad --vcd=../waveforms/tb_sad.vcd` to create a waveform file into the waveforms folder.

5)
open `tb_sad.vcd` with whichever vcd file visualizer. I've been using [Scansion](http://www.logicpoet.com/scansion/) which runs on Mac and it's pretty cool. [GTKWave](http://gtkwave.sourceforge.net/) is also an other option, and also runs on Linux.

