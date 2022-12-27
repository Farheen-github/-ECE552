

module latch_idex(clk,rst,stall,invalidate,latch_write_data,latch_read_data);

 parameter OPERAND_WIDTH =32;
 input    clk,rst,stall, invalidate;
 input  [OPERAND_WIDTH -1:0] latch_write_data;
 output [OPERAND_WIDTH -1:0] latch_read_data;

 wire [OPERAND_WIDTH -1:0] latch_data, check_var;

 wire clearbuffer;
 assign clearbuffer =  rst ;

 assign check_var = stall ? latch_read_data : latch_write_data; 
 assign latch_data = (invalidate==1'b1) ? 105'h0_0000_0000_0800 : check_var;

 //assign latch_data = stall ? latch_read_data : (invalidate ? 105'h000_0000_0000_0000_0000_0000_0800 :latch_write_data);
 //assign latch_data = (stall|invalidate) ? 104'h00_0000_0000_0000_0000_0000_0800 : latch_write_data; 
 
 dff latch_dff[OPERAND_WIDTH -1 :0](.q(latch_read_data), .d(latch_data), .clk(clk), .rst(clearbuffer));
 

endmodule