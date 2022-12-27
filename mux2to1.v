

module mux2to1(out, in1, in0, sel);

    output out;
    input in0,in1,sel;

		// Signals for clkrst module
    wire clk;
    wire rst;
    wire err;
    assign err = 1'b0;

	clkrst c0(.clk(clk),
              .rst(rst),
              .err(err));
    assign  out = sel ? in1 : in0;
endmodule