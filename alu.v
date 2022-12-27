/*
    CS/ECE 552 FALL '22
    Homework #2, Problem 3

    A multi-bit ALU module (defaults to 16-bit). It is designed to choose
    the correct operation to perform on 2 multi-bit numbers from rotate
    left, shift left, shift right arithmetic, shift right logical, add,
    or, xor, & and.  Upon doing this, it should output the multi-bit result
    of the operation, as well as drive the output signals Zero and Overflow
    (OFL).
*/
module alu (InA, InB, Cin, Oper, invA, invB, sign, ALUout,BTRout, seq,slt,sle,sco,beqz,bnez,bltz,bgez);

    parameter OPERAND_WIDTH = 16;    
    parameter NUM_OPERATIONS = 3;
       
    input  [OPERAND_WIDTH -1:0] InA ; // Input operand A
    input  [OPERAND_WIDTH -1:0] InB ; // Input operand B
    input                       Cin ; // Carry in
    input  [NUM_OPERATIONS-1:0] Oper; // Operation type
    input                       invA; // Signal to invert A
    input                       invB; // Signal to invert B
    input                       sign; // Signal for signed operation
    output [OPERAND_WIDTH -1:0] ALUout,BTRout ; // Result of computation
    //output                      Ofl ; // Signal if overflow occured
    //output                      Zero; // Signal if Out is 0
    output                      seq,slt,sle,sco; // Signal if Out is 0
    output                      beqz,bnez,bltz,bgez;

    /* YOUR CODE HERE */

wire [OPERAND_WIDTH -1:0] inA,inB;
assign inA = invA ? ~InA : InA;
assign inB = invB ? ~InB : InB;


wire [OPERAND_WIDTH -1:0] ans1,ans2;
shifter shifter_unit(.In(inA[OPERAND_WIDTH-1:0]), .ShAmt(inB[3:0]), .Oper(Oper[NUM_OPERATIONS-2:0]), .Out(ans1[OPERAND_WIDTH-1:0]));

arithmetic arithmetic_unit(.InA(inA[OPERAND_WIDTH-1:0]), .InB(inB[OPERAND_WIDTH-1:0]), .Oper(Oper[NUM_OPERATIONS-2:0]),  .Cin(Cin), .Out(ans2[OPERAND_WIDTH-1:0]), .c_out(),.Ofl(),.sign(sign));

wire [OPERAND_WIDTH -1:0] w1;
wire Ofl_check;
arithmetic arithmetic_unit1(.InA(inB[OPERAND_WIDTH-1:0]), .InB(inA[OPERAND_WIDTH-1:0]), .Oper(2'b01),  .Cin(Cin), .Out(w1[OPERAND_WIDTH-1:0]), .c_out(),.Ofl(Ofl_check),.sign(sign));
arithmetic arithmetic_unit2(.InA(inA[OPERAND_WIDTH-1:0]), .InB(inB[OPERAND_WIDTH-1:0]), .Oper(2'b00),  .Cin(1'b0), .Out(),.c_out(sco), .Ofl(),.sign(1'b0));
//assign sco=1'b0;
assign seq = (w1==16'd0)? 1'b1:1'b0;
xor2 slt_xor (.out(slt),.in1(w1[OPERAND_WIDTH -1]),.in2(Ofl_check));
assign sle = (slt|seq)==1'b1 ? 1'b1 : 1'b0;

//assign slt = (w1[OPERAND_WIDTH -1]==1)?1'b1:1'b0;
//assign sle = (w1[OPERAND_WIDTH -1]==1'b1)?1'b1:((w1==16'd0)? 1'b1:1'b0);

assign beqz = (inA== 16'd0)? 1'b1:1'b0;
assign bnez = (inA != 16'd0)?1'b1:1'b0;
assign bltz = (inA[OPERAND_WIDTH -1]== 1'b1)?1'b1:1'b0;
assign bgez = (inA[OPERAND_WIDTH -1]== 1'b0)?1'b1:1'b0;

assign ALUout = (Oper[2] == 1'b0) ? ans2[OPERAND_WIDTH-1:0] : ans1[OPERAND_WIDTH-1:0]; 
assign BTRout = {InA[0],InA[1],InA[2],InA[3],InA[4],InA[5],InA[6],InA[7],InA[8],InA[9],InA[10],InA[11],InA[12],InA[13],InA[14],InA[15]};
endmodule
