
module mux4_1(sel, in1, in2, in3, in4, out);
	
	parameter OPERAND_WIDTH = 16;
	input [OPERAND_WIDTH -1:0] in1, in2, in3, in4;
	input [1:0] sel;
	output [OPERAND_WIDTH -1:0] out;
	// wire temp1, temp2;
	
	// mux2_1 iDut1(.sel(sel[0]), .in1(in1), .in2(in2), .out(temp1));
	// mux2_1 iDut2(.sel(sel[0]), .in1(in3), .in2(in4), .out(temp2));
	// mux2_1 iDut3(.sel(sel[1]), .in1(temp1), .in2(temp2), .out(out));
	
	assign out = sel[1] ? ( sel[0] ? (in4) : (in3) ) : ( sel[0] ? (in2) : (in1) ) ;
	
endmodule