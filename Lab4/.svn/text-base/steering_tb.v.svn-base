module steering_test;

   reg [4:0] sensors = 5'b0;
   
   initial begin
      $dumpfile("steering.vcd");  
      $dumpvars(0, steering_test);
      
      # 10  
	sensors[4:0] = 5'b00000;              // all clear
      # 10  
	sensors[4:0] = 5'b10000;              // left most blocked
      # 10  
	sensors[4:0] = 5'b11000;              // two left most blocked
      # 10  
	sensors[4:0] = 5'b11100;              // three left most blocked
      # 10  
	sensors[4:0] = 5'b11110;              // four left most blocked
      # 10  
	sensors[4:0] = 5'b11111;              // all blocked
      # 10  
	sensors[4:0] = 5'b01110;              // middle blocked
      # 10  
	sensors[4:0] = 5'b01100;              // easier to go right
      # 10  
	sensors[4:0] = 5'b00100;              // only the middle blocked
      # 10
	sensors[4:0] = 5'b10110;              // wrl = 110
      # 10
	// ADD MORE TEST CASES!!!! 
	
      $finish;              // end the simulation
   end                      
   
   wire       left, right, walk;
   steering steer (left, right, walk, sensors);	

   initial
     $monitor("At time %t, sensors = %b left = %d right = %x walk = %x",
              $time, sensors, left, right, walk);
endmodule // steering_test
