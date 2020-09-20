
/* EXE Stage of MIPS processor. */ 

module EXEStage(ALU_out, ns_control, Dest_Reg, Mem_input,
                control_signals, in1, in2, ID_imm_data, ID_Rt, ID_Rd, clk, reset );

input [`WORDLENGTH-1:0] in1, in2, ID_imm_data;  
input [`REG_ADDRESS_LENGTH-1:0] ID_Rt, ID_Rd; 
input [14:0] control_signals;
input clk, reset;

output wire [`WORDLENGTH-1:0] ALU_out, Mem_input;          // Rt, which is required for store instructions. 
output wire [3:0] ns_control;
output wire [`REG_ADDRESS_LENGTH-1:0] Dest_Reg;


wire MemtoReg,RegWrite, MemRead, MemWrite, RegDst; 
wire [3:0] AluOp;
wire [`SHAMT_LENGTH-1:0] shamt;
wire [`WORDLENGTH-1:0] operand_2;
wire [1:0] FwdA, FwdB;

wire [`WORDLENGTH-1:0] in1, in2;

assign {RegWrite, MemtoReg, MemRead, MemWrite} = control_signals[14:11];
assign {AluOp, shamt, RegDst, IsImm} = control_signals[10:0];

mux #(.LENGTH(5)) dest_select(Dest_Reg,ID_Rt, ID_Rd, RegDst); 
 
mux R_or_Imm (operand_2, in2, ID_imm_data, IsImm);                // Forwarding needs to be overwritten by immediate value

Alu ALU (in1, operand_2, shamt, AluOp, ALU_out);

assign ns_control = {RegWrite, MemtoReg, MemRead, MemWrite};   // The spliting and rejoining of control signals is not really necessary.
                                                               // I just did it for additional clarity so that hazard detection can be writen easier. 
assign Mem_input = in2; 
endmodule 





/* module test();

reg clk, reset, hazard_detected;
reg [`IF_ID_LENGTH-1:0] IF_ID_out;

wire [13:0] control_signals;
wire [`WORDLENGTH-1:0] data1, data2;
wire [`REG_ADDRESS_LENGTH-1:0] Rs, Rt, Rd; 
wire [`ID_EXE_LENGTH-1:0] ID_EXE_out;

ID_Stage id_uut(IF_ID_out, control_signals, data1, data2, Rs, Rt, Rd, clk, reset, hazard_detected) ;
assign ID_EXE_out = {control_signals, data1, data2, Rs, Rt, Rd};
EXE_Stage exe_uut(ID_EXE_out, clk, reset);

initial
begin 
    $dumpfile("exe.vcd");
    $dumpvars;
end

always #5 clk = ~clk;

initial 
begin 

    clk = 1;
    reset = 1;
    hazard_detected = 0;

    #5 reset = 0; 
     id_uut.register_file.registers[0] <= 0;
     id_uut.register_file.registers[1] <= 1;
     id_uut.register_file.registers[2] <= 2;
     id_uut.register_file.registers[3] <= 3;
     id_uut.register_file.registers[4] <= 4;
     id_uut.register_file.registers[5] <= 5; 
     id_uut.register_file.registers[6] <= 6;
     id_uut.register_file.registers[7] <= 7;
     
     IF_ID_out <= {`ADDI,5'd1,5'd2,16'd18 };
  
  #15 IF_ID_out <= {`R_INSTR,5'd2,5'd3,5'd4, 5'd0, `FUNCT_ADD };
  #10 IF_ID_out <= {`R_INSTR,5'd3,5'd4,5'd5,5'd1,6'd0 };
  #10 IF_ID_out <= {`LOAD_WORD,5'd4,5'd5,16'd16 };
  #10 IF_ID_out <= {`STORE_WORD,5'd5,5'd6,16'd16 };
  #10 IF_ID_out <= {`BEQ,5'd6,5'd7,16'h0008 };
  #10 IF_ID_out <= {`JUMP,26'd10 };

  #20 $finish;

end 
endmodule
 */ 