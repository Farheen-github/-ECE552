
/*
   CS/ECE 552 Spring '20
  
   Filename        : PC_calc3.v
   Description     : This is the module for the PC update in execute stage;
*/
module PC_calc3 (PCplus2,immidiate,PCbranch);

input [15:0] PCplus2,immidiate;
output [15:0] PCbranch;

cla_16b sum_mod(.sum(PCbranch[15:0]), .c_out(),
	.a(PCplus2[15:0]), .b(immidiate[15:0]), 
	.c_in(1'b0), .sign(1'b1));




endmodule
	
