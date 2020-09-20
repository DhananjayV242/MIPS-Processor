/* The memory module of the MIPS Processor. This contains all the data that is retrieved from 
   main memory. I have assumed just one level of memory. Adding a cache and a cache controller 
   can be an exercise. Add a data ready signal, which goes to the hazard detector, and causes a stall in the pipeline. */ 


module MEMStage( WB_control, ALU_out, Mem_out,
                 control_signals, Mem_address, Mem_input, clk, reset);

input [`WORDLENGTH-1:0] Mem_address, Mem_input;  
input [3:0] control_signals;
input clk, reset; 

output wire [1:0] WB_control;
output wire [`WORDLENGTH-1:0] ALU_out, Mem_out;

assign ALU_out = Mem_address;                                        // ALU_out from previous stage is address in MEM Stage
assign {RegWrite, MemtoReg, MemRead, MemWrite} = control_signals;

d_memory data_memory( Mem_out, Mem_address, Mem_input, MemRead, MemWrite, clk, reset);  

assign WB_control = {RegWrite, MemtoReg};

endmodule


