
module latch_memwb(clk,rst,invalidate,latch_write_data,latch_read_data,stall);

 parameter OPERAND_WIDTH =32;
 input    clk,rst,invalidate,stall;
 input  [OPERAND_WIDTH -1:0] latch_write_data;
 output [OPERAND_WIDTH -1:0] latch_read_data;

 wire [OPERAND_WIDTH -1:0] latch_data, check_var;

 wire clearbuffer;
 assign clearbuffer =  rst ;

 assign check_var = stall ? latch_read_data : latch_write_data; 
 assign latch_data = (invalidate==1'b1) ? {OPERAND_WIDTH{1'b0}} : check_var;
 
 //assign latch_data = stall ? latch_read_data : (invalidate ? {OPERAND_WIDTH{1'b0}} :latch_write_data);
 
 dff latch_dff[OPERAND_WIDTH -1 :0](.q(latch_read_data), .d(latch_data), .clk(clk), .rst(clearbuffer));
 


endmodule
