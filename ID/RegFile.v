
/* Register file of MIPS processor. I've kept it variable length,
   so feel free to change the number of registers in the defines file. Make sure 
   that REG_ADDRESS_LENGTH covers all of the registers. In case of invalid register numbers, make sure 
   to add an exception detector. 

*/ 

module RegFile ( data1, data2, Rs, Rt, Rd, WriteData, WriteEn, clk, reset);

input [`REG_ADDRESS_LENGTH-1:0] Rs, Rt, Rd;
input [`WORDLENGTH-1:0] WriteData;
input WriteEn, clk, reset;
output [`WORDLENGTH-1:0] data1, data2;

reg [`WORDLENGTH-1:0] registers [0:`REG_FILE_SIZE-1];
integer i;

always@(posedge clk)
begin 
    if(reset)
    begin
      for(i=0; i<`REG_FILE_SIZE; i++)
        registers[i]<= 0;
    end

   else if(WriteEn)
   registers[Rd]<=WriteData;
   registers[0]<= 0;
end 

assign data1 = registers[Rs];
assign data2 = registers[Rt];

endmodule 