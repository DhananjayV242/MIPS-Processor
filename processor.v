/* Complete architecture of MIPS processor, built from the 5 existing stages,  
   hazard detection unit, and pipeline registers. 

   I have tried to make this architecture as easy to analyse as possible. Important elements of the datapath 
   have been defined as wires that flow between stages, and elements, and should be traceable from a simulation tool. */ 


`include "defines.v" 

module processor (clk, reset);

input clk, reset;


wire stall, IF_Flush, clear;
wire [1:0] PC_src;
wire [`WORDLENGTH-1:0] instruction, PC_plus4; 
wire [`WORDLENGTH-1:0] branch_address, jump_address;
wire [`IF_ID_LENGTH-1:0] IF_ID_in, IF_ID_out; 

wire hazard_detected, RegWrite; 
wire ID_RegWrite; 
wire [0:14] ID_control; 
wire [0:14] ID_control_final; 
wire [1:0] BranchOp; 
wire [`WORDLENGTH-1:0] ID_PC, ID_instruction, data1, data2, imm_data, WriteData; 
wire [`REG_ADDRESS_LENGTH-1:0] Rs, Rt, Rd, WB_Dest_Reg; 

wire [1:0] Br_FwdA, Br_FwdB;
wire [`WORDLENGTH-1:0] br_in1, br_in2;
wire [`ID_EXE_LENGTH-1:0] ID_EXE_in, ID_EXE_out;

wire EXE_RegWrite, EXE_MemRead;
wire [0:14] EXE_control;
wire [3:0] EXE2MEM_control;
wire [1:0] Ex_FwdA, Ex_FwdB;
wire [`WORDLENGTH-1:0] EXE_in1, EXE_in2, EXE_data1, EXE_data2, EXE_imm_data, ALU_out, EXE_ST_data; 
wire [`REG_ADDRESS_LENGTH-1:0] EXE_Rs, EXE_Rt, EXE_Rd, EXE_Dest_Reg;
wire [`EXE_MEM_LENGTH-1:0] EXE_MEM_in, EXE_MEM_out; 

wire MEM_RegWrite, MEM_MemRead;
wire [0:3] MEM_control;
wire [1:0] MEM2WB_control;
wire [`WORDLENGTH-1:0] MEM_address, MEM_Data_input;  
wire [`WORDLENGTH-1:0] MEM_ALU_out, Mem_out;
wire [`REG_ADDRESS_LENGTH-1:0] MEM_Dest_Reg; 
wire [`MEM_WB_LENGTH-1:0] MEM_WB_in, MEM_WB_out;

wire [1:0] WB_control; 
wire [`WORDLENGTH-1:0] WB_ALU_out, WB_Mem_out;

/////////////////////                                    IF Stage                              //////////////////////////////////


IFStage IF_Stage( instruction, PC_plus4 ,branch_address, jump_address, PC_src, clk, hazard_detected, reset);  // Insert PC_src, stall, IF_Flush

///////////////////////                                IF/ID Pipeline                        ////////////////////////////////////

assign clear = IF_Flush|reset;

assign IF_ID_in = {PC_plus4, instruction};
register #(.LENGTH(`IF_ID_LENGTH)) IF_ID( IF_ID_out, IF_ID_in, ~hazard_detected, clk, clear);  // WriteEn needs to be opposite of stall signal
assign {ID_PC, ID_instruction} = IF_ID_out;

/////////////////////                                     ID Stage                              /////////////////////////////


hazard_control hazard_controller (Rs, Rt, BranchOp, EXE_Dest_Reg, MEM_Dest_Reg, 
                                  ID_RegWrite, EXE_RegWrite, MEM_RegWrite, EXE_MemRead, MEM_MemRead, 
                                  hazard_detected);


forwarding_unit br_fwd_unit(Rs, Rt, MEM_Dest_Reg, MEM_RegWrite, WB_Dest_Reg, RegWrite, Br_FwdA, Br_FwdB);
mux4x1 Fwd_Br1(br_in1, data1, MEM_ALU_out, WriteData, ,Br_FwdA);
mux4x1 Fwd_Br2(br_in2, data2, MEM_ALU_out, WriteData, ,Br_FwdB);


IDStage ID_Stage( ID_control, data1, data2, imm_data, Rs, Rt, Rd, BranchOp,                         // Control and arithmetic outputs
                  PC_src, IF_Flush, branch_address, jump_address,                                  // Branch information outputs 
                  br_in1, br_in2,                                                                  // inputs for branch checker
                  ID_PC, ID_instruction, WriteData, WB_Dest_Reg, RegWrite, clk, reset );     // replace hazard detection after construction

assign ID_RegWrite = ID_control[0];

mux #(.LENGTH(15)) Hazard_mux (ID_control_final, ID_control, 15'b0, hazard_detected);

/////////////////////////                              ID/EX Pipeline                               //////////////////////////////

assign ID_EXE_in = {ID_control_final, data1, data2, imm_data, Rs, Rt, Rd};
register #(.LENGTH(`ID_EXE_LENGTH)) ID_EXE( ID_EXE_out, ID_EXE_in, 1'b1, clk, reset);              // Never need to stall. Only need to zero control signals. 
assign {EXE_control, EXE_data1, EXE_data2, EXE_imm_data, EXE_Rs, EXE_Rt, EXE_Rd} = ID_EXE_out ;
assign EXE_RegWrite = EXE_control[0];                                                              // First signal in control bus is always kept as RegWrite 
assign EXE_MemRead = EXE_control[2];
/////////////////////////                               EXE Stage                                 /////////////////////////////////


forwarding_unit EXE_fwd_unit(EXE_Rs, EXE_Rt, MEM_Dest_Reg, MEM_RegWrite, WB_Dest_Reg, RegWrite , Ex_FwdA, Ex_FwdB);
mux4x1 Fwd_Alu1(EXE_in1, EXE_data1, MEM_ALU_out, WriteData, ,Ex_FwdA);
mux4x1 Fwd_Alu2(EXE_in2, EXE_data2, MEM_ALU_out, WriteData, ,Ex_FwdB); 

EXEStage EXE_Stage (ALU_out, EXE2MEM_control, EXE_Dest_Reg, EXE_ST_data,                                          // Outputs from EXE 
                EXE_control, EXE_in1, EXE_in2, EXE_imm_data, EXE_Rt, EXE_Rd, clk, reset );   // Data for ALU 

/////////////////////////                           EXE/MEM Pipeline                               //////////////////////////////

assign EXE_MEM_in = {EXE2MEM_control, ALU_out, EXE_ST_data, EXE_Dest_Reg};
register #(.LENGTH(`EXE_MEM_LENGTH)) EXE_MEM( EXE_MEM_out, EXE_MEM_in, 1'b1, clk, reset); 
assign {MEM_control, MEM_address, MEM_Data_input, MEM_Dest_Reg} = EXE_MEM_out; 
assign MEM_RegWrite = MEM_control[0]; 
assign MEM_MemRead = MEM_control[2]; 

/////////////////////////                             MEM Stage                                   //////////////////////////////


MEMStage MEM_Stage ( MEM2WB_control, MEM_ALU_out, Mem_out,
                     MEM_control, MEM_address, MEM_Data_input, clk, reset );

////////////////////////                           MEM/WB Pipeline                               //////////////////////////////// 

assign MEM_WB_in = {MEM2WB_control, MEM_ALU_out, Mem_out, MEM_Dest_Reg};
register #(.LENGTH(`MEM_WB_LENGTH)) MEM_WB( MEM_WB_out, MEM_WB_in, 1'b1, clk, reset);         
assign {WB_control, WB_ALU_out, WB_Mem_out, WB_Dest_Reg} = MEM_WB_out;

////////////////////////                              WB Stage                                 ///////////////////////////////// 

WBStage WB_Stage ( WriteData, RegWrite,  
                   WB_control, WB_ALU_out, WB_Mem_out, clk, reset); 

endmodule

