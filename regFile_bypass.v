/*
   CS/ECE 552, Fall '22
   Homework #3, Problem #2
  
   This module creates a wrapper around the 8x16b register file, to do
   do the bypassing logic for RF bypassing.
*/
module regFile_bypass (
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
   wire write;
   /* YOUR CODE HERE */
   
   parameter OPERAND_WIDTH = 16;
   wire [OPERAND_WIDTH -1:0] r1d, r2d;
   wire r1_sel, r2_sel;
   
   assign r1_sel = (&(read1RegSel == writeRegSel)) & writeEn;
   assign r2_sel = (&(read2RegSel == writeRegSel)) & writeEn;
   assign write = writeEn;
   
   regFile #(.OPERAND_WIDTH(16)) iDUT(.read1Data(r1d), .read2Data(r2d), .err(err), .clk(clk), .rst(rst), .read1RegSel(read1RegSel), .read2RegSel(read2RegSel), .writeRegSel(writeRegSel), .writeData(writeData), .writeEn(writeEn));
   
   mux2_1 #(.OPERAND_WIDTH(16)) imux_r1(.in0(r1d[15:0]), .in1(writeData[15:0]), .out(read1Data[15:0]), .sel(r1_sel));
   mux2_1 #(.OPERAND_WIDTH(16)) imux_r2(.in0(r2d[15:0]), .in1(writeData[15:0]), .out(read2Data[15:0]), .sel(r2_sel));
   
   
endmodule
