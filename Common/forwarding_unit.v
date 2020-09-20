/* Forwarding unit for the MIPS processor. The selection is between outputs of ID Stage, MEM Stage, and WB Stage. 
   Checks if the destination address of the MEM Stage or the WB Stage is equal to the register that is accessed in the 
   current EXE stage. 
   
   An exercise would be to try and write it as a user defined primitive  */

   `include "defines.v"
   module forwarding_unit ( Rs, Rt, MEM_Rd, MEM_RegWrite, WB_Rd, WB_RegWrite, FwdA, FwdB);

   input [`REG_ADDRESS_LENGTH-1:0] Rs, Rt, MEM_Rd, WB_Rd;
   input MEM_RegWrite, WB_RegWrite;

   output [1:0] FwdA, FwdB; 

   assign FwdA = ((Rs==MEM_Rd) && MEM_RegWrite && MEM_Rd!=0)? 2'b01: ((Rs==WB_Rd) && WB_RegWrite && WB_Rd!=0)? 2'b10: 2'b00;
   assign FwdB = ((Rt==MEM_Rd) && MEM_RegWrite && MEM_Rd!=0)? 2'b01: ((Rt==WB_Rd) && WB_RegWrite && WB_Rd!=0)? 2'b10: 2'b00;

   endmodule

   /* module testbench();

   reg[4:0] Rs, Rt, MEM_Rd, WB_Rd;
   reg MEM_RegWrite, WB_RegWrite;
   reg clk;

   wire [1:0] FwdA, FwdB;

   forwarding_unit uut ( Rs, Rt, MEM_Rd, MEM_RegWrite, WB_Rd, WB_RegWrite, FwdA, FwdB);

   initial 
   begin 
     $dumpfile("f_unit.vcd");
     $dumpvars;
   end 

   always #5 clk = ~clk;

   initial 
   begin 
     
     clk = 1;
     Rs = 5'd3;
     Rt = 5'd15;
     MEM_RegWrite = 0;
     WB_RegWrite = 0;

    #10 MEM_Rd = 5'd3;
        WB_Rd = 5'd6;
    #10 MEM_Rd = 5'd6;
        WB_Rd = 5'd9;
    #10 MEM_Rd = 5'd9;
        WB_Rd = 5'd12;
    #10 MEM_Rd = 5'd12;
        WB_Rd = 5'd15;
    #10 MEM_Rd = 5'd15;
        WB_Rd = 5'd18;
    
    #10 MEM_RegWrite = 1;
        WB_RegWrite = 1;
    
    #10 MEM_Rd = 5'd3;
        WB_Rd = 5'd6;
    #10 MEM_Rd = 5'd6;
        WB_Rd = 5'd9;
    #10 MEM_Rd = 5'd9;
        WB_Rd = 5'd12;
    #10 MEM_Rd = 5'd12;
        WB_Rd = 5'd15;
    #10 MEM_Rd = 5'd15;
        WB_Rd = 5'd18;
    
    #10 MEM_RegWrite = 0;
        WB_RegWrite = 1;
    
    #10 MEM_Rd = 5'd3;
        WB_Rd = 5'd6;
    #10 MEM_Rd = 5'd6;
        WB_Rd = 5'd9;
    #10 MEM_Rd = 5'd9;
        WB_Rd = 5'd12;
    #10 MEM_Rd = 5'd12;
        WB_Rd = 5'd15;
    #10 MEM_Rd = 5'd15;
        WB_Rd = 5'd18;

    #200 $finish;
    
  end 
  endmodule 

*/ 

   





