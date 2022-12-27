/*
    CS/ECE 552 FALL '22
    Homework #2, Problem 1
    
    a 1-bit full adder
*/
module fullAdder_1b(s, c_out, a, b, c_in);
    output s;
    output c_out;
    input  a, b;
    input  c_in;

    // YOUR CODE HERE
	wire mid1, mid2,mid3;

xor2 gate1(mid1,a,b);
xor2 gate2(s,mid1,c_in);
nand2 gate3(mid2,a,b);
nand2 gate4(mid3,mid1,c_in);
nand2 gate5(c_out,mid2,mid3);

endmodule
