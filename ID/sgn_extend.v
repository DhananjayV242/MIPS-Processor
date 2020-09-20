// Sign extension module: 16 to 32 bits 

module sgn_extend ( in, out);

input [15:0] in;
output wire [`WORDLENGTH-1:0] out;

assign out = {{16{in[15]}}, in[15:0]};

endmodule 