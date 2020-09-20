
/* ID Stage of MIPS Processor. I have followed the 'optimized' architecture where branch instructions have
   only one clock cycle delay. 
*/

module IDStage ( control_signals, data1, data2, sgn_extend_out, Rs, Rt, Rd, BranchOp,
                 Branch_taken, IF_Flush, branch_address, jump_address,
                 in1, in2, 
                 IF_ID_PC, instruction, WriteData, Write_dest, WriteEn, clk, reset);

input wire [`WORDLENGTH-1:0] IF_ID_PC, instruction, WriteData;
input [`WORDLENGTH-1:0] in1, in2; 
input [`REG_ADDRESS_LENGTH-1:0]  Write_dest; 
input wire  WriteEn;
input clk, reset;

output wire [14:0] control_signals;
output wire [`WORDLENGTH-1:0] data1, data2, sgn_extend_out;
output [`REG_ADDRESS_LENGTH-1:0] Rs, Rt, Rd;
output wire [1:0] Branch_taken, BranchOp; 
output IF_Flush;
output wire [`WORDLENGTH-1:0] branch_address, jump_address; 

wire [`REG_ADDRESS_LENGTH-1:0] Rs, Rt, Rd;
wire [`OPCODE_LENGTH-1:0] opcode;
wire [`SHAMT_LENGTH-1:0] shamt;
wire [`FUNCT_LENGTH-1:0] funct;
wire [15:0] immediate;
wire [25:0] jump_offset;

assign opcode = instruction[31:26];
assign Rs = instruction[25:21];
assign Rt = instruction[20:16];
assign Rd = instruction[15:11];
assign immediate = instruction[15:0];
assign shamt = instruction[10:6];
assign funct = instruction[5:0];
assign jump_offset = instruction[25:0];

wire  IsImm,  RegDst, RegWrite, MemWrite, MemRead, MemtoReg;
wire [3:0] AluOp;

wire [1:0] FwdA, FwdB;



RegFile register_file( data1, data2, Rs, Rt, Write_dest, WriteData, WriteEn, clk, reset);
controller main_controller ( opcode, funct, IsImm, RegDst, AluOp, BranchOp, MemWrite, MemRead, MemtoReg, RegWrite); // Add hazard signal 
sgn_extend sgn_extender( immediate, sgn_extend_out);


br_check br_condn_checker( in1, in2, BranchOp, Branch_taken, IF_Flush);
fulladder BR_ADDER( IF_ID_PC, (sgn_extend_out<<2), branch_address );
jmp_add jmp_address (jump_address, IF_ID_PC, jump_offset );

assign control_signals = {RegWrite, MemtoReg, MemRead, MemWrite, AluOp, shamt, RegDst,IsImm};


endmodule

/////////////////////////////////////////////////////////// TESTBENCH ///////////////////////////////////////////////////////////////////////////////////

/* module test();

reg [`IF_ID_LENGTH-1:0] IF_ID_out;
wire [5:0] opcode; 
wire [4:0] Rs,Rt,Rd;

reg clk, reset, hazard_detected; 

IDStage uut (IF_ID_out, clk, reset, hazard_detected);

initial 
begin 
  $dumpfile ("id_stage.vcd");
  $dumpvars;

end 

always #5 clk = ~clk; 

initial
begin
  
  clk = 1; 
  reset = 1; 
  hazard_detected = 0;

  #5 reset = 0; 
     uut.register_file.registers[0] <= 0;
     uut.register_file.registers[1] <= 1;
     uut.register_file.registers[2] <= 2;
     uut.register_file.registers[3] <= 3;
     uut.register_file.registers[4] <= 4;
     uut.register_file.registers[5] <= 5; 
     uut.register_file.registers[6] <= 6;
     uut.register_file.registers[7] <= 7;
     
     IF_ID_out <= {`ADDI,5'd1,5'd2,5'd0,11'd0 };
  
  #15 IF_ID_out <= {`ADDI,5'd2,5'd3,5'd0,11'd0 };
  #10 IF_ID_out <= {`R_INSTR,5'd3,5'd4,5'd5,11'd0 };
  #10 IF_ID_out <= {`LOAD_WORD,5'd4,5'd5,5'd0,11'd0 };
  #10 IF_ID_out <= {`STORE_WORD,5'd5,5'd6,5'd0,11'd0 };
  #10 IF_ID_out <= {`BEQ,5'd6,5'd7,16'h0008 };
  #10 IF_ID_out <= {`JUMP,26'd10 };

  
  #100 $finish; 

end 
endmodule 

*/ 

