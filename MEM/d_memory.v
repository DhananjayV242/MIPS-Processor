/* Data Memory for MIPS processor. Reset is synchronous. The memory has been designed in Little Endian format.   
   Write happens on the positive edge of the clock.
   Read operation is asyncronous on active high Enable signal  */

`include "defines.v"

module d_memory (out, address, data_in, ReadEn, WriteEn, clk, reset);

input clk, reset, ReadEn, WriteEn;
input [`WORDLENGTH-1:0] address, data_in; 

output [`WORDLENGTH-1:0] out; 

wire [`WORDLENGTH-1:0] base_address;
reg [`CELLSIZE-1:0] memory [0:`DMEM_SIZE-1];
integer i; 

assign base_address = {address[`WORDLENGTH-1:2],2'b00};
always @(posedge clk)
begin 
    if(reset) begin 
        for(i=0; i<`DMEM_SIZE; i++)
           memory[i]<=0;
    end
    else if(WriteEn) begin 
        {memory[base_address+3], memory[base_address+2],  memory[base_address+1],  memory[base_address]} <= data_in;
    end 
end 

assign out = ReadEn? {memory[base_address+3], memory[base_address+2],  memory[base_address+1],  memory[base_address]}:0;

endmodule

/* module test();

reg clk, reset, ReadEn, WriteEn; 
reg [`WORDLENGTH-1:0] address, data_in; 

wire [`WORDLENGTH-1:0] out;

d_memory uut(out, address, data_in, ReadEn, WriteEn, clk, reset);

initial 
begin 
    $dumpfile("dmem.vcd");
    $dumpvars;
end

always #5 clk = ~clk; 

initial
begin
  
  clk = 1; 
  reset = 1; 
  ReadEn = 0;
  WriteEn = 0;
  
  #15 reset =0; WriteEn = 1; 
      address = 32'd1;
      data_in = 32'd100;

  #10 address = 32'd8;
      data_in = 32'd800;

  #10 address = 32'd24; 
      data_in = 32'd2400;

  #10 address = 32'hfffffff0;
      data_in = 32'hffffffff;

  #10 address = 32'd1000;
      data_in = 32'd1000;

  #10 WriteEn = 0; ReadEn = 1;
      address = 32'd1;
      data_in = 32'd100;

  #10 address = 32'd8;
      data_in = 32'd800;

  #10 address = 32'd24; 
      data_in = 32'd2400;

  #10 address = 32'hfffffff0;
      data_in = 32'hffffffff;

  #12 address = 32'd1000;
      data_in = 32'd1000;

  
  #30 $finish; 

end 
endmodule 
*/ 