
module latch_ifid(clk,rst,invalidate,stall,latch_write_data,latch_read_data);

 parameter OPERAND_WIDTH = 32;
 input    clk,rst,stall,invalidate;
 input  [OPERAND_WIDTH -1:0] latch_write_data;
 output [OPERAND_WIDTH -1:0] latch_read_data;

 wire [OPERAND_WIDTH -1:0] latch_data, check_var;

 wire clearbuffer;
 assign clearbuffer =  rst ;

 assign check_var = stall ? latch_read_data : latch_write_data; 
 assign latch_data = (invalidate==1'b1) ? 49'h0_0000_0000_0800 : check_var;

 dff latch_dff[OPERAND_WIDTH -1 :0](.q(latch_read_data), .d(latch_data), .clk(clk), .rst(clearbuffer));
 


endmodule
