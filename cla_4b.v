/*
    CS/ECE 552 FALL'22
    Homework #2, Problem 1
    
    a 4-bit CLA module
*/
module cla_4b(sum, c_out, a, b, c_in);

    // declare constant for size of inputs, outputs (N)
    parameter   N = 4;

    output [N-1:0] sum;
    output         c_out;
    input [N-1: 0] a, b;
    input          c_in;

    // YOUR CODE HERE

wire [N-1:0] g,p;
wire [N:0] c;

CLA_block mod(g,p,c,a,b,c_in);


fullAdder_1b adder1(.s(sum[0]), .c_out(), .a(a[0]), .b(b[0]), .c_in(c[0]));
fullAdder_1b adder2(.s(sum[1]), .c_out(), .a(a[1]), .b(b[1]), .c_in(c[1]));
fullAdder_1b adder3(.s(sum[2]), .c_out(), .a(a[2]), .b(b[2]), .c_in(c[2]));
fullAdder_1b adder4(.s(sum[3]), .c_out(), .a(a[3]), .b(b[3]), .c_in(c[3]));
assign c_out=c[4];
endmodule
