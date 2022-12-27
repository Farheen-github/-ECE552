/*
   CS/ECE 552 Spring '20
  
   Filename        : hazard_detector.v
   Description     : This is the module for detecting RAW hazards in a 5 stage pipeline without forwarding.
*/
module hazard_detector (
      InstructionL1,writeRegSelL2, writeRegSelL3, writeRegSelL4, RegWriteL2, RegWriteL3, RegWriteL4,
      invalidate, stall, jL3, jrL3, branchand_sel,BranchL2, jL2, jrL2, Branch, j, jr,
	jL4, jrL4, branchand_selL4);
			   
   input [15:0] InstructionL1;
   input [2:0] writeRegSelL2, writeRegSelL3, writeRegSelL4;
   input jL4, jrL4, branchand_selL4,RegWriteL2, RegWriteL3, RegWriteL4,jL3, jrL3, branchand_sel,BranchL2, jL2, jrL2, Branch, j, jr;
   output invalidate, stall;

   wire [5:0] InsCode;
   wire [2:0] rs, rt, rd;
   wire stall1;

   assign InsCode = InstructionL1[15:11];
   assign rs = InstructionL1[10:8];
   assign rt = InstructionL1[7:5];
   
   assign stall1 =  (RegWriteL3 & ((rs == writeRegSelL3) | (rt == writeRegSelL3))) |
			(RegWriteL4 & ((rs === writeRegSelL4) | (rt === writeRegSelL4))) |
			(RegWriteL2 & ((rs === writeRegSelL2) | (rt === writeRegSelL2)));


//We invalidate on branch/jump
   wire invalidate1, invalidate2, invalidate3, invalidate4;
   assign invalidate1 = (branchand_sel | branchand_selL4 )? 1'b1:1'b0;
   assign invalidate2 = ( jrL3 | jrL4) ? 1'b1:1'b0;
   assign invalidate3 = ( jL3 | jL4) ? 1'b1:1'b0;
   assign invalidate4 = invalidate1 | invalidate2 | invalidate3;


   assign stall = invalidate4 ? 1'b0 : stall1;
   assign invalidate = invalidate4;


endmodule
