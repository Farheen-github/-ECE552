
/* $Author: sinclair $ */
/* $LastChangedDate: 2020-02-09 17:03:45 -0600 (Sun, 09 Feb 2020) $ */
/* $Rev: 46 $ */
module proc (/*AUTOARG*/
   // Outputs
   err, 
   //Inputs
   clk, rst
   );

   input clk,rst;
  // wire clk,rst;

   output err;

   // None of the above lines can be modified

   // OR all the err ouputs for every sub-module and assign it as this
   // err output
   
   // As desribed in the homeworks, use the err signal to trap corner
   // cases that you think are illegal in your statemachines
   
   
   /* your code here -- should include instantiations of fetch, decode, execute, mem and wb modules */
 
wire [15:0] currPC,instruction,PCplus2,PCbranch,PCjump,writebackData,r1,r2,imm_signext,Out,mem_out,r2_out;
wire [1:0] Branchsel,SETsel,writedata_src,RegDest, forwardA, forwardB;
wire [2:0] ALUop,writeRegSel;
wire branchand_sel,halt,branch_result,zeroext_sel,j,jr,BTR,Branch,RegWrite,Immsel,
	ALUsrc1,ALUsrc2,MemtoReg,MemRead,MemWrite,set_result;

//Latch1 out
wire [15:0] instrL1, PCplus2L1, currPCL1;
//wire haltL1;
//Latch2 out
wire [1:0] BranchselL2,SETselL2,writedata_srcL2,RegDestL2;
wire [2:0] ALUopL2;
wire haltL2,zeroext_selL2,jL2,jrL2,BTRL2,BranchL2,RegWriteL2,ImmselL2,ALUsrc1L2,
	ALUsrc2L2,MemtoRegL2,MemReadL2,MemWriteL2;
wire [15:0] PCjumpL2,PCplus2L2,r2L2,r1L2,instrL2;

//Latch3 out

wire [1:0]writedata_srcL3;
wire [2:0]writeRegSelL3;
wire haltL3,jL3,jrL3,BranchL3,RegWriteL3,MemtoRegL3,MemReadL3,MemWriteL3,branch_resultL3,set_resultL3;
wire [15:0]OutL3, PCjumpL3,r2L3, PCbranchL3,imm_signextL3,PCplus2L3;
//Latch4 out

wire [1:0]writedata_srcL4;
wire [2:0]writeRegSelL4;
wire haltL4,RegWriteL4,MemtoRegL4,set_resultL4,branchand_selL4, jL4, jrL4;
wire [15:0] imm_signextL4,PCplus2L4,mem_outL4,OutL4, PCbranchL4, PCjumpL4;

wire stall, invalidate, IsUnaligned_I, IMemStall, DMemStall, IsUnaligned_M, alignment_err, Done, cachehitD, cachehitI;

assign err = 1'b0;
 

fetch fetch0   (.instr(instruction[15:0]),.PCplus2(PCplus2), .j(jL3), .jr(jrL3), .branch_result(branchand_sel),.PCEn(~(stall|IMemStall|DMemStall)),
		.PCjump(PCjumpL3), .PCjumpreg(OutL3), .PCbranch(PCbranchL3),.currPC(currPC),.rst(rst),.clk(clk), .halt(halt), .IsUnaligned_I(IsUnaligned_I), 
		.IMemStall(IMemStall), .cachehitI(cachehitI));

wire [48:0] latch_in1, latch_out1;

assign latch_in1 = {IsUnaligned_I, currPC,PCplus2,instruction};
latch_ifid #(.OPERAND_WIDTH(49)) if_id(.clk(clk),.rst(rst),.stall(stall|DMemStall|IMemStall),.invalidate(invalidate),
				  .latch_write_data(latch_in1),.latch_read_data(latch_out1));

assign instrL1=latch_out1[15:0];
assign PCplus2L1= latch_out1[31:16]; 
assign currPCL1 = latch_out1[47:32];
assign IsUnaligned_IL1 = latch_out1[48];


maincontrol control(.opcode(instrL1[15:11]),.funcode(instrL1[1:0]),.currPC(currPCL1),.Branchsel(Branchsel),.SETsel(SETsel),
		    .writedata_src(writedata_src),.RegDest(RegDest),.ALUop(ALUop),.zeroext_sel(zeroext_sel),
		    .j(j),.jr(jr),.BTR(BTR),.Branch(Branch),.RegWrite(RegWrite),
		    .Immsel(Immsel),.ALUsrc1(ALUsrc1),.ALUsrc2(ALUsrc2),.MemtoReg(MemtoReg),.MemRead(MemRead),
		    .MemWrite(MemWrite),.halt(halt));

decode decode0(.instr(instrL1[10:0]),.RegWrite(RegWriteL4),.writedata_src(writedata_srcL4[1:0]),
		.PCplus2_write(PCplus2L4),.PCplus2(PCplus2L1[15:0]),.set_result(set_resultL4),
		.writebackData(writebackData),.writeRegSel(writeRegSelL4),
		.r1(r1),.r2(r2),.imm_signext(imm_signextL4),.PCjump(PCjump),.clk(clk),.rst(rst));

hazard_detector HD(.InstructionL1(instrL1),.writeRegSelL2(writeRegSel), .writeRegSelL3(writeRegSelL3), 
		.writeRegSelL4(writeRegSelL4), .RegWriteL2(RegWriteL2), .RegWriteL3(RegWriteL3), .jL3(jL3), .jrL3(jrL3),
		.RegWriteL4(RegWriteL4), .branchand_sel(branchand_sel),.invalidate(invalidate), .stall(stall),
		.BranchL2(BranchL2), .jL2(jL2), .jrL2(jrL2), .Branch(Branch), .j(j), .jr(jr),
		.branchand_selL4(branchand_selL4), .jL4(jL4), .jrL4(jrL4));

wire [104:0] latch_in2, latch_out2;
assign latch_in2 = {IsUnaligned_IL1, Branchsel,SETsel,writedata_src,RegDest,ALUop,halt,zeroext_sel,j,jr,BTR,
		    Branch,RegWrite,Immsel,ALUsrc1,ALUsrc2,MemtoReg,MemRead,MemWrite,PCjump,
		    PCplus2L1,r2,r1,instrL1};
latch_idex #(.OPERAND_WIDTH(105)) id_ex(.clk(clk),.rst(rst),.stall(DMemStall),.invalidate(stall | invalidate | IMemStall),
	    			  .latch_write_data(latch_in2),.latch_read_data(latch_out2));
assign instrL2=latch_out2[15:0];
assign r1L2= latch_out2[31:16];
assign r2L2= latch_out2[47:32];
assign PCplus2L2= latch_out2[63:48];
assign PCjumpL2= latch_out2[79:64];
assign MemWriteL2= latch_out2[80];
assign MemReadL2= latch_out2[81];
assign MemtoRegL2= latch_out2[82];
assign ALUsrc2L2= latch_out2[83];
assign ALUsrc1L2= latch_out2[84];
assign ImmselL2= latch_out2[85];
assign RegWriteL2= latch_out2[86];
assign BranchL2= latch_out2[87];
assign BTRL2= latch_out2[88];
assign jrL2= latch_out2[89];
assign jL2= latch_out2[90];
assign zeroext_selL2= latch_out2[91];
assign haltL2= latch_out2[92];
assign ALUopL2= latch_out2[95:93];
assign RegDestL2= latch_out2[97:96];
assign writedata_srcL2= latch_out2[99:98];
assign SETselL2= latch_out2[101:100];
assign BranchselL2= latch_out2[103:102];
assign IsUnaligned_IL2 = latch_out2[104];


forward_detection forwarding_unit(.instrL2(instrL2), .writeRegSelL3(writeRegSelL3), .writeRegSelL4(writeRegSelL4), 
											.RegWriteL3(RegWriteL3), .RegWriteL4(RegWriteL4), .forwardA(forwardA), .forwardB(forwardB));


execute execute0(.r1(r1L2),.r2(r2L2),.imm_signext(imm_signext),.instr(instrL2[10:0]),.ALUsrc1(ALUsrc1L2),
		.ALUsrc2(ALUsrc2L2),.ALUop(ALUopL2[2:0]),.BTR(BTRL2),.SETsel(SETselL2[1:0]), .Branchsel(BranchselL2[1:0]),
		.PCplus2(PCplus2L2),.PCbranch(PCbranch[15:0]), .forwardA(forwardA), .forwardB(forwardB),
		 .writebackData(writebackData),.OutL3(OutL3), .writedata_srcL3(writedata_srcL3), .writedata_srcL4(writedata_srcL4), 
		 .set_resultL3(set_resultL3), .set_resultL4(set_resultL4), .imm_signextL3(imm_signextL3), .imm_signextL4(imm_signextL4), 
		 .PCplus2L4(PCplus2L4), .PCplus2L3(PCplus2L3),
		.Out(Out),.branch_result(branch_result),.set_result(set_result),.RegDest(RegDestL2[1:0]),
		.zeroext_sel(zeroext_selL2),.Immsel(ImmselL2),.writeRegSel(writeRegSel[2:0]),.r2_out(r2_out));


wire [111:0] latch_in3, latch_out3;
assign latch_in3 = {IsUnaligned_IL2,PCplus2L2,imm_signext,PCbranch,r2_out,writedata_srcL2,writeRegSel,haltL2,jL2,jrL2,BranchL2,RegWriteL2,
		    MemtoRegL2,MemReadL2,MemWriteL2,PCjumpL2,branch_result,set_result,Out};
latch_exmem #(.OPERAND_WIDTH(112)) ex_mem(.clk(clk),.rst(rst),.invalidate(invalidate),.latch_write_data(latch_in3),
					.latch_read_data(latch_out3),.stall(DMemStall));


assign OutL3 = latch_out3[15:0];
assign set_resultL3 = latch_out3[16];
assign branch_resultL3 = latch_out3[17];
assign PCjumpL3 = latch_out3[33:18];
assign MemWriteL3 = latch_out3[34];
assign MemReadL3 = latch_out3[35];
assign MemtoRegL3 = latch_out3[36];
assign RegWriteL3 = latch_out3[37];
assign BranchL3 = latch_out3[38];
assign jrL3 = latch_out3[39];
assign jL3 = latch_out3[40];
assign haltL3 = latch_out3[41];
assign writeRegSelL3 = latch_out3[44:42];
assign writedata_srcL3 = latch_out3[46:45];
assign r2L3 = latch_out3[62:47];
assign PCbranchL3 = latch_out3[78:63];
assign imm_signextL3 = latch_out3[94:79];
assign PCplus2L3 = latch_out3[110:95];
assign IsUnaligned_IL3 = latch_out3[111];


memory memory0(.mem_out(mem_out), .Out(OutL3), .r2(r2L3), .MemRead(MemReadL3), .MemWrite(MemWriteL3), 
		.clk(clk), .rst(rst),.halt(haltL3), .Branch(BranchL3),.branch_result(branch_resultL3), .DMemStall(DMemStall), 
		.IsUnaligned_M(IsUnaligned_M),.branchand_sel(branchand_sel), .DMemStall_delayed(DMemStall_delayed), .Done(Done),
		.cachehitD(cachehitD));

wire [109:0] latch_in4, latch_out4;
assign latch_in4 = {IsUnaligned_M, IsUnaligned_IL3, branchand_sel, jL3, jrL3, PCbranchL3, PCjumpL3, PCplus2L3,imm_signextL3,writedata_srcL3,writeRegSelL3,haltL3,RegWriteL3,MemtoRegL3,set_resultL3,OutL3,mem_out};
latch_memwb #(.OPERAND_WIDTH(110)) mem_wb(.clk(clk),.rst(rst),.invalidate(1'b0),
	    			  .latch_write_data(latch_in4),.latch_read_data(latch_out4), .stall(DMemStall));

assign mem_outL4 = latch_out4[15:0];
assign OutL4 = latch_out4[31:16];
assign set_resultL4 = latch_out4[32];
assign MemtoRegL4 = latch_out4[33];
assign RegWriteL4 = latch_out4[34];
assign haltL4 = latch_out4[35];
assign writeRegSelL4 = latch_out4[38:36];
assign writedata_srcL4 = latch_out4[40:39];
assign imm_signextL4 = latch_out4[56:41];
assign PCplus2L4 = latch_out4[72:57];
assign PCjumpL4 = latch_out4[88:73];
assign PCbranchL4 = latch_out4[104:89];
assign jrL4 = latch_out4[105];
assign jL4 = latch_out4[106];
assign branchand_selL4 = latch_out4[107];
assign IsUnaligned_IL4 = latch_out4[108];
assign IsUnaligned_ML4 = latch_out4[109];


wb wb0(.mem_out(mem_outL4),.Out(OutL4),.writebackData(writebackData),.MemtoReg(MemtoRegL4));

assign alignment_err = IsUnaligned_IL4 | IsUnaligned_ML4 | err;

endmodule // proc
// DUMMY LINE FOR REV CONTROL :0:
