module testThis;
	reg [2:0] in = 0;

	initial begin
		$dumpfile("dec.vcd");
		$dumpvars(0, testThis);

		# 8 in = 1;
		# 8 in = 2;
		# 8 in = 3;
		# 8 in = 4;
		# 8 in = 5;
		# 8 in = 6;
		# 8 in = 7;
		# 8 $finish;
	end

	wire out;
	decoder4 dec4(out, in[1:0], in[2]);

	initial begin
		$display("in, out");
		$monitor("%d %d (at time %t)", in, out, $time);
	end

endmodule
