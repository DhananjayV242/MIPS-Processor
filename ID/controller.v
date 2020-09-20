/* 
   The main controller for MIPS processor. I wanted to include conditional branch instructions apart from 
   just beq. Coupling this with the fact that I have implemented the branch condition checker also in the ID 
   stage, means that similar to AluOp, I will have to output a signal, BranchOp, to select the condition. 

   Also, the conventional method of implementing a seperate controller to select the ALU operation using funct 
   is not feasible as immediate arithmetic instructions do not use the funct space, creating an unnecessary  
   requirement of a seperate control signal for immediate operations. I have avoided this by using the funct space in the 
   main controller itself. I have tried to incorporate dont-care conditions, by not initializing wires to their values, when not required. 
   In case that makes you uncomfortable while debugging, you can initialize all control signals to zero, and then append as per requirement.  
*/

`include "defines.v"

module controller (opcode, funct, IsImm, RegDst, AluOp, BranchOp, MemWrite, MemRead, MemtoReg, RegWrite);

input [`OPCODE_LENGTH-1:0] opcode;
input [`FUNCT_LENGTH-1:0] funct;
output reg RegWrite, IsImm, RegDst, MemWrite, MemRead, MemtoReg;
output reg [3:0] AluOp;                                              // Change the length according to the number of instructions you require. 
output reg [1:0] BranchOp;  

always@(*)
begin 
    case (opcode)
        // R-Type instructions. Further selections will be done using the shamt and funct parameters. 

       `R_INSTR : begin 
           case (funct)
             `FUNCT_SLL : AluOp <= `ALU_SLL;
             `FUNCT_SRL : AluOp <= `ALU_SRL;
             `FUNCT_SRA : AluOp <= `ALU_SRA;
             `FUNCT_ADD : AluOp <= `ALU_ADD;
             `FUNCT_SUB : AluOp <= `ALU_SUB;
             `FUNCT_AND : AluOp <= `ALU_AND;
             `FUNCT_OR : AluOp <= `ALU_OR;
             `FUNCT_XOR : AluOp <= `ALU_XOR;
             `FUNCT_SLT : AluOp <= `ALU_SLT;
             `FUNCT_SLTU : AluOp <= `ALU_SLTU;
           endcase

           IsImm <=0;
           BranchOp<=`NOT_BRANCH;            //Signifies not a branch instruction
           RegDst<=1;              // Signifies destination is Rd
           MemRead<=0;
           MemWrite<=0;
           MemtoReg<=0;
           RegWrite<=1;
       end  
        
        // Instructions having immediate operands 

        `ADDI : begin
          AluOp<=`ALU_ADD;
          IsImm<=1;
          BranchOp<=`NOT_BRANCH;
          RegDst<=0; 
          MemRead<=0;
          MemWrite<=0;
          MemtoReg<=0;
          RegWrite<=1;
        end

        `SLTI : begin 
            AluOp <= `ALU_SLT;
            IsImm<=1;
            BranchOp<=`NOT_BRANCH;
            RegDst<=0; 
            MemRead<=0;
            MemWrite<=0;
            MemtoReg<=0;
            RegWrite<=1;
        end 

        `ANDI : begin 
            AluOp <= `ALU_AND;
            IsImm<=1;
            BranchOp<=`NOT_BRANCH;
            RegDst<=0; 
            MemRead<=0;
            MemWrite<=0;
            MemtoReg<=0;
            RegWrite<=1;
        end 

        `ORI : begin 
            AluOp <= `ALU_OR;
            IsImm<=1;
            BranchOp<=`NOT_BRANCH;
            RegDst<=0; 
            MemRead<=0;
            MemWrite<=0;
            MemtoReg<=0;
            RegWrite<=1;
        end 

        `XORI : begin 
            AluOp <= `ALU_XOR;
            IsImm<=1;
            BranchOp<=`NOT_BRANCH;
            RegDst<=0; 
            MemRead<=0;
            MemWrite<=0;
            MemtoReg<=0;
            RegWrite<=1;
        end

        // Instructions involving memory accesses 

        `LOAD_WORD : begin 
            AluOp <= `ALU_ADD;
            IsImm<=1;
            BranchOp<=`NOT_BRANCH;
            RegDst<=0; 
            MemRead<=1;
            MemWrite<=0;
            MemtoReg<=1;
            RegWrite<=1;
        end 

        `STORE_WORD : begin 
            AluOp <= `ALU_ADD;
            IsImm<=1;
            BranchOp<=`NOT_BRANCH;
            RegDst<=0; 
            MemRead<=0;
            MemWrite<=1;
            MemtoReg<=1;
            RegWrite<=0;
        end 

        // Branch Instructions 

        `JUMP : begin 
            AluOp <= `NO_OP;
            IsImm<=0;
            BranchOp<=`BR_JUMP;
            RegDst<=0; 
            MemRead<=0;
            MemWrite<=0;
            MemtoReg<=0;
            RegWrite<=0;
        end 

        `BEQ: begin 
            AluOp <= `NO_OP;
            IsImm<=0;
            BranchOp<=`BR_EQ;
            RegDst<=0; 
            MemRead<=0;
            MemWrite<=0;
            MemtoReg<=0;
            RegWrite<=0;
        end 

        `BNEQ : begin 
            AluOp <= `NO_OP;
            IsImm<=0;
            BranchOp<=`BR_NEQ;
            RegDst<=0; 
            MemRead<=0;
            MemWrite<=0;
            MemtoReg<=0;
            RegWrite<=0;
        end 
    endcase
end 
    
endmodule 
