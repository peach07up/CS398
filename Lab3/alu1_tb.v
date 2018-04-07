module testThis;
	reg A = 0;
	always #1 A = !A;
	reg B = 0;
 	always #2 B = !B;
   
	reg [2:0] control = 0;

	initial begin
		$dumpfile("alu1.vcd");
		$dumpvars(0, testThis);

		# 32 control = 1;
		# 32 control = 2;
		# 32 control = 3;
		# 32 control = 4;
		# 32 $finish;
	end

	wire out;
	alu1 a1(out, A, B, control);

	initial begin
		$display("A B c[2] c[1] c[2]");
		$monitor("%d %d %d %d %d (at time %t)", A, B, c[2], c[1], c[0], out, $time);
	end

endmodule
