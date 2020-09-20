// Multiplexer of varying widths

module mux #(parameter LENGTH = 32)(out, in1, in2, sel);

input [LENGTH-1:0] in1, in2;
input wire sel;
output [LENGTH-1:0] out;

assign out = sel?in2:in1;

endmodule 

