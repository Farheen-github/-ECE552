
module decoder_w_en(sel, out);

parameter OPERAND_WIDTH = 8;
input [2:0] sel;
output [OPERAND_WIDTH -1:0] out;

assign out = sel[2] ? ( sel[1] ? (sel[0] ? (8'b10000000) : (8'b01000000) ) : (sel[0] ? (8'b00100000) : (8'b00010000) )  ) : (sel[1] ? (sel[0] ? (8'b00001000) : (8'b00000100) ) : (sel[0] ? (8'b00000010) : (8'b00000001) ) );

endmodule
