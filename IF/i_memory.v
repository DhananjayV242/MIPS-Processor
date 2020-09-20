/* Instruction memory - This module has been written seperately as 
   this memory module needs to be synthesisable. Memory is in Little Endian format
   
   In this project memory is always byte organized, but if you want to change the cell size, you can by 
   changing the parameter CELLSIZE. 

   If you chose to do so, make sure that CELLSIZE * 4 = WORDLENGTH, otherwise, this module will fail to work as expected. 
*/ 

`include "defines.v"

module i_memory (instruction, address, clk, reset); // The clock has no particular use now, you can modify this module to write instructions, if you implement 
input wire [`WORDLENGTH-1:0] address;               // multi-level memory.  
output [`WORDLENGTH-1:0] instruction;
wire [`WORDLENGTH-1:0] base_address;

input reset,clk;

reg [`CELLSIZE-1:0] memory [0:`IMEM_SIZE-1];

// truncating the address to 30 bit to avoid illegal addresses
assign base_address = {address[`WORDLENGTH-1:2], 2'b00};

always@(*)
if(reset)
begin
  memory[3] <= 8'b00001000;
  memory[2] <= 8'b00000000;
  memory[1] <= 8'b00000000;
  memory[0] <= 8'b00000001; // fill jump instruction to desired start address. I'm keeping it as the next address. 
                         // But you can simulate the jump to bootloader location in memory and so on. 
end 

assign instruction = {memory[base_address+3], memory[base_address+2], memory[base_address+1], memory[base_address]};

endmodule



