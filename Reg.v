/*
   CS/ECE 552, Spring '22
   homework #3, Problem #1
  
   This module creates a 16 bit register.
*/
module Reg (
            // Output
            readData,
            // Inputs
            writeData, clk, rst, writeEn
            );

    parameter REG_SIZE = 16;
    output [REG_SIZE-1:0]   readData;
    input [REG_SIZE-1:0]    writeData;
    input                   clk, rst, writeEn;
	wire [REG_SIZE-1:0]		inputData;

	assign inputData = writeEn ? writeData : readData;

	dff iDFF[REG_SIZE-1:0] (.q(readData), .d(inputData), .clk(clk), .rst(rst));

endmodule
