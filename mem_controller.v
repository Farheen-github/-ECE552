`define IDLE 0
`define CMP_Read 1
`define CMP_Write 2

`define ALLC0 7
`define ALLC1 8
`define ALLC2 9
`define ALLC3 10
`define ALLC4 11
`define ALLC5 12
`define WB_0 3
`define WB_1 4
`define WB_2 5
`define WB_3 6
`define DONE 13

`default_nettype none
module mem_controller(Rd, Wr, address, hit1, hit2, dirty1, dirty2, valid1, valid2, 
                clk, rst,
				cache_data_out1, cache_data_out2, tag_out1, tag_out2, data_in_mem, proc_data_in,
                //Outputs
                Done, mem_addr, mem_data, mem_wr, mem_rd, proc_data_out, proc_stall, CacheHit, Error,
				enable1, enable2, comp, write, tag_in, cache_data_in, valid_in, offset_in);
    
    input wire clk, rst, Rd, Wr, hit1, hit2, dirty1, dirty2, valid1, valid2;
    input wire [15:0] address, cache_data_out1, cache_data_out2, data_in_mem, proc_data_in;
    input wire [4:0] tag_out1, tag_out2;

    output reg enable1, enable2, comp, write, valid_in, Done, mem_wr, mem_rd, Error;
    output reg [4:0] tag_in;
    output reg [2:0] offset_in;
    output reg [15:0] proc_data_out;
	output reg [15:0] mem_addr, mem_data, cache_data_in;
	
    output reg proc_stall;
    output reg CacheHit;

    wire [3:0] state;
    reg [3:0] next_state;
    reg rd_reg, wr_reg, dirty_reg, CacheHit1, CacheHit2, enable1_reg, enable2_reg, flip, hit_reg;
	reg [15:0] address_reg, proc_data_in_reg, data_out_reg;
    reg [4:0] tag_in_reg;

    wire [4:0] tag;
    wire evictway, victimway;
	wire [7:0] index;
    wire [2:0] offset;

    assign tag = address_reg[15:11];
    assign offset = address_reg[2:0];
	assign index = address_reg[10:3];

    Reg #(.REG_SIZE(1)) victimway_reg (.readData(victimway), .writeData(~victimway), .clk(clk), .rst(rst), .writeEn(flip));
	Reg #(.REG_SIZE(4)) state_reg (.readData(state), .writeData(next_state), .clk(clk), .rst(rst), .writeEn(1'b1));

    assign evictway = valid1 ? (valid2 ? ~victimway : 1'b1) : 1'b0;

    always @(*) begin
        valid_in = 1'b0;
        mem_wr = 1'b0; 
        mem_rd = 1'b0;
        Error = 1'b0;
        Done = 1'b0;
        flip = 1'b0;
		
        enable1 = 1'b0;
        enable2 = 1'b0;
        comp = 1'b0;
        write = 1'b0;
        proc_stall = ~Done;
        CacheHit = 1'b0;
        CacheHit1 = 1'b0;
        CacheHit2 = 1'b0;
        offset_in = (Rd | Wr) ? offset : 3'b000;
        address_reg = address;

        casex(state)
            `IDLE: begin
                rd_reg = Rd;
                wr_reg = Wr;
                proc_stall = (Rd|Wr);
                hit_reg = 1'b0;
                next_state = Rd ? `CMP_Read : (Wr ? `CMP_Write : `IDLE);
            end
            `CMP_Read: begin
                comp = 1'b1;
                write = 1'b0;
                enable1 = 1'b1;
                enable2 = 1'b1;
                tag_in = tag;
                offset_in = offset;
                
                flip = 1'b1;
				valid_in = 1'b1;
                cache_data_in = 1'b0;
				
                proc_data_in_reg = proc_data_in;
                address_reg = address;
                dirty_reg = evictway ? dirty2 : dirty1;
                tag_in_reg = evictway ? tag_out2 : tag_out1;
				
                enable1_reg = evictway ? 1'b0 : 1'b1;
                enable2_reg = evictway ? 1'b1 : 1'b0;

                CacheHit1 = hit1 & valid1;
                CacheHit2 = hit2 & valid2;
                CacheHit = CacheHit1 | CacheHit2;
                hit_reg = CacheHit;
				
                data_out_reg = CacheHit1 ? cache_data_out1 : (CacheHit2 ? cache_data_out2 : data_out_reg);
                
                proc_data_out = CacheHit1 ? cache_data_out1 : (CacheHit2 ? cache_data_out2 : 16'bxxxx_xxxx_xxxx_xxxx);
                Done = (CacheHit) ? 1'b1 : 1'b0;
				
                proc_stall = ~CacheHit;
                next_state = (CacheHit) ? `IDLE : (((~evictway & ~CacheHit & dirty1) | (evictway & ~CacheHit & dirty2)) ? `WB_0 : 
                                    (((~evictway & (~dirty1 | ~CacheHit)) | (evictway & (~dirty2 | ~CacheHit))) ? `ALLC0 : `CMP_Read));
            end
            `CMP_Write: begin
			
                enable1 = 1'b1;
                enable2 = 1'b1;
                comp = 1'b1;
                write = 1'b1;
				
                tag_in = tag;
                offset_in = offset;
                valid_in = 1'b1;
                cache_data_in = proc_data_in;
                flip = 1'b1;

                proc_data_in_reg = proc_data_in;
                address_reg = address;
                dirty_reg = evictway ? dirty2 : dirty1;
				
				
                enable1_reg = evictway ? 1'b0 : 1'b1;
                enable2_reg = evictway ? 1'b1 : 1'b0;
                
                tag_in_reg = evictway ? tag_out2 : tag_out1;

                CacheHit1 = hit1 & valid1;
                CacheHit2 = hit2 & valid2;
                CacheHit = CacheHit1 | CacheHit2;
                hit_reg = CacheHit;
                data_out_reg = CacheHit1 ? cache_data_out1 : (CacheHit2 ? cache_data_out2 : data_out_reg);
                
                proc_data_out = CacheHit1 ? cache_data_out1 : (CacheHit2 ? cache_data_out2 : 16'bxxxx_xxxx_xxxx_xxxx);
                Done = (CacheHit) ? 1'b1 : 1'b0;
				
                proc_stall = ~CacheHit;
                next_state = (CacheHit) ? `IDLE : (((~evictway & ~CacheHit & dirty1) | (evictway & ~CacheHit & dirty2)) ? `WB_0 : 
                                    (((~evictway & (~dirty1 | ~CacheHit)) | (evictway & (~dirty2 | ~CacheHit))) ? `ALLC0 : `CMP_Write));
            end
            `WB_0: begin
                
                mem_rd = 1'b0;
                mem_wr = 1'b1;
				mem_addr = {tag_in_reg, index, 3'b000};
				
                mem_data = enable1_reg ? cache_data_out1 : cache_data_out2;
                
                hit_reg = 1'b0;
				proc_stall = 1'b1;
				
                write = 1'b0;
                comp = 1'b1;
				
				
                enable1 = enable1_reg;
                enable2 = enable2_reg;
				
                tag_in = tag_in_reg;
                offset_in = 3'b000;
                valid_in = 1'b1;
                next_state = `WB_1;
            end
            `WB_1: begin
                
                mem_rd = 1'b0;
				mem_wr = 1'b1;
                mem_addr = {tag_in_reg, index, 3'b010};
                mem_data = enable1_reg ? cache_data_out1 : cache_data_out2;
                proc_stall = 1'b1;

                
				comp = 1'b1;
                write = 1'b0;
                
                tag_in = tag_in_reg;
                offset_in = 3'b010;
                valid_in = 1'b1;
				
				enable1 = enable1_reg;
                enable2 = enable2_reg;
				
                next_state = `WB_2;
            end
            `WB_2: begin
                
                mem_rd = 1'b0;
				mem_wr = 1'b1;
				
                mem_addr = {tag_in_reg, index, 3'b100};
                mem_data = enable1_reg ? cache_data_out1 : cache_data_out2;
                proc_stall = 1'b1;

                enable1 = enable1_reg;
                enable2 = enable2_reg;
                
                tag_in = tag_in_reg;
                offset_in = 3'b100;
                valid_in = 1'b1;
				write = 1'b0;
                comp = 1'b1;
                next_state = `WB_3;
            end
            `WB_3: begin
                
                mem_rd = 1'b0;
				mem_wr = 1'b1;
                mem_addr = {tag_in_reg, index, 3'b110};
                mem_data = enable1_reg ? cache_data_out1 : cache_data_out2;
                proc_stall = 1'b1;

                comp = 1'b1;
                write = 1'b0;
                
                tag_in = tag_in_reg;
                offset_in = 3'b110;
                valid_in = 1'b1;
				enable1 = enable1_reg;
                enable2 = enable2_reg;
                next_state = `ALLC0;
            end
            `ALLC0: begin
                mem_rd = rd_reg | (wr_reg & (offset != 3'b000));
				mem_wr = wr_reg & (offset == 3'b000);
                
                mem_addr = {address_reg[15:3], 3'b000}; 
                mem_data = proc_data_in_reg;
                proc_stall = 1'b1;
                hit_reg = 1'b0;

                
                write = 1'b0;
                comp = 1'b0;
				
				enable1 = 1'b0;
                enable2 = 1'b0;
				
                next_state = `ALLC1;
            end
            `ALLC1: begin
                mem_rd = rd_reg | (wr_reg & (offset != 3'b010));
				mem_wr = wr_reg & (offset == 3'b010);
                
                mem_addr = {address_reg[15:3], 3'b010};
                mem_data = proc_data_in_reg;
                proc_stall = 1'b1;

                enable1 = 1'b0;
                enable2 = 1'b0;
                write = 1'b0;
                comp = 1'b0;
                next_state = `ALLC2;
            end
            `ALLC2: begin
                mem_rd = rd_reg | (wr_reg & (offset != 3'b100));
				mem_wr = wr_reg & (offset == 3'b100);
                
                mem_addr = {address_reg[15:3], 3'b100};
                mem_data = proc_data_in_reg;

				write = 1'b1;
                comp = 1'b0;
                
                tag_in = tag;
                cache_data_in = rd_reg | (wr_reg & offset != 3'b000) ? data_in_mem : proc_data_in;
                valid_in = 1'b1;
                
                
				offset_in = 3'b000;

				enable1 = enable1_reg;
                enable2 = enable2_reg;
				
                proc_stall = 1'b1;
                
                data_out_reg = (offset == 3'b000) ? data_in_mem : data_out_reg;
                
                next_state = `ALLC3;
            end
            `ALLC3: begin
                mem_rd = rd_reg | (wr_reg & (offset != 3'b110));
				mem_wr = wr_reg & (offset == 3'b110);
                
                mem_addr = {address_reg[15:3], 3'b110};
                mem_data = proc_data_in_reg;

                write = 1'b1;
				comp = 1'b0;
                
                tag_in = tag;
                cache_data_in = rd_reg | (wr_reg & offset != 3'b010) ? data_in_mem : proc_data_in;
                valid_in = 1'b1;
                
                offset_in = 3'b010;


				enable1 = enable1_reg;
                enable2 = enable2_reg;
				
                proc_stall = 1'b1;
                
                data_out_reg = (offset == 3'b010) ? data_in_mem : data_out_reg;
                
                next_state = `ALLC4;
            end
            `ALLC4: begin
                mem_rd = 1'b0;
				mem_wr = 1'b0;
                

                
				write = 1'b1;
                comp = 1'b0;
				tag_in = tag;
                cache_data_in = rd_reg | (wr_reg & offset != 3'b100) ? data_in_mem : proc_data_in;
                valid_in = 1'b1;
                
                offset_in = 3'b100;

                proc_stall = 1'b1;
                
                data_out_reg = (offset == 3'b100) ? data_in_mem : data_out_reg;
                
				enable1 = enable1_reg;
                enable2 = enable2_reg;
                next_state = `ALLC5;
            end
            `ALLC5: begin
                mem_rd = 1'b0;
				mem_wr = 1'b0;
                

                comp = 1'b0;
                write = 1'b1;
                tag_in = tag;
                cache_data_in = rd_reg | (wr_reg & offset != 3'b110) ? data_in_mem : proc_data_in;
                valid_in = 1'b1;
                
                offset_in = 3'b110;

                data_out_reg = (offset == 3'b110) ? data_in_mem : data_out_reg;
                
				enable1 = enable1_reg;
                enable2 = enable2_reg;
                next_state = `DONE;
            end
            `DONE: begin
                proc_data_out = data_out_reg;
                CacheHit = hit_reg;
                Done = 1'b1;
                rd_reg = Rd;
                wr_reg = Wr;
                proc_stall = 1'b0;
				next_state = `IDLE;
				
                
            end
            default: begin
                next_state = `IDLE;
            end
        endcase
    end


endmodule
`default_nettype wire