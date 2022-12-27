/*
   CS/ECE 552, Fall '22
   Homework #3, Problem #1
  
   This module creates a 16-bit register.  It has 1 write port, 2 read
   ports, 3 register select inputs, a write enable, a reset, and a clock
   input.  All register state changes occur on the rising edge of the
   clock. 
*/
module regFile (
                // Outputs
                read1Data, read2Data, err,
                // Inputs
                clk, rst, read1RegSel, read2RegSel, writeRegSel, writeData, writeEn
                );

   input        clk, rst;
   input [2:0]  read1RegSel;
   input [2:0]  read2RegSel;
   input [2:0]  writeRegSel;
   input [15:0] writeData;
   input        writeEn;

   output [15:0] read1Data;
   output [15:0] read2Data;
   output        err;

   /* YOUR CODE HERE */
   parameter OPERAND_WIDTH = 16;
   wire [OPERAND_WIDTH -1:0] rg0_w, rg1_w, rg2_w, rg3_w, rg4_w, rg5_w, rg6_w, rg7_w;//, rg8_w, rg9_w, rg10_w, rg11_w, rg12_w, rg13_w, rg14_w, rg15_w;
   wire [OPERAND_WIDTH -1:0] rg0_wo, rg1_wo, rg2_wo, rg3_wo, rg4_wo, rg5_wo, rg6_wo, rg7_wo;//, rg8_wo, rg9_wo, rg10_wo, rg11_wo, rg12_wo, rg13_wo, rg14_wo, rg15_wo;
   wire [7:0] decO;
   wire mux21_sel0, mux21_sel1, mux21_sel2, mux21_sel3, mux21_sel4, mux21_sel5, mux21_sel6, mux21_sel7;
   wire write;
   
	assign write = writeEn;
	reg1 #(.OPERAND_WIDTH(16)) ireg00(.Input(rg0_w), .Output(rg0_wo), .clk(clk), .rst(rst));
	reg1 #(.OPERAND_WIDTH(16)) ireg01(.Input(rg1_w), .Output(rg1_wo), .clk(clk), .rst(rst));
	reg1 #(.OPERAND_WIDTH(16)) ireg02(.Input(rg2_w), .Output(rg2_wo), .clk(clk), .rst(rst));
	reg1 #(.OPERAND_WIDTH(16)) ireg03(.Input(rg3_w), .Output(rg3_wo), .clk(clk), .rst(rst));
	reg1 #(.OPERAND_WIDTH(16)) ireg04(.Input(rg4_w), .Output(rg4_wo), .clk(clk), .rst(rst));
	reg1 #(.OPERAND_WIDTH(16)) ireg05(.Input(rg5_w), .Output(rg5_wo), .clk(clk), .rst(rst));
	reg1 #(.OPERAND_WIDTH(16)) ireg06(.Input(rg6_w), .Output(rg6_wo), .clk(clk), .rst(rst));
	reg1 #(.OPERAND_WIDTH(16)) ireg07(.Input(rg7_w), .Output(rg7_wo), .clk(clk), .rst(rst));
	
	mux8_1 #(.OPERAND_WIDTH(16)) iMUX0(.in0(rg0_wo), .in1(rg1_wo), .in2(rg2_wo), .in3(rg3_wo), .in4(rg4_wo), .in5(rg5_wo), .in6(rg6_wo), .in7(rg7_wo), .out(read1Data), .sel(read1RegSel));
	mux8_1 #(.OPERAND_WIDTH(16)) iMUX1(.in0(rg0_wo), .in1(rg1_wo), .in2(rg2_wo), .in3(rg3_wo), .in4(rg4_wo), .in5(rg5_wo), .in6(rg6_wo), .in7(rg7_wo), .out(read2Data), .sel(read2RegSel));
	
	decoder_w_en #(.OPERAND_WIDTH(8)) iDEC0(.sel(writeRegSel), .out(decO));
	
	assign mux21_sel0 = writeEn & decO[0];
	assign mux21_sel1 = writeEn & decO[1];
	assign mux21_sel2 = writeEn & decO[2];
	assign mux21_sel3 = writeEn & decO[3];
	assign mux21_sel4 = writeEn & decO[4];
	assign mux21_sel5 = writeEn & decO[5];
	assign mux21_sel6 = writeEn & decO[6];
	assign mux21_sel7 = writeEn & decO[7];
	
	assign err = ((^read1RegSel == 1'bx) | (^read2RegSel == 1'bx) | (^writeRegSel == 1'bx) | (^writeData == 1'bx) | (writeEn == 1'bx)) == 1'bx;
	
	mux2_1 #(.OPERAND_WIDTH(16)) iMUX21_0(.in0(rg0_wo), .in1(writeData), .out(rg0_w), .sel(mux21_sel0));
	mux2_1 #(.OPERAND_WIDTH(16)) iMUX21_1(.in0(rg1_wo), .in1(writeData), .out(rg1_w), .sel(mux21_sel1));
	mux2_1 #(.OPERAND_WIDTH(16)) iMUX21_2(.in0(rg2_wo), .in1(writeData), .out(rg2_w), .sel(mux21_sel2));
	mux2_1 #(.OPERAND_WIDTH(16)) iMUX21_3(.in0(rg3_wo), .in1(writeData), .out(rg3_w), .sel(mux21_sel3));
	mux2_1 #(.OPERAND_WIDTH(16)) iMUX21_4(.in0(rg4_wo), .in1(writeData), .out(rg4_w), .sel(mux21_sel4));
	mux2_1 #(.OPERAND_WIDTH(16)) iMUX21_5(.in0(rg5_wo), .in1(writeData), .out(rg5_w), .sel(mux21_sel5));
	mux2_1 #(.OPERAND_WIDTH(16)) iMUX21_6(.in0(rg6_wo), .in1(writeData), .out(rg6_w), .sel(mux21_sel6));
	mux2_1 #(.OPERAND_WIDTH(16)) iMUX21_7(.in0(rg7_wo), .in1(writeData), .out(rg7_w), .sel(mux21_sel7));

endmodule