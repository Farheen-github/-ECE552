/*
   CS/ECE 552 Spring '20
  
   Filename        : decode.v
   Description     : This is the module for the overall decode stage of the processor.
*/
module decode (instr,RegWrite,writeRegSel,writedata_src, PCplus2_write,
		PCplus2,set_result,writebackData,imm_signext,
		//ouputs
		r1,r2,PCjump,clk,rst);

input [10:0] instr;
input [15:0] PCplus2,PCplus2_write,writebackData,imm_signext;
output [15:0] r1,r2,PCjump;
input RegWrite, set_result;
input [1:0] writedata_src;
input [2:0] writeRegSel;
wire [2:0] read1RegSel,read2RegSel;
wire [15:0] data;


assign read1RegSel = instr[10:8];
assign read2RegSel = instr[7:5];
//00--> Rs
//01--> Rt
//10--> Rd
//11--> R7
//assign writeRegSel = RegDest[1]? (RegDest[0]?3'b111:instr[4:2]):(RegDest[0]?instr[7:5]:instr[10:8]);

//if signext_sel=1 --> extend by 0 to make unsigned immidiate otherwise extend the MSB/sign extension
//assign imm5bit = zeroext_sel ? {11'b00000000000,instr[4:0]} : {{11{instr[4]}},instr[4:0]};
//assign imm8bit = zeroext_sel ? {8'b00000000,instr[7:0]} : {{8{instr[7]}},instr[7:0]};
//assign imm_signext = Immsel? imm8bit:imm5bit;
//00--> WB data
//01--> Set data
//10--> PC+2
//11--> I(sign extended)
assign data = writedata_src[1]?(writedata_src[0]?imm_signext:PCplus2_write):(writedata_src[0]?{15'b000000000000000,set_result}:writebackData);
//assign data= writebackData;

input clk,rst;
wire err;


//regFile reg_module(.read1Data(r1), .read2Data(r2), .read1RegSel(read1RegSel), .read2RegSel(read2RegSel), .writeRegSel(writeRegSel), .writeData(data), .writeEn(RegWrite),.clk(clk),.rst(rst),.err(err));
regFile_bypass reg_module(.read1Data(r1), .read2Data(r2), .read1RegSel(read1RegSel), .read2RegSel(read2RegSel),.writeRegSel(writeRegSel), .writeData(data), .writeEn(RegWrite),.clk(clk),.rst(rst), .err(err));

PC_calc2 jumpPCcal(.PCplus2(PCplus2),.displacement(instr[10:0]),.PCjump(PCjump[15:0]));

endmodule
