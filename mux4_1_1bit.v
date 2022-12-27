
module mux4_1_1bit(sel, in1, in2, in3, in4, out);

	input in1, in2, in3, in4;
	input [1:0] sel;
	output out;
	wire temp1, temp2;
	
	mux2_1 iDut1(.sel(sel[0]), .in1(in1), .in2(in2), .out(temp1));
	mux2_1 iDut2(.sel(sel[0]), .in1(in3), .in2(in4), .out(temp2));
	mux2_1 iDut3(.sel(sel[1]), .in1(temp1), .in2(temp2), .out(out));
	
endmodule