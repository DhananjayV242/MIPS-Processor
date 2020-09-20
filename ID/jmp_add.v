//Jump address calculator 

module jmp_add ( address, PC, offset);

input [`WORDLENGTH-1:0] PC;
input [25:0] offset;
output [`WORDLENGTH-1:0] address;

assign address = {PC[31:28], offset,2'b00}; // Different from branch, where the offset is 
                                             // added to PC. 
endmodule 