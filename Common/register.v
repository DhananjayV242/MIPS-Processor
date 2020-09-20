// positive edge-triggered register, with synchronous reset. 
// Pipeline flushing cannot work if the reset is asynchronous. 

module register  #(parameter LENGTH = 32) (out, in, WriteEn, clk, reset);

input [LENGTH-1:0] in;
output reg [LENGTH-1:0] out;
input wire clk, WriteEn, reset;

always@(posedge clk)
begin
if(reset)
  out <= 0;
else if(WriteEn)
  out <= in;
end 

endmodule

