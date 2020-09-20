
iverilog -y Common \
         -y IF \
         -y ID \
         -y EXE \
         -y MEM \
         -y WB -o test.out testbench.v 

vvp test.out 
gtkwave check.vcd config.gtkw
