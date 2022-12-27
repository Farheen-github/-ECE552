/*
   CS/ECE 552 Spring '20
  
   Filename        : execute.v
   Description     : This is the overall module for the execute stage of the processor.
*/
module execute (r1,r2,instr,ALUsrc1,ALUsrc2,ALUop,BTR,SETsel,Branchsel,RegDest, zeroext_sel, Immsel, 
		PCplus2, forwardA, forwardB, OutL3, writebackData, writedata_srcL3, writedata_srcL4, set_resultL3, set_resultL4,
		imm_signextL3, imm_signextL4, PCplus2L4, PCplus2L3, 
		//outputs
		Out,branch_result,set_result,writeRegSel,imm_signext,PCbranch,r2_out);

input [15:0] r1,r2,PCplus2, OutL3, writebackData, imm_signextL3, imm_signextL4, PCplus2L4, PCplus2L3;
input [10:0] instr;
input[2:0] ALUop;
input ALUsrc1,ALUsrc2,BTR, zeroext_sel, Immsel, set_resultL3, set_resultL4;
input [1:0] SETsel,Branchsel, RegDest, writedata_srcL3, writedata_srcL4, forwardA, forwardB;
output [15:0] Out, PCbranch,r2_out;
output branch_result,set_result;
output [15:0] imm_signext;
output [2:0] writeRegSel;

//in1, in2 for incoming data from decode stage while InA, InB after forwarding
wire [15:0] InA, InB, in1, in2;
wire seq,slt,sle,sco,beqz,bnez,bltz,bgez,set_res;
wire[15:0] ALUout,BTRout;
wire [15:0] imm5bit,imm8bit;

//00--> Rs
//01--> Rt
//10--> Rd
//11--> R7
assign writeRegSel = RegDest[1]? (RegDest[0]?3'b111:instr[4:2]):(RegDest[0]?instr[7:5]:instr[10:8]);


wire [15:0]imm;
//if signext_sel=1 --> extend by 0 to make unsigned immidiate otherwise extend the MSB/sign extension
assign imm5bit = zeroext_sel ? {11'b00000000000,instr[4:0]} : {{11{instr[4]}},instr[4:0]};
assign imm8bit = zeroext_sel ? {8'b00000000,instr[7:0]} : {{8{instr[7]}},instr[7:0]};
assign imm = Immsel? imm8bit:imm5bit;


//forwarding logic
assign imm_signext = imm;
wire [15:0] forwarded_result01, forwarded_result10;
assign forwarded_result01 = writedata_srcL4[1] ? (writedata_srcL4[0] ? imm_signextL4 : PCplus2L4) : (writedata_srcL4[0] ? {15'b000000000000000,set_resultL4} : writebackData);
assign forwarded_result10 = writedata_srcL3[1] ? (writedata_srcL3[0] ? imm_signextL3 : PCplus2L3) : (writedata_srcL3[0] ? {15'b000000000000000,set_resultL3} : OutL3);

assign in1 = (forwardA[1]==1'b0) ? ((forwardA[0]==1'b0) ? r1 : forwarded_result01) : ((forwardA[0]==1'b0) ? forwarded_result10 : r1);
assign in2 = (forwardB[1]==1'b0) ? ((forwardB[0]==1'b0) ? r2 : forwarded_result01) : ((forwardB[0]==1'b0) ? forwarded_result10 : r2);

//r2 out 

assign r2_out = in2;
//ALU source select

assign InA = ALUsrc1?(in1<<8):in1;
assign InB = ALUsrc2?imm_signext:in2;

alu_hier alu_mod(.InA(InA), .InB(InB), .Cin(1'b0), .Oper(ALUop), .invA(1'b0), .invB(1'b0), .sign(1'b1),
		 .ALUout(ALUout),.BTRout(BTRout),.seq(seq),.slt(slt),.sle(sle),.sco(sco),
		 .beqz(beqz),.bnez(bnez),.bltz(bltz),.bgez(bgez));

assign Out = BTR? BTRout:ALUout;
assign branch_result = (Branchsel[1]?(Branchsel[0]?bgez:bltz):(Branchsel[0]?bnez:beqz));  

assign set_result = SETsel[1]?(SETsel[0]?sco:sle):(SETsel[0]?slt:seq);  


PC_calc3 branchPC(.PCplus2(PCplus2),.immidiate(imm),.PCbranch(PCbranch));
endmodule
