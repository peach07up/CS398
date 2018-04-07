/*module test;

  // cycle through all combinations of A, B, C, D every 16 time units
  reg A = 0;
  always #1 A = !A;
  reg B = 0;
  always #2 B = !B;
  reg C = 0;
  always #4 C = !C;
  reg D = 0;
  always #8 D = !D;
   
  reg [1:0] control = 0;
   
  initial begin
     $dumpfile("test.vcd");
     $dumpvars(0, test);

     # 16 control = 1;
     # 16 control = 2;
     # 16 control = 3;
     # 16 $finish;
  end

  wire out;
  logicunit lu(out, A, B, control);

  initial begin
    $display("A B s o");
    $monitor("%d %d %d %d (at time %t)", A, B, control, out, $time);
  end
endmodule // test*/
module testThis;
	reg A = 0;
	always #1 A = !A;
	reg B = 0;
 	always #2 B = !B;
 	reg Cin = 0;
 	always #4 Cin = !Cin;
   
	reg [2:0] control = 0;

	initial begin
		$dumpfile("alu1.vcd");
		$dumpvars(0, testThis);

		# 8 control = 1;
		# 8 control = 2;
		# 8 control = 3;
		# 8 control = 4;
		# 8 control = 5;
		# 8 control = 6;
		# 8 control = 7;
		# 8 $finish;
	end

	wire out, co;
	alu1 a1(out, co,  A, B, Cin, control);

	initial begin
		$display("A B Cin c[2] c[1] c[0] ");
		$monitor("%d %d %d %d %d %d %d %d(at time %t)", A, B, Cin, control[2], control[1], control[0], out, co, $time);
	end

endmodule
