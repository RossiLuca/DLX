# DLX

The project consists in the design, simulation and synthesis of a 5 stage pipelined DLX processor core in VHDL. After the basic functionalities it implements also: an extended ISA and an advanced ALU. Everything was optimized for delay and power efficiency. Physically implementation with place, route and clock tree synthesis.

## Structure of the project

* [Report](Report/) contains the documentations about the project including the final report, a block diagram of the datapath and a xlsx table with the control words for the instructions in the pipeline.
* [DLX_simulation](DLX_simulation/) contains all the VHDL files used to describe the design plus the [testbench](DLX_simulation/testbench) directory with the scripts and the programs used during the verification phase.
* [DLX_synthesis](DLX_synthesis/) contains the reports of the synthesis of the design with `Synopsys Design Compiler Tool`.
* [DLX_physical_implementation](DLX_physical_implementation) contains the reports of the physical implementation of the design using `Cadence Encounter Tool`.
