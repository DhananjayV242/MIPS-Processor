// fulladder 

`include "defines.v"
module fulladder ( in1, in2, out);

input [`WORDLENGTH-1:0] in1, in2;
output [`WORDLENGTH-1:0] out;

assign out = in1+in2;

endmodule 