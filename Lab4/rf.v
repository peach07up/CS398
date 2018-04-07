// dffe: D-type flip-flop with enable
//
// q      (output) - Current value of flip flop
// d      (input)  - Next value of flip flop
// clk    (input)  - Clock (positive edge-sensitive)
// enable (input)  - Load new value? (yes = 1, no = 0)
// reset  (input)  - Asynchronous reset   (reset =  1)
//
module dffe(q, d, clk, enable, reset);
   output q;
   reg    q;
   input  d;
   input  clk, enable, reset;

   always@(reset)
     if (reset == 1'b1)
       q <= 0;

   always@(posedge clk)
     if ((reset == 1'b0) && (enable == 1'b1))
       q <= d;
endmodule // dffe


// register: A register which may be reset to an arbirary value
//
// q      (output) - Current value of register
// d      (input)  - Next value of register
// clk    (input)  - Clock (positive edge-sensitive)
// enable (input)  - Load new value? (yes = 1, no = 0)
// reset  (input)  - Asynchronous reset    (reset = 1)
//
module register(q, d, clk, enable, reset);

   parameter
	    width = 32,
	    reset_value = 0;

   output [(width-1):0] q;
   reg [(width-1):0] 	q;
   input [(width-1):0] 	d;
   input 		clk, enable, reset;

   always@(reset)
     if (reset == 1'b1)
       q <= reset_value;

   always@(posedge clk)
     if ((reset == 1'b0) && (enable == 1'b1))
       q <= d;
endmodule // register

module decoder2 (out, in, enable);
   input     in;
   input     enable;
   output [1:0] out;

   and a0(out[0], enable, ~in);
   and a1(out[1], enable, in);
endmodule // decoder2

module decoder4 (out, in, enable);
   input [1:0]    in;
   input 	  enable;
   output [3:0]   out;
   wire [1:0] 	  w_enable;
   wire o01, o23;

   // implement using decoder2's
   decoder2 d0(w_enable, in[1], enable);
   decoder2 d1(out[1:0], in[0], w_enable[0]);
   decoder2 d2(out[3:2], in[0], w_enable[1]);
endmodule // decoder4

module decoder8 (out, in, enable);
   input [2:0]    in;
   input 	  enable;
   output [7:0]   out;
   wire [1:0] 	  w_enable;
   wire e0, e1;

   // implement using decoder2's and decoder4's
   decoder2 d2(w_enable, in[2], enable);
   decoder4 d40(out[3:0], in[1:0], w_enable[0]);
   decoder4 d41(out[7:4], in[1:0], w_enable[1]);
endmodule // decoder8

module decoder16 (out, in, enable);
   input [3:0]    in;
   input 	  enable;
   output [15:0]  out;
   wire [1:0] 	  w_enable;
   wire e0, e1;

   // implement using decoder2's and decoder8's
   decoder2 d2(w_enable, in[3], enable);
   decoder8 d80(out[7:0], in[2:0], w_enable[0]);
   decoder8 d81(out[15:8], in[2:0], w_enable[1]);
endmodule // decoder16

module decoder32 (out, in, enable);
   input [4:0]    in;
   input 	  enable;
   output [31:0]  out;
   wire [1:0] 	  w_enable;
   wire e0, e1;
   
   // implement using decoder2's and decoder16's
   decoder2 d2(w_enable, in[4], enable);
   decoder16 d160(out[15:0], in[3:0], w_enable[0]);
   decoder16 d161(out[31:16], in[3:0], w_enable[1]);
endmodule // decoder32

module mips_regfile (rd1_data, rd2_data, rd1_regnum, rd2_regnum, 
		     wr_regnum, wr_data, writeenable, 
		     clock, reset);

   output [31:0]  rd1_data, rd2_data;
   input [4:0] 	  rd1_regnum, rd2_regnum, wr_regnum;
   input [31:0]   wr_data;
   input          writeenable, clock, reset;

   // build a register file!
   wire [31:0]	wr_reg;
   wire	[31:0]	in0 = 0;
   wire	[31:0]	out0 = 0;
   decoder32 d0(wr_reg, wr_regnum, writeenable);//Write address
   register r0(out0, 0, clock, 1'b0, reset);
	wire [31:0]out1;
	wire [31:0]out2;
	wire [31:0]out3;
	wire [31:0]out4;
	wire [31:0]out5;
	wire [31:0]out6;
	wire [31:0]out7;
	wire [31:0]out8;
	wire [31:0]out9;
	wire [31:0]out10;
	wire [31:0]out11;
	wire [31:0]out12;
	wire [31:0]out13;
	wire [31:0]out14;
	wire [31:0]out15;
	wire [31:0]out16;
	wire [31:0]out17;
	wire [31:0]out18;
	wire [31:0]out19;
	wire [31:0]out20;
	wire [31:0]out21;
	wire [31:0]out22;
	wire [31:0]out23;
	wire [31:0]out24;
	wire [31:0]out25;
	wire [31:0]out26;
	wire [31:0]out27;
	wire [31:0]out28;
	wire [31:0]out29;
	wire [31:0]out30;
	wire [31:0]out31;
	register r1(out1, wr_data, clock, wr_reg[1], reset);
	register r2(out2, wr_data, clock, wr_reg[2], reset);
	register r3(out3, wr_data, clock, wr_reg[3], reset);
	register r4(out4, wr_data, clock, wr_reg[4], reset);
	register r5(out5, wr_data, clock, wr_reg[5], reset);
	register r6(out6, wr_data, clock, wr_reg[6], reset);
	register r7(out7, wr_data, clock, wr_reg[7], reset);
	register r8(out8, wr_data, clock, wr_reg[8], reset);
	register r9(out9, wr_data, clock, wr_reg[9], reset);
	register r10(out10, wr_data, clock, wr_reg[10], reset);
	register r11(out11, wr_data, clock, wr_reg[11], reset);
	register r12(out12, wr_data, clock, wr_reg[12], reset);
	register r13(out13, wr_data, clock, wr_reg[13], reset);
	register r14(out14, wr_data, clock, wr_reg[14], reset);
	register r15(out15, wr_data, clock, wr_reg[15], reset);
	register r16(out16, wr_data, clock, wr_reg[16], reset);
	register r17(out17, wr_data, clock, wr_reg[17], reset);
	register r18(out18, wr_data, clock, wr_reg[18], reset);
	register r19(out19, wr_data, clock, wr_reg[19], reset);
	register r20(out20, wr_data, clock, wr_reg[20], reset);
	register r21(out21, wr_data, clock, wr_reg[21], reset);
	register r22(out22, wr_data, clock, wr_reg[22], reset);
	register r23(out23, wr_data, clock, wr_reg[23], reset);
	register r24(out24, wr_data, clock, wr_reg[24], reset);
	register r25(out25, wr_data, clock, wr_reg[25], reset);
	register r26(out26, wr_data, clock, wr_reg[26], reset);
	register r27(out27, wr_data, clock, wr_reg[27], reset);
	register r28(out28, wr_data, clock, wr_reg[28], reset);
	register r29(out29, wr_data, clock, wr_reg[29], reset);
	register r30(out30, wr_data, clock, wr_reg[30], reset);
	register r31(out31, wr_data, clock, wr_reg[31], reset);//32 outputs.
	mux32v m0(rd1_data, out0, out1, out2, out3, out4, out5, out6, out7, out8, out9, out10, out11, out12, out13, out14, out15, out16, out17, out18, out19, out20, out21, out22, out23, out24, out25, out26, out27, out28, out29, out30, out31, rd1_regnum);
	mux32v m1(rd2_data, out0, out1, out2, out3, out4, out5, out6, out7, out8, out9, out10, out11, out12, out13, out14, out15, out16, out17, out18, out19, out20, out21, out22, out23, out24, out25, out26, out27, out28, out29, out30, out31, rd2_regnum);
endmodule // mips_regfile

