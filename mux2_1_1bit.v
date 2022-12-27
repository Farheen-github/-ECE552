
module mux2_1_1bit(sel, in1, in2, out);

	input in1, in2, sel;
	output out;
	wire sel_n, temp1, temp2;
	
	
	not1 iDut0(.out(sel_n), .in1(sel));	
	and2 iDut1(.out(temp1), .in1(in1), .in2(sel_n));
	and2 iDut2(.out(temp2), .in1(in2), .in2(sel));
	
	or2 iDut3(.out(out), .in1(temp1), .in2(temp2));
	
endmodule