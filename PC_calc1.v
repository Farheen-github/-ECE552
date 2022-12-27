
/*
   CS/ECE 552 Spring '20
  
   Filename        : PC_calc1.v
   Description     : This is the module for the PC update in fetch state;
*/
module PC_calc1 (PCaddr,nextPC,currPC,PCEn);

input [15:0] PCaddr;
output [15:0] nextPC,currPC;
input PCEn;


assign currPC = PCaddr;
wire [15:0] PCplus2;
cla_16b sum_mod(.sum(PCplus2[15:0]), .c_out(),.a(PCaddr[15:0]), 
	.b(16'h2), .c_in(1'b0), .sign(1'b0));

assign nextPC = PCEn ? PCplus2 : PCaddr; 

endmodule