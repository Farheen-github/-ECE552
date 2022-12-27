/*
   CS/ECE 552 Spring '20
  
   Filename        : wb.v
   Description     : This is the module for the overall Write Back stage of the processor.
*/
module wb (mem_out,Out,writebackData,MemtoReg);


input [15:0] mem_out, Out;
input MemtoReg;
output [15:0] writebackData;



assign writebackData = MemtoReg ? mem_out: Out;

   // TODO: Your code here
   
endmodule
