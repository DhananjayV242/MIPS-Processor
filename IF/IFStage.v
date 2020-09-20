// IF Stage

//`timescale 1ns/1ps;


module IFStage(instruction, PC_plus4, branch_address,jump_address, PC_src, clk, stall, reset);

input wire clk, reset, stall;
input wire [1:0] PC_src;
input wire [`WORDLENGTH-1:0] jump_address, branch_address;
output wire [`WORDLENGTH-1:0] instruction, PC_plus4;

wire [`WORDLENGTH-1:0] PC_in, PC_out;
wire clear;

register PC(PC_out, PC_in, ~stall, clk, reset);
fulladder PC_inc( PC_out, 32'd4, PC_plus4);
mux4x1 #(.LENGTH(32)) PC_source (PC_in, PC_plus4, branch_address, jump_address, , PC_src);

i_memory instruction_memory( instruction, PC_out, clk, reset);

endmodule


/*module IFtestbench();
reg [`WORDLENGTH-1:0] branch_address;
wire [`WORDLENGTH-1:0] instruction, PC_plus4;

reg clk, reset, PC_src, stall;

IFStage IFStage_object(instruction, PC_plus4, branch_address, 32'd0, PC_src, clk, stall, reset);

initial
begin 
    $dumpfile("IF_test.vcd");
    $dumpvars;
end 

always #5 clk = ~clk;

initial
begin
  clk = 1;
  reset = 1;
  PC_src = 0;
  stall = 0;

  branch_address = 32'd0;

  IFStage_object.instruction_memory.memory[4] <= 8'b00000100; //-- Add 	r2,r0,r1
  IFStage_object.instruction_memory.memory[5] <= 8'b01000000;
  IFStage_object.instruction_memory.memory[6] <= 8'b00001000;
  IFStage_object.instruction_memory.memory[7] <= 8'b00000000;

  IFStage_object.instruction_memory.memory[8] <= 8'b00001100; //-- sub	r3,r0,r1
  IFStage_object.instruction_memory.memory[9] <= 8'b01100000;
  IFStage_object.instruction_memory.memory[10] <= 8'b00001000;
  IFStage_object.instruction_memory.memory[11] <= 8'b00000000;

  IFStage_object.instruction_memory.memory[12] <= 8'b00010100; //-- And	r4,r2,r3
  IFStage_object.instruction_memory.memory[13] <= 8'b10000010;
  IFStage_object.instruction_memory.memory[14] <= 8'b00011000;
  IFStage_object.instruction_memory.memory[15] <= 8'b00000000;

  #5 reset = 0;

  #35 PC_src = 1;

  #100 $finish;

end
endmodule
*/
