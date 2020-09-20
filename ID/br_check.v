/* Condition checker for branch instructions. The output of this module itself has been taken as 
   the selector for PCsrc mux in the IF Stage. Non zero output implies branch is taken. 
   This module also controls the IF Flush signal, in case branch is taken and the current IF pipeline needs to be flushed. 

   It is possible to implement a slightly RTL based design, where a comparator is enabled for comparison, only when instruction is branch. 
   The aim must be to avoid the synthesis tool creating 2 comparators internal to the combinational block, and to reduce power consumption.

*/ 
`include "defines.v"

module br_check (in1, in2, BranchOp, Branch_taken, Flush );

input [`WORDLENGTH-1:0] in1, in2;
input [1:0] BranchOp;
output reg [1:0] Branch_taken;
output reg Flush;

always@(*)
begin 
    case (BranchOp)
       `NOT_BRANCH : begin  Branch_taken <= 2'b00; Flush <= 0; end 
       `BR_EQ: begin
           {Branch_taken, Flush} = (in1==in2)? {2'b01, 1'b1}: {2'b00, 1'b0};
       end 
       `BR_NEQ: begin 
            {Branch_taken, Flush} = (in1==in2)? {2'b00, 1'b0}: {2'b01, 1'b1}; 
       end 
       `BR_JUMP : begin Branch_taken <= 2'b10; Flush <= 1; end 
    endcase
end 
endmodule 




