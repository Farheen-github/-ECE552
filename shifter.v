/*
    CS/ECE 552 FALL '22
    Homework #2, Problem 2
    
    A barrel shifter module.  It is designed to shift a number via rotate
    left, shift left, shift right arithmetic, or shift right logical based
    on the 'Oper' value that is passed in.  It uses these
    shifts to shift the value any number of bits.
 */
module shifter (In, ShAmt, Oper, Out);

    // declare constant for size of inputs, outputs, and # bits to shift
    parameter OPERAND_WIDTH = 16;
    parameter SHAMT_WIDTH   =  4;
    parameter NUM_OPERATIONS = 2;

    input  [OPERAND_WIDTH -1:0] In   ; // Input operand
    input  [SHAMT_WIDTH   -1:0] ShAmt; // Amount to shift/rotate
    input  [NUM_OPERATIONS-1:0] Oper ; // Operation type
    output [OPERAND_WIDTH -1:0] Out  ; // Result of shift/rotate

wire first_selector, second_selector;
wire [OPERAND_WIDTH -1:0] Out1,Out2;
assign first_selector=Oper[0];
assign second_selector=Oper[1];
   
leftshift_block left_module( .Inp(In[OPERAND_WIDTH-1:0]),.Out(Out1[OPERAND_WIDTH-1:0]),.ShAmt(ShAmt[SHAMT_WIDTH-1:0]),.en(first_selector));

rightshift_block right_module( .Inp(In[OPERAND_WIDTH-1:0]),.Out(Out2[OPERAND_WIDTH-1:0]),.ShAmt(ShAmt[SHAMT_WIDTH-1:0]),.en(first_selector));


assign Out = (second_selector==0) ? Out1 : Out2;


   
endmodule
