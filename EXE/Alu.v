/* Definition of the ALU. I've prioritized scalability and written this module using behavioural modelling 
   but, a more involving exercise would be defining seperate gate level modules for all the functionalities, and 
   including them. For example, using a single full adder with overflow detector and select signal to choose between addition and subtraction. 

   But this module should give you a resonably realistic model if you define opcode values intelligently. Still can't beat gate level tho. */ 

   `include "defines.v"

   module Alu(in1, in2, shamt, AluOp, out );

   input [`WORDLENGTH-1:0] in1, in2; 
   input [`SHAMT_LENGTH-1:0] shamt; 
   input [3:0] AluOp;
   output reg [`WORDLENGTH-1:0] out;

   always@ (*)
   begin 
       case (AluOp)
         
         `NO_OP : out <= 0;
          
         `ALU_SLL : out <= (in1 << shamt);
         `ALU_SRL : out <= (in1 >> shamt);
         `ALU_SRA : out <= (in1 >>> shamt);

         `ALU_ADD : out <= (in1 + in2);
         `ALU_SUB : out <= (in1 - in2);
         
         `ALU_AND : out <= (in1 & in2);
         `ALU_OR : out <= (in1 | in2);
         `ALU_XOR : out <= (in1 ^ in2);

         `ALU_SLT : out <= ($signed(in1) < $signed(in2)) ? 1:0;  // The $signed system function is synthesisable. 
         `ALU_SLTU : out <= (in1<in2) ? 1:0;

       endcase
   end
endmodule

/* module testbench();

reg [31:0] in1, in2;
reg [4:0] shamt; 
reg [3:0] AluOp; 
reg clk; 

wire [31:0] out; 

Alu uut(in1, in2, shamt, AluOp, out);

initial 
begin 
    $dumpfile("alu.vcd");
    $dumpvars;
end 

always #5 clk = ~clk;

initial
begin 

    clk = 1; 

    in1 = 32'd25;
    in2 = 32'hffff_ff01;
    shamt = 5'd2;

    #10 AluOp = `NO_OP;
    #10 AluOp = `ALU_SLL;
    #10 AluOp = `ALU_SRL;
    #10 AluOp = `ALU_SRA;
    #10 AluOp = `ALU_ADD;
    #10 AluOp = `ALU_SUB;
    #10 AluOp = `ALU_AND;
    #10 AluOp = `ALU_OR;
    #10 AluOp = `ALU_XOR;
    #10 AluOp = `ALU_SLT;
    #10 AluOp = `ALU_SLTU;

    #50 $finish;
end 
endmodule

*/ 