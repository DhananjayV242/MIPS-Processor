
module mux4x1 #(parameter LENGTH = 32)(out, in1, in2, in3, in4, sel);

input [LENGTH-1:0] in1, in2, in3, in4;
input [1:0] sel;
output reg [LENGTH-1:0] out;

always@(*)
begin 
  case(sel)
    2'b00:  out = in1;
    2'b01:  out = in2;
    2'b10:  out = in3;
    2'b11:  out = in4;
  endcase
end 
endmodule 