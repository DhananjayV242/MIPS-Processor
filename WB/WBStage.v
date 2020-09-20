/* Write back stage for the MIPS processor. It's really a trivial stage. 
   The only real thing to take care of is that the correct data gets written into the Reg, and if not 
   inspect the active edge of the register file in relation to the pipeline registers. */ 

module WBStage ( out, RegWrite,  
                 WB_control, ALU_out, Mem_out, clk, reset);

input clk, reset;
input [1:0] WB_control;
input [`WORDLENGTH-1:0] ALU_out, Mem_out;


output [`WORDLENGTH-1:0] out;
output RegWrite; 

wire MemtoReg; 

assign {RegWrite, MemtoReg} = WB_control;

mux mem_or_r (out, ALU_out, Mem_out, MemtoReg); 

endmodule