/*
    CS/ECE 552 FALL '22
    Homework #2, Problem 3
    
    An arithmetic module.  It is designed to perform addition of two numbers,
    AND, OR and XOR operations
 */
module arithmetic (InA, InB, Oper, Cin, Out, c_out, Ofl, sign);

    // declare constant for size of inputs, outputs, and # bits to shift
    parameter OPERAND_WIDTH = 16;
    parameter SHAMT_WIDTH   =  4;
    parameter NUM_OPERATIONS = 2;

    input  [OPERAND_WIDTH -1:0] InA   ; // Input operand A
    input  [OPERAND_WIDTH -1:0] InB   ; // Input operand A
    input  [NUM_OPERATIONS-1:0] Oper ; // Operation type
    output [OPERAND_WIDTH -1:0] Out  ; // Result of arithmetic
    input                       Cin ; // Carry in
    output                      c_out,Ofl ; // Signal if carry or overflow
    input                       sign; // Signal for signed operation

wire [OPERAND_WIDTH -1:0] midwires1,midwires2,midwires3,midwires4;
//ADD
cla_16b sub_cla(.sum(midwires1), .c_out(c_out), .a(InA), .b(InB), .c_in(Cin), .sign(sign));
//assign midwires1=InA+InB+Cin;

//SUB
wire [OPERAND_WIDTH -1:0] mid1,w;
assign w=16'hffff;
xor2 sub_xors1 [OPERAND_WIDTH-1:0] (.out(mid1),.in1(w),.in2(InA));
cla_16b sub_cla1(.sum(midwires2), .c_out(Ofl), .a(InB), .b(mid1), .c_in(1'b1), .sign(sign));
//assign midwires2=InB-InA;

//XOR
xor2 sub_xors2 [OPERAND_WIDTH-1:0] (.out(midwires3),.in1(InA),.in2(InB));
//assign midwires3 = InA ^ InB;
//ANDN
wire [OPERAND_WIDTH -1:0] mid2,mid3;
xor2 sub_xors3 [OPERAND_WIDTH-1:0] (.out(mid2),.in1(w),.in2(InB));
nand2 sub_nands [OPERAND_WIDTH-1:0] (.out(mid3),.in1(InA),.in2(mid2));
not1 sub_nots1 [OPERAND_WIDTH-1:0] (.out(midwires4),.in1(mid3));
//assign midwires4=InA & (~InB);
assign Out = (Oper[1]) ? (Oper[0]? midwires4:midwires3 ) : (Oper[0]? midwires2:midwires1 );


   
endmodule

