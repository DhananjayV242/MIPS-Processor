/* Hazard detection module for MIPS processor. The hazard detector takes care of the following hazards: 
   1. Load use hazard 
   2. Br-ALU stall or Br-x-Ld stall (1 cycle)
   3. Br-Ld stall (2 cycles)

These hazards have been controlled as advised by Patterson Hennessy textbook. */ 

`include "defines.v"

module hazard_control (ID_Rs, ID_Rt, BranchOp, EXE_Dest_Reg, MEM_Dest_Reg, ID_RegWrite, EXE_RegWrite, MEM_RegWrite, EXE_MemRead, MEM_MemRead, hazard_detected );

input [`REG_ADDRESS_LENGTH-1:0] ID_Rs, ID_Rt, EXE_Dest_Reg, MEM_Dest_Reg; 
input [1:0] BranchOp;
input ID_RegWrite, EXE_RegWrite, MEM_RegWrite;
input EXE_MemRead, MEM_MemRead; 

output hazard_detected;

wire EXE_match, MEM_match;
wire IsBranch, EXE_is_Load, MEM_is_Load;

assign EXE_match = EXE_RegWrite && (ID_Rs == EXE_Dest_Reg || ID_Rt == EXE_Dest_Reg);
assign MEM_match = MEM_RegWrite && (ID_Rs == MEM_Dest_Reg || ID_Rt == MEM_Dest_Reg);

assign IsBranch = (BranchOp ==`NOT_BRANCH || BranchOp == `BR_JUMP)? 0:1; 
assign EXE_is_Load = EXE_MemRead; 
assign MEM_is_Load = MEM_MemRead;

assign hazard_detected = (IsBranch && EXE_match) || (IsBranch && MEM_is_Load && MEM_match) || (ID_RegWrite && EXE_is_Load && EXE_match); 

endmodule



/* module testbench();

reg [`REG_ADDRESS_LENGTH-1:0] ID_Rs, ID_Rt, EXE_Dest_Reg, MEM_Dest_Reg; 
reg [1:0] BranchOp;
reg ID_RegWrite, EXE_RegWrite, MEM_RegWrite;
reg EXE_MemRead, MEM_MemRead; 


wire hazard_detected; 

hazard_control uut(ID_Rs, ID_Rt, BranchOp, EXE_Dest_Reg, MEM_Dest_Reg, ID_RegWrite, EXE_RegWrite, MEM_RegWrite, EXE_MemRead, MEM_MemRead, hazard_detected); 

initial 
begin
  
  $dumpfile("hazard.vcd");
  $dumpvars;
end

reg clk;
always #5 clk = ~clk;

initial
begin
  
  clk = 1;

  #5 
  ID_Rs <= 5'd3;
  ID_Rt <= 5'd4;
  EXE_Dest_Reg <= 5'd4; 
  MEM_Dest_Reg <= 5'd5; 
  ID_RegWrite <= 1;
  EXE_RegWrite <= 1;
  MEM_RegWrite <= 0;
  EXE_MemRead <= 0;
  MEM_MemRead <= 0; 
  BranchOp = 0;

  #5 
  ID_Rs <= 5'd3;
  ID_Rt <= 5'd4;
  EXE_Dest_Reg <= 5'd4; 
  MEM_Dest_Reg <= 5'd5; 
  ID_RegWrite <= 0;
  EXE_RegWrite <= 1;
  MEM_RegWrite <= 0;
  EXE_MemRead <= 0;
  MEM_MemRead <= 0; 
  BranchOp = 2'b10;

  #5 
  ID_Rs <= 5'd3;
  ID_Rt <= 5'd4;
  EXE_Dest_Reg <= 5'd4; 
  MEM_Dest_Reg <= 5'd5; 
  ID_RegWrite <= 1;
  EXE_RegWrite <= 1;
  MEM_RegWrite <= 0;
  EXE_MemRead <= 1;
  MEM_MemRead <= 0; 
  BranchOp = 2'b10;

  #20 $finish;


end

endmodule 

*/ 