module alu32_test;
  reg [31:0] A = 23196, B = 1;
  reg [2:0] control = 0;
	
	initial begin
	
		$dumpfile("alu32.vcd");
		$dumpvars(0, alu32_test);
		# 4 control = 2;//4
		# 1 A = 2**31-1; B = A;//5 o=1
		# 1 A = -2**31; B = A; //6 o=1
		# 1 control = 3;//7 0=1
		# 1 A = 36; B = 100;//8 n=1
		# 1 A = -B;//9 o=1
		# 1 control = 4;
		# 1 control = 5;
		# 1 control = 6;
		# 1 control = 7;
		# 1 $finish;
	end	 
	
  wire [31:0] out;
  wire overflow, zero, negative;
  alu32 a (out, overflow, zero, negative, A, B, control);	
  
	initial begin	
	$display("A B Con O N 0");
	$monitor("%d %d %d %d %d %d %d (At time %t", A, B, control, out, overflow, negative, zero, $time);
	end
endmodule // test
