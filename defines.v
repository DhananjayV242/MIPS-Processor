// definitions of constants used in this project 

// General constants

`define WORDLENGTH 32
`define OPCODE_LENGTH 6
`define FUNCT_LENGTH 6
`define SHAMT_LENGTH 5
`define REG_FILE_SIZE 32
`define REG_ADDRESS_LENGTH 5


// Memory constants

`define IMEM_SIZE 1024
`define DMEM_SIZE 1024
`define CELLSIZE 8

// Pipeline register constants 

`define IF_ID_LENGTH 64
`define ID_EXE_LENGTH 126
`define EXE_MEM_LENGTH 73
`define MEM_WB_LENGTH 71
// Opcodes and function encodings

`define R_INSTR 6'b000000
`define ADDI 6'b001000
`define SLTI 6'b001010
`define ANDI 6'b001100
`define ORI 6'b001101
`define XORI 6'b001110
`define LOAD_WORD 6'b100011
`define STORE_WORD 6'b101011
`define JUMP 6'b000010
`define BEQ 6'b000100
`define BNEQ 6'b000101

`define FUNCT_SLL 6'b000000
`define FUNCT_SRL 6'b000010
`define FUNCT_SRA 6'b000011
`define FUNCT_ADD 6'b100000
`define FUNCT_SUB 6'b100010
`define FUNCT_AND 6'b100100
`define FUNCT_OR 6'b100101
`define FUNCT_XOR 6'b100110
`define FUNCT_SLT 6'b101010
`define FUNCT_SLTU 6'b101011                     
 

// ALU operation selectors
`define NO_OP 4'b0000
`define ALU_SLL 4'b0001
`define ALU_SRL 4'b0010
`define ALU_SRA 4'b0011
`define ALU_ADD 4'b0100
`define ALU_SUB 4'b0101
`define ALU_AND 4'b0110
`define ALU_OR 4'b0111
`define ALU_XOR 4'b1000
`define ALU_SLT 4'b1001
`define ALU_SLTU 4'b1010                      // An exercise would be to find out the encodings that provide the simplest combinational block. The critical path 
                                              // of the controller's circuit plays a heavy role on the maximum clock frequency and dynamic power consumption of
                                              // processor. Observe that the immediate arithmetic instructions and functs have the same last 3 bits. 
// Branch operation selectors

`define NOT_BRANCH 2'b00
`define BR_JUMP 2'b01
`define BR_EQ 2'b10
`define BR_NEQ 2'b11










