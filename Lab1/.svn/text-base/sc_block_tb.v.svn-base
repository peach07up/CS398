module sc_test;

   reg a = 0, b = 0;        // these are inputs to "circuit under test"
                            // use "reg" not "wire" so can assign a value
                            // we've given them initial values
   
   initial begin            // initial = run at beginning of simulation
                            // begin/end = associate block with initial

      $dumpfile("sc.vcd");  // name of dump file to create
      $dumpvars(0,sc_test); // record all signals of module "sc_test" 
                            // starting at time 0
      
      # 10                  // wait 10 time units
      a = 1;                // change a's value
      # 10 a = 0; b = 1;
      # 10 a = 1;
      # 10 
      $finish;              // end the simulation
   end                      
   
   wire s, c;               // wires for the outputs of "circuit under test"
   sc_block sc1 (s, c, a, b);	// the circuit under test

   
   initial
     $monitor("At time %t, a = %d b = %d s = %d c = %d",
              $time, a, b, s, c);
endmodule // test
