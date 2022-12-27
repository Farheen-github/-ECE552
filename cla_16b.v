/*
    CS/ECE 552 FALL '22
    Homework #2, Problem 1
    
    a 16-bit CLA module
*/
module cla_16b(sum, c_out,a, b, c_in, sign);

    // declare constant for size of inputs, outputs (N)
    parameter   N = 16;

    output [N-1:0] sum;
    output         c_out;
    input [N-1: 0] a, b;
    input          c_in;
    input          sign; // Signal for signed operation

    // YOUR CODE HERE
	wire [3:0] C; 
	cla_4b module1(.sum(sum[3:0]), .c_out(C[0]), .a(a[3:0]), .b(b[3:0]), .c_in(c_in));
	cla_4b module2(.sum(sum[7:4]), .c_out(C[1]), .a(a[7:4]), .b(b[7:4]), .c_in(C[0]));
	cla_4b module3(.sum(sum[11:8]), .c_out(C[2]), .a(a[11:8]), .b(b[11:8]), .c_in(C[1]));
	cla_4b module4(.sum(sum[15:12]), .c_out(C[3]), .a(a[15:12]), .b(b[15:12]), .c_in(C[2]));
	xor2 g1(w1,sum[15],C[3]);
	xor2 g2(w2,a[15],b[15]);
	xor2 g3(w3,w1,w2);
	assign c_out= sign?w3:C[3];
endmodule
