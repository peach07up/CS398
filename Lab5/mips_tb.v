module testThis;
	reg [5:0] opcode = 0;
	reg [5:0] funct = 0;

	initial begin
		$dumpfile("mips.vcd");
		$dumpvars(0, testThis);
		
		# 1 funct = 6'b100000;
		# 1 funct = 6'b100010;
		# 1 funct = 6'b100100;
		# 1 funct = 6'b100101;
		# 1 funct = 6'b100110;
		# 1 funct = 6'b100111;
		# 1 funct = 6'b0; opcode = 6'b001000;
		# 1 opcode = 6'b001100;
		# 1 opcode = 6'b001101;
		# 1 opcode = 6'b001110; 
		# 1 funct = 6'b100000;
		# 1 $finish;
	end

	wire except, wr_en, itype;
	wire [2:0] alu;
	mips_decode m0(alu, wr_en, itype, except, opcode, funct);

	initial begin
		//$display("add	sub	n	o	n	x	addi	andi	ori	xori	alu_op");
		//$monitor("%b	%b	%b	%b	%b	%b	%b	%b	%b	%b	%b", m0.add, m0.sub, m0.andd, m0.orr, m0.norr, m0.xorr, m0.addi, m0.andi, m0.ori, m0.xori, alu);
		$display("alu_op	itype	wr_en	except	opcode	funct");
		$monitor("%d	%d	%d	%d	%h	%h -at time %t", alu, itype, wr_en, except, opcode, funct, $time);
	end

endmodule
