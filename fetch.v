/*
   CS/ECE 552 Spring '20
  
   Filename        : fetch.v
   Description     : This is the module for the overall fetch stage of the processor.
*/
module fetch (instr,PCplus2,rst,clk,currPC,branch_result, j, jr,PCjump, PCjumpreg,PCbranch, PCEn, halt, IsUnaligned_I, IMemStall, cachehitI);

output [15:0] instr,PCplus2,currPC;
input [15:0] PCjump, PCjumpreg,PCbranch;
input branch_result,j,jr,PCEn;
input clk,rst;
wire err;

wire [15:0] w1,w2,PCin;
wire [15:0] pc_current;

// Have to yet take care of following
input halt;
output IsUnaligned_I;
output IMemStall, cachehitI;

// memory2c instr_mem(.data_out(instr[15:0]), .data_in(), .addr(pc_current), .enable(1'b1), 
		   // .wr(1'b0), .createdump(1'b0), .clk(clk), .rst(rst));
		   
mem_system #(0) instr_mem (.DataOut(instr[15:0]), .Done(Done), .Stall(IMemStall), .CacheHit(cachehitI),
							.err(IsUnaligned_I), .Addr(pc_current), .DataIn(16'b0), .Rd(1'b1), .Wr(1'b0), .createdump(halt), .clk(clk), .rst(rst));

PC_calc1 Pcplus2calc(.PCaddr(pc_current),.nextPC(PCplus2),.currPC(currPC),.PCEn(PCEn));

assign w1 = branch_result? PCbranch : PCplus2;
assign w2 = j? PCjump : w1;
assign PCin = jr? PCjumpreg : w2;

dff pc_dff [15:0](.q(pc_current), .d(PCin), .clk(clk), .rst(rst));

endmodule
