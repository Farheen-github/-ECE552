
/*
   CS/ECE 552 Spring '20
  
   Filename        : maincontrol.v
   Description     : This is the module for the overall control signals generation;
*/
module maincontrol (opcode,funcode,Branchsel,SETsel,writedata_src,
					RegDest,ALUop,zeroext_sel,j,jr,BTR,Branch,
					halt,RegWrite,Immsel,ALUsrc1,ALUsrc2,MemtoReg,MemRead,MemWrite,currPC);

input [4:0] opcode;
input [1:0] funcode;
output reg [1:0] Branchsel,SETsel,writedata_src,RegDest;
output reg [2:0] ALUop;
output reg Branch,zeroext_sel,j,jr,BTR,RegWrite,halt,
		Immsel,ALUsrc1,ALUsrc2,MemtoReg,MemRead,MemWrite;
input [15:0]currPC;
always @(opcode,funcode)
begin


casex(opcode)
//**********************HALT/NOP***************
//HALT
5'b00000:
begin
writedata_src=2'b00;
zeroext_sel=1'b0;
ALUsrc1=1'b0;
ALUsrc2=1'b0;
MemtoReg=1'b0;
MemRead=1'b0;
MemWrite=1'b0;
RegDest=2'b10;
RegWrite=1'b0;
Immsel=1'b0;
ALUop = {1'b0,funcode[1],funcode[0]};
BTR=1'b0;
Branchsel=2'b00;
SETsel=2'b00;
j=1'b0;
jr=1'b0;
Branch=1'b0;
halt=(currPC != 16'h0);
end

//NOP
5'b00001:
begin
writedata_src=2'b00;
zeroext_sel=1'b0;
ALUsrc1=1'b0;
ALUsrc2=1'b0;
MemtoReg=1'b0;
MemRead=1'b0;
MemWrite=1'b0;
RegDest=2'b10;
RegWrite=1'b0;
Immsel=1'b0;
ALUop = {1'b0,funcode[1],funcode[0]};
BTR=1'b0;
Branchsel=2'b00;
SETsel=2'b00;
j=1'b0;
jr=1'b0;
Branch=1'b0;
halt=1'b0;
end


//**********************J format***************
5'b00100:
begin
BTR=1'b0;
Branchsel=2'b00;
SETsel=2'b00;
MemtoReg=1'b0;
MemRead=1'b0;
MemWrite=1'b0;
ALUsrc1=1'b0;
ALUsrc2=1'b1;
ALUop = 3'b000;
RegDest = 2'b11;
zeroext_sel=1'b0;
Immsel=1;
Branch=1'b0;
halt=1'b0;
writedata_src=2'b00;
j=1'b1;
jr=1'b0;
RegWrite=1'b0;
end

5'b00101:
begin
BTR=1'b0;
Branchsel=2'b00;
SETsel=2'b00;
MemtoReg=1'b0;
MemRead=1'b0;
MemWrite=1'b0;
ALUsrc1=1'b0;
ALUsrc2=1'b1;
ALUop = 3'b000;
RegDest = 2'b11;
zeroext_sel=1'b0;
Immsel=1;
Branch=1'b0;
halt=1'b0;
writedata_src=2'b00;
j=1'b0;
jr=1'b1;
RegWrite=1'b0;
end

5'b00110:
begin
BTR=1'b0;
Branchsel=2'b00;
SETsel=2'b00;
MemtoReg=1'b0;
MemRead=1'b0;
MemWrite=1'b0;
ALUsrc1=1'b0;
ALUsrc2=1'b1;
ALUop = 3'b000;
RegDest = 2'b11;
zeroext_sel=1'b0;
Immsel=1;
Branch=1'b0;
halt=1'b0;
writedata_src=2'b10;
j=1'b1;
jr=1'b0;
RegWrite=1'b1;
end

5'b00111:
begin
BTR=1'b0;
Branchsel=2'b00;
SETsel=2'b00;
MemtoReg=1'b0;
MemRead=1'b0;
MemWrite=1'b0;
ALUsrc1=1'b0;
ALUsrc2=1'b1;
ALUop = 3'b000;
RegDest = 2'b11;
zeroext_sel=1'b0;
Immsel=1;
Branch=1'b0;
halt=1'b0;
writedata_src=2'b10;
j=1'b0;
jr=1'b1;
RegWrite=1'b1;
end


//**********************I1 format (arith)***************
5'b010xx:
begin
writedata_src=2'b00;
zeroext_sel=opcode[1];
ALUsrc1=1'b0;
ALUsrc2=1'b1;
MemtoReg=1'b0;
MemRead=1'b0;
MemWrite=1'b0;
RegDest=2'b01;
RegWrite=1'b1;
Immsel=1'b0;
ALUop = {1'b0,opcode[1],opcode[0]};
BTR=1'b0;
Branchsel=2'b00;
SETsel=2'b00;
j=1'b0;
jr=1'b0;
Branch=1'b0;
halt=1'b0;
end



//**********************I1 format (logical)***************
5'b101xx:
begin
writedata_src=2'b00;
zeroext_sel=1'b0;
ALUsrc1=1'b0;
ALUsrc2=1'b1;
MemtoReg=1'b0;
MemRead=1'b0;
MemWrite=1'b0;
RegDest=2'b01;
RegWrite=1'b1;
Immsel=1'b0;
ALUop = {1'b1,opcode[1],opcode[0]};
BTR=1'b0;
Branchsel=2'b00;
SETsel=2'b00;
j=1'b0;
jr=1'b0;
Branch=1'b0;
halt=1'b0;
end

//**********************I2 format (branch)***************
5'b011xx:
begin
writedata_src=2'b00;
zeroext_sel=1'b0;
ALUsrc1=1'b0;
ALUsrc2=1'b0;
MemtoReg=1'b0;
MemRead=1'b0;
MemWrite=1'b0;
RegDest=2'b01;
RegWrite=1'b0;
Immsel=1'b1;
ALUop = 3'b000;
BTR=1'b0;
Branchsel={opcode[1],opcode[0]};
SETsel=2'b00;
j=1'b0;
jr=1'b0;
Branch=1'b1;
halt=1'b0;
end


//**********************I1 format (store/load)***************
//ST
5'b10000:
begin
ALUsrc2=1'b1;
ALUop = 3'b000;
BTR=1'b0;
Branchsel=2'b00;
SETsel=2'b00;
writedata_src=2'b00;
j=1'b0;
jr=1'b0;
Branch=1'b0;
halt=1'b0;
MemtoReg=1'b0;
MemRead=1'b0;
MemWrite=1'b1;
RegWrite=1'b0;
zeroext_sel=1'b0;
ALUsrc1=1'b0;
RegDest=2'b01;
Immsel=1'b0;
end



//LD
5'b10001:
begin
ALUsrc2=1'b1;
ALUop = 3'b000;
BTR=1'b0;
Branchsel=2'b00;
SETsel=2'b00;
writedata_src=2'b00;
j=1'b0;
jr=1'b0;
Branch=1'b0;
halt=1'b0;
MemtoReg=1'b1;
MemRead=1'b1;
MemWrite=1'b0;
RegWrite=1'b1;
zeroext_sel=1'b0;
ALUsrc1=1'b0;
RegDest=2'b01;
Immsel=1'b0;
end

//SLBI
5'b10010:
begin
ALUsrc2=1'b1;
ALUop = 3'b000;
BTR=1'b0;
Branchsel=2'b00;
SETsel=2'b00;
writedata_src=2'b00;
j=1'b0;
jr=1'b0;
Branch=1'b0;
halt=1'b0;
MemtoReg=1'b0;
MemRead=1'b0;
MemWrite=1'b0;
RegWrite=1'b1;
zeroext_sel=1'b1;
ALUsrc1=1'b1;
RegDest=2'b00;
Immsel=1'b1;
end

//STU
5'b10011:
begin
ALUsrc2=1'b1;
ALUop = 3'b000;
BTR=1'b0;
Branchsel=2'b00;
SETsel=2'b00;
writedata_src=2'b00;
j=1'b0;
jr=1'b0;
Branch=1'b0;
halt=1'b0;
MemtoReg=1'b0;
MemRead=1'b0;
MemWrite=1'b1;
RegWrite=1'b1;
zeroext_sel=1'b0;
ALUsrc1=1'b0;
RegDest=2'b00;
Immsel=1'b0;
end



//**********************R format (arith+logical) + LBI ***************

//LBI
5'b11000:
begin 
ALUsrc1=1'b0;
ALUsrc2=1'b1;
MemtoReg=1'b0;
MemRead=1'b0;
MemWrite=1'b0;
RegDest=2'b00;
RegWrite=1'b1;
Immsel=1'b1;
ALUop = 3'b000;
BTR=1'b0;
writedata_src=2'b11;
zeroext_sel=1'b0;
Branchsel=2'b00;
SETsel=2'b00;
j=1'b0;
jr=1'b0;
Branch=1'b0;
halt=1'b0;
end

//BTR
5'b11001:
begin 
ALUsrc1=1'b0;
ALUsrc2=1'b0;
MemtoReg=1'b0;
MemRead=1'b0;
MemWrite=1'b0;
RegDest=2'b10;
RegWrite=1'b1;
Immsel=1'b0;
ALUop = 3'b000;
BTR=1'b1;
writedata_src=2'b00;
zeroext_sel=1'b0;
Branchsel=2'b00;
SETsel=2'b00;
j=1'b0;
jr=1'b0;
Branch=1'b0;
halt=1'b0;
end


//aithmetic instructions
5'b11011:
begin
writedata_src=2'b00;
zeroext_sel=1'b0;
ALUsrc1=1'b0;
ALUsrc2=1'b0;
MemtoReg=1'b0;
MemRead=1'b0;
MemWrite=1'b0;
RegDest=2'b10;
RegWrite=1'b1;
Immsel=1'b0;
ALUop = {1'b0,funcode[1],funcode[0]};
BTR=1'b0;
Branchsel=2'b00;
SETsel=2'b00;
j=1'b0;
jr=1'b0;
Branch=1'b0;
halt=1'b0;
end

//logical
5'b11010:
begin
writedata_src=2'b00;
zeroext_sel=1'b0;
ALUsrc1=1'b0;
ALUsrc2=1'b0;
MemtoReg=1'b0;
MemRead=1'b0;
MemWrite=1'b0;
RegDest=2'b10;
RegWrite=1'b1;
Immsel=1'b0;
ALUop = {1'b1,funcode[1],funcode[0]};
BTR=1'b0;
Branchsel=2'b00;
SETsel=2'b00;
j=1'b0;
jr=1'b0;
Branch=1'b0;
halt=1'b0;
end



//**********************R format (set instr)***************
5'b111xx:
begin
writedata_src=2'b01;
zeroext_sel=1'b0;
ALUsrc1=1'b0;
ALUsrc2=1'b0;
MemtoReg=1'b0;
MemRead=1'b0;
MemWrite=1'b0;
RegDest=2'b10;
RegWrite=1'b1;
Immsel=1'b0;
ALUop=3'b000;
SETsel={opcode[1],opcode[0]};
BTR=1'b0;
Branchsel=2'b00;
j=1'b0;
jr=1'b0;
Branch=1'b0;
halt=1'b0;
end

default: 
begin
writedata_src=2'b00;
zeroext_sel=1'b0;
ALUsrc1=1'b0;
ALUsrc2=1'b0;
MemtoReg=1'b0;
MemRead=1'b0;
MemWrite=1'b0;
RegDest=2'b10;
RegWrite=1'b1;
Immsel=1'b0;
ALUop = {1'b0,funcode[1],funcode[0]};
BTR=1'b0;
Branchsel=2'b00;
SETsel=2'b00;
j=1'b0;
jr=1'b0;
Branch=1'b0;
halt=(currPC != 16'h0);
end

endcase
end
endmodule