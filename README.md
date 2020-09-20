# MIPS-Processor 

This project aims at implementing a fully synthesisable model of a MIPS processor using Verilog HDL. 
The processor has been designed as a 5-stage pipelined MIPS processor, with data forwarding and hazard detection. 
The complete MIPS ISA has NOT been implemented. I have picked a couple of each Instruction types, enough to run basic sorting and
searching algorithms. 

All design techniques have been referred from Patterson and Hennessy's Computer Organisation and Design.  

## Features

Data Forwarding and Hazard detection, and stalling for Load-use, Branch-ALU, Branch-Load hazards have been included in the design. 
The main module has been constructed with the objective of being easy to debug. All important data lines have been declared as wires
to ensure visibility on a waveform visualizer. 

The repo contains a config file for GTKWAVE. Simply run ./run.sh within the folder and the necessary waveforms should come up on GTKWAVE. 

## Assembler

The Assembler.py file is just a very basic assembler to avoid having to continously encode instructions for the testbench. 
The file program.asm contains a couple of basic arithmetic instructions for you to test the working of the processor. On 
running the Assembler.py, it will encode the instructions in program.asm and write into instruction.memory file, byte organised
and in Little Endian format. 

Much can be done about the assembler though. I plan to incorporate options for the script, and include pseudoinstructions like 
MOV within the ISA. Ideally, it should be a script which has options to dictate program file, memory organisation. 


## Further development of processor

Increasing the number of R-instructions is easy, though. Simply edit the defines.v and controller.v file with the necessary opcodes and funct codes, and
edit the ALU.v file to perform the arithmetic.

The construction can be edited to include stack specific, or procedure specific instructions. This is slightly harder, as MUXs and control paths will 
be needed to select special registers. I'll do it later, lol.


