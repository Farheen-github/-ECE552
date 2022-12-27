/*
   CS/ECE 552 Spring '20
  
   Filename        : memory.v
   Description     : This module contains all components in the Memory stage of the 
                     processor.
*/
module memory (mem_out, Out, r2, MemRead, MemWrite, clk, rst,halt,Branch,branch_result,branchand_sel, DMemStall, IsUnaligned_M, DMemStall_delayed, Done, cachehitD);

input [15:0] Out,r2;
input MemRead, MemWrite;
output [15:0] mem_out;
output branchand_sel;
input clk,rst,halt,Branch,branch_result;
wire err, MemReadAligned, MemWriteAligned;
output DMemStall_delayed, Done, cachehitD;

// Have to yet take care of following

output DMemStall;
output IsUnaligned_M;

wire wr_en = (MemRead==1)?1'b0:((MemWrite==1)?1'b1:1'bx);
// assign err = 1'b0;
assign branchand_sel = Branch & branch_result;

assign MemReadAligned = MemRead & ~Out[0];
assign MemWriteAligned = MemWrite & ~Out[0];

// memory2c data_mem(.data_out(mem_out), .data_in(r2), .addr(Out), .enable(1'b1), 
		   // .wr(wr_en), .createdump(halt), .clk(clk), .rst(rst));

mem_system #(1) data_mem_mod (.DataOut(mem_out), .Done(Done), .Stall(DMemStall), .CacheHit(cachehitD), .err(err), .Addr(Out), .DataIn(r2), .Rd(MemReadAligned), .Wr(MemWriteAligned), .createdump(halt), .clk(clk), .rst(rst));

dff idelay1(.q(DMemStall_delayed), .d(DMemStall), .clk(clk), .rst(rst));
assign IsUnaligned_M = err | ((MemRead | MemWrite) & Out[0]);
   
endmodule
