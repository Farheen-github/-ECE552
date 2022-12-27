module mux2_1(in0, in1, out, sel);

parameter OPERAND_WIDTH = 16;
input sel;
input [OPERAND_WIDTH -1:0] in0, in1;
output [OPERAND_WIDTH -1:0] out;


assign out = sel ? in1:in0;


endmodule
