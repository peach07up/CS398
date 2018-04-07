module test;

	reg a=0, b=0, cin=0;
	
	initial begin		
		$dumpfile("sc2.vcd");
		$dumpvars(0, test);
		
		#10	cin=1;			//001
		#10 b=1; cin=0;		//010
		#10 cin=1;			//011
		#10 a=1; b=0; cin=0;//100
		#10 cin=1;			//101
		#10 b=1; cin=0;		//110
		#10 cin=1;			//111
		$finish;
	end
	
	wire s, cout;
	sc2_block sc1(s, cout, a, b, cin);
	
	initial
		$monitor("At time %t, a = %d b = %d, cin = %d s = %d cout = %d", $time, a, b, cin, s, cout);
			
endmodule // test
