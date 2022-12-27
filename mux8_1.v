
module mux8_1(in0, in1, in2, in3, in4, in5, in6, in7, out, sel);

parameter OPERAND_WIDTH = 16;
input [OPERAND_WIDTH -1:0] in0, in1, in2, in3, in4, in5, in6, in7;
output [OPERAND_WIDTH -1:0] out;
input [2:0] sel;

assign out = sel[2] ? ( sel[1] ? ( sel[0] ? (in7) : (in6) ) : ( sel[0] ? (in5) : (in4) ) ) : ( ( sel[1] ? ( sel[0] ? (in3) : (in2) ) : ( sel[0] ? (in1) : (in0) ) ) );

endmodule