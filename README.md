README
======

### intro
PSM Final Project – Spring 2018, University of Pisa.

---

### compiling and visualizing
Note: the following is the folder organization:

```
.
├── .work           contains the compiled files created by the compiler (GHDL in my case.)
├── screenshots     contains the screenshots of what was relevant screenshotting.
├── scripts         contains the scripts used to make a model of the project and automate some            
|                   procedures.
├── src             contains the `.vhd` files of the components used.
├── tb              contains the `.vhd` files of the test benches of the components above mentioned.
├── vivado          contains the vivado project 
└── waveforms       contains the `.vcd` file representing the waveforms of the simulations.
``` 



Once into `SAD/`, move into `.work/` and:
*  `$ ghdl -i ../src/*`<br>`$ ghdl -i  ../tb/*` <br> to import the `.vhd` files into the project.

* `$ ghdl -m sad` to compile to top level component -- case insensitive --,
(Substitute `sad` with the name of whatever other component's entity name of your choice that you want to compile. If a component x is part of a top-level component, the component x will be compiled as well when compiling the top-level component without the need of compiling a bunch of separate components separately which would be rather annoying.)

* `$ ghdl -m tb_sad` to compile the test bench of the top level component

* `$ ghdl -r tb_sad --vcd=../waveforms/tb_sad.vcd` to create a waveform file into the waveforms folder.

* open `tb_sad.vcd` with whichever vcd file visualizer. I've been using [Scansion](http://www.logicpoet.com/scansion/) which runs on Mac and it's pretty well made. [GTKWave](http://gtkwave.sourceforge.net/) is also an other option, and also runs on Linux.

