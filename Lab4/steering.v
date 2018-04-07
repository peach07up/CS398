module steering(left, right, walk, sensors);
	output 	left, right, walk;
	input [4:0] 	sensors;
    wire w1, w2;
    wire l1, l2, l3, l4, L;
    wire s01, o01;
    
    and a00(w1, sensors[1], sensors[2]);
    and a01(w2, sensors[3], w1);
    not n0(walk, w2);//walk statement;
    
    and a10(s01, sensors[0], sensors[1]);//S1S0
	assign na10 = ~s01;
    or o10(o01, sensors[0], sensors[1]);
	assign l1 = ((~o01&~sensors[4]) | (na10&sensors[4])) & (~sensors[3]);
	assign l2 = sensors[3]&(sensors[4] | ~(sensors[4] | sensors[1]));
	assign left = sensors[2]&(l1 | l2);//left statement
	
	assign right = sensors[2] & (~(l1 | l2));
endmodule // steering
