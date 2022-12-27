/*
   CS/ECE 552 Spring '20
  
   Filename        : forward_detection.v
   Description     : This is the module for dealing with all forwarding paths in a 5 stage pipeline.
*/
module forward_detection (
      instrL2, writeRegSelL3, writeRegSelL4, RegWriteL3, RegWriteL4,
      forwardA, forwardB);
			   
   input [15:0] instrL2;
   input [2:0] writeRegSelL3, writeRegSelL4;
   input RegWriteL3, RegWriteL4;
   output [1:0] forwardA, forwardB;

   wire [5:0] InsCode;
   wire [2:0] rs, rt;


   /* if (MEM/WB.RegWrite
         and (MEM/WB.RegisterRd ≠ 0)
         and not(EX/MEM.RegWrite and (EX/MEM.RegisterRd ≠ 0)
          and (EX/MEM.RegisterRd ≠ ID/EX.RegisterRs))
         and (MEM/WB.RegisterRd = ID/EX.RegisterRs)) ForwardA = 01

         if (MEM/WB.RegWrite
         and (MEM/WB.RegisterRd ≠ 0)
         and not(EX/MEM.RegWrite and (EX/MEM.RegisterRd ≠ 0)
          and (EX/MEM.RegisterRd ≠ ID/EX.RegisterRt))
         and (MEM/WB.RegisterRd = ID/EX.RegisterRt)) ForwardB = 01
*/
   assign InsCode = instrL2[15:11];
   assign rs =  instrL2[10:8];
   assign rt =  instrL2[7:5];

   
   assign forwardA = (RegWriteL3 & (writeRegSelL3 == rs)) ? 2'b10 : ((RegWriteL4 == 1'b1) & (writeRegSelL4 == rs)) ? 2'b01 : 2'b00;

   assign forwardB = (RegWriteL3 & (writeRegSelL3 == rt)) ? 2'b10 : ((RegWriteL4 == 1'b1) & (writeRegSelL4 == rt)) ? 2'b01 : 2'b00;



endmodule
