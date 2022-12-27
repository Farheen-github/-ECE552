module reg1(Input, Output, clk, rst);

	parameter OPERAND_WIDTH = 16;
	input  [OPERAND_WIDTH -1:0] Input;
	input clk, rst;
	output  [OPERAND_WIDTH -1:0] Output;


	dff iDut00(.q(Output[0]), .d(Input[0]), .clk(clk), .rst(rst));
	dff iDut01(.q(Output[1]), .d(Input[1]), .clk(clk), .rst(rst));
	dff iDut02(.q(Output[2]), .d(Input[2]), .clk(clk), .rst(rst));
	dff iDut03(.q(Output[3]), .d(Input[3]), .clk(clk), .rst(rst));
	dff iDut04(.q(Output[4]), .d(Input[4]), .clk(clk), .rst(rst));
	dff iDut05(.q(Output[5]), .d(Input[5]), .clk(clk), .rst(rst));
	dff iDut06(.q(Output[6]), .d(Input[6]), .clk(clk), .rst(rst));
	dff iDut07(.q(Output[7]), .d(Input[7]), .clk(clk), .rst(rst));
	dff iDut08(.q(Output[8]), .d(Input[8]), .clk(clk), .rst(rst));
	dff iDut09(.q(Output[9]), .d(Input[9]), .clk(clk), .rst(rst));
	dff iDut10(.q(Output[10]), .d(Input[10]), .clk(clk), .rst(rst));
	dff iDut11(.q(Output[11]), .d(Input[11]), .clk(clk), .rst(rst));
	dff iDut12(.q(Output[12]), .d(Input[12]), .clk(clk), .rst(rst));
	dff iDut13(.q(Output[13]), .d(Input[13]), .clk(clk), .rst(rst));
	dff iDut14(.q(Output[14]), .d(Input[14]), .clk(clk), .rst(rst));
	dff iDut15(.q(Output[15]), .d(Input[15]), .clk(clk), .rst(rst));


endmodule