/*
    CS/ECE 552 FALL'22
    Homework #2, Problem 1
    
    a 4-bit CLA block
*/
module CLA_block(g, p, c, a, b, c_in);

    // declare constant for size of inputs, outputs (N)
    parameter   N = 4;

    output [N-1:0] g, p;
    output [N:0] c;
    input [N-1: 0] a, b;
    input          c_in;

    // YOUR CODE HERE
wire [N-1:0] mid;
wire w11,w12,w13,w14,w15,w16,w17,w21,w22,w23,w24,w25,w31,w32,w33,w41,w42;
xor2 gate0(p[0],a[0],b[0]);
xor2 gate1(p[1],a[1],b[1]);
xor2 gate2(p[2],a[2],b[2]);
xor2 gate3(p[3],a[3],b[3]);

nand2 gate4(mid[0],a[0],b[0]);
not1 gate5(g[0],mid[0]);
nand2 gate6(mid[1],a[1],b[1]);
not1 gate7(g[1],mid[1]);
nand2 gate8(mid[2],a[2],b[2]);
not1 gate9(g[2],mid[2]);
nand2 gate10(mid[3],a[3],b[3]);
not1 gate11(g[3],mid[3]);

//c[4]
wire [4:0] terms4;

assign terms4[0]=g[3];

nand2 gate12(w11, p[3],g[2]);
not1 gate13(terms4[1],w11);

nand3 gate14(w12,p[3],p[2],g[1]);
not1 gate15(terms4[2],w12);

nand2 gate16(w13,p[3],p[2]);
nand2 gate17(w14,p[1],g[0]);
nor2 gate18(terms4[3],w13,w14);

nand3 gate19(w15,p[1],p[0],c_in);
nor2 gate20(terms4[4],w13,w15);

nor3 gate21(w16,terms4[0],terms4[1],terms4[2]);
nor2 gate22(w17,terms4[3],terms4[4]);
nand2 gate23(c[4],w16,w17);
 

//c[3]
wire [3:0] terms3;

assign terms3[0]=g[2];

nand2 gate24(w21, p[2],g[1]);
not1 gate25(terms3[1],w21);

nand3 gate26(w22,p[2],p[1],g[0]);
not1 gate27(terms3[2],w22);

nand2 gate28(w23,p[2],p[1]);
nand2 gate29(w24,p[0],c_in);
nor2 gate30(terms3[3],w23,w24);

nor2 gate31(w25,terms3[0],terms3[1]);
nor2 gate32(w26,terms3[3],terms3[2]);
nand2 gate33(c[3],w25,w26);

//c[2]
wire [2:0] terms2;

assign terms2[0]=g[1];

nand2 gate34(w31, p[1],g[0]);
not1 gate35(terms2[1],w31);

nand3 gate36(w32,p[1],p[0],c_in);
not1 gate37(terms2[2],w32);

nor3 gate38(w33, terms2[0], terms2[1], terms2[2]);
not1 gate39(c[2],w33);

//c[1]
wire [1:0] terms1;

assign terms1[0]=g[0];

nand2 gate40(w41, p[0],c_in);
not1 gate41(terms1[1],w41);

nor2 gate42(w42, terms1[0], terms1[1]);
not1 gate43(c[1],w42);

assign c[0]=c_in;
endmodule
