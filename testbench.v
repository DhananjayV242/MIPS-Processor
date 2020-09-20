/* Test bench module for MIPS processor. I should be building a small compiler so that I can test large batches of code without having to 
   encode and assign memory addresses manually. */ 

`timescale 1ns/1ps

`include "defines.v"
`include "processor.v"


module testbench();

reg clk, reset; 
reg [7:0] memory [0:`IMEM_SIZE-2];
integer i;

processor CPU (clk, reset);

initial
begin
  
  $dumpfile("check.vcd");
  $dumpvars;
  $display("Loading instructions into memory");
  $readmemb("instruction.memory", memory);

end

always #5 clk = ~clk;

initial
begin 

   clk = 1;
   reset = 1; 

   for (i=0;i<`IMEM_SIZE-1;i++)
      CPU.IF_Stage.instruction_memory.memory[i+4] <= memory[i];

   #15 reset = 0;

   for (i=0; i<32; i++)
      CPU.ID_Stage.register_file.registers[i] <= i;
      
   #200
   $display( "At %t, the register file is now: ", $time);

   for (i=0; i<32; i++)
       $display( "r%d = %h", i, CPU.ID_Stage.register_file.registers[i]);

   $finish; 
end

endmodule


