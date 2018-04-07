module testThis;
	reg [2:0] in = 0;
	always #1 in = in+1;

	initial begin
		$dumpfile("dec.vcd");
		$dumpvars(0, testThis);

		# 8 $finish;
	end

	wire [3:0]out;
	decoder4 dec4(out, in[1:0], in[2]);

	initial begin
		$display("in out");
		$monitor("%d %d (at time %t)", in, out, $time);
	end

endmodule
