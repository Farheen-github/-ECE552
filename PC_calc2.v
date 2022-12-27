
/*
   CS/ECE 552 Spring '20
  
   Filename        : PC_calc2.v
   Description     : This is the module for the PC update in decode stage;
*/
module PC_calc2 (PCplus2,displacement,PCjump);

input [15:0] PCplus2;
input [10:0] displacement;
output [15:0] PCjump;

wire [15:0] signext_displacement;
assign signext_displacement = {{5{displacement[10]}},displacement[10:0]};
//assign PCjump=signext_displacement;
cla_16b sum_mod(.sum(PCjump[15:0]), .c_out(),.a(PCplus2[15:0]), .b(signext_displacement[15:0]), 
	.c_in(1'b0), .sign(1'b1));

endmodule
	