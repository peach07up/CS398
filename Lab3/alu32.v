module full_adder(sum, cout, a, b, cin);
   output sum, cout;
   input  a, b, cin;
   wire   partial_s, partial_c1, partial_c2;

   xor x0(partial_s, a, b);
   xor x1(sum, partial_s, cin);
   and a0(partial_c1, a, b);
   and a0(partial_c2, partial_s, cin);
   or  o1(cout, partial_c1, partial_c2);
endmodule // full_adder

// output = A (when control == 0) or B (when control == 1)
module mux2(out, A, B, control);
   output      out;
   input       A, B;
   input       control;
   wire        wA, wB, not_control;
        
   not n1(not_control, control);
   and a1(wA, A, not_control);
   and a2(wB, B, control);
   or  o1(out, wA, wB);
endmodule // mux2

// output = A (when control == 00) or B (when control == 01) or
//          C (when control == 10) or D (when control == 11)
module mux4(out, A, B, C, D, control);
   output      out;
   input       A, B, C, D;
   input		[1:0] control;
   wire 		[1:0] bit;
   
   mux2 m1(bit[0], A, B, control[0]);
   mux2 m2(bit[1], C, D, control[0]);
   mux2 m3(out, bit[0], bit[1], control[1]);
endmodule // mux4


// 00 - AND, 01 - OR, 10 - NOR, 11 - XOR
module logicunit(out, A, B, control);
	output      out;
	input       A, B;
	input [1:0] control;
	wire And, Or, Nor, Xor;
	and a(And, A, B);
	or o(Or, A, B);
	nor no(Nor, A, B);
	xor xo(Xor, A, B);
	mux4 m4(out, And, Or, Nor, Xor, control);
endmodule // logicunit

`define ALU_ADD    3'h2
`define ALU_SUB    3'h3
`define ALU_AND    3'h4
`define ALU_OR     3'h5
`define ALU_NOR    3'h6
`define ALU_XOR    3'h7

// 01x - arithmetic, 1xx - logic
module alu1(out, carryout, A, B, carryin, control);
	output      out, carryout;
	input       A, B, carryin;
	input [2:0] control;
	wire arith, luResult, nB;
	xor xo(nB, B, control[0]);
	full_adder f_a1(arith, carryout, A, nB, carryin);
	logicunit lu(luResult, A, B, control[1:0]);
	mux2 m2(out, arith, luResult, control[2]);
// add code here!!!
   
endmodule // alu1

// uncomment after you've tested your alu1 !!
module alu32(out, overflow, zero, negative, A, B, control);
    output[31:0] out;
    output       overflow, zero, negative;
    input [31:0] A, B;
    input  [2:0] control;
	wire [31:1] cin, result;
	wire cout;

//Arithmetic
    alu1 a0(out[0], cin[1], A[0], B[0], control[0], control);
    alu1 a1(out[1], cin[2], A[1], B[1], cin[1], control);
    alu1 a2(out[2], cin[3], A[2], B[2], cin[2], control);
    alu1 a3(out[3], cin[4], A[3], B[3], cin[3], control);
    alu1 a4(out[4], cin[5], A[4], B[4], cin[4], control);
    alu1 a5(out[5], cin[6], A[5], B[5], cin[5], control);
    alu1 a6(out[6], cin[7], A[6], B[6], cin[6], control);
    alu1 a7(out[7], cin[8], A[7], B[7], cin[7], control);
    alu1 a8(out[8], cin[9], A[8], B[8], cin[8], control);
    alu1 a9(out[9], cin[10], A[9], B[9], cin[9], control);
    alu1 a10(out[10], cin[11], A[10], B[10], cin[10], control);
    alu1 a11(out[11], cin[12], A[11], B[11], cin[11], control);
    alu1 a12(out[12], cin[13], A[12], B[12], cin[12], control);
    alu1 a13(out[13], cin[14], A[13], B[13], cin[13], control);
    alu1 a14(out[14], cin[15], A[14], B[14], cin[14], control);
    alu1 a15(out[15], cin[16], A[15], B[15], cin[15], control);
    alu1 a16(out[16], cin[17], A[16], B[16], cin[16], control);
    alu1 a17(out[17], cin[18], A[17], B[17], cin[17], control);
    alu1 a18(out[18], cin[19], A[18], B[18], cin[18], control);
    alu1 a19(out[19], cin[20], A[19], B[19], cin[19], control);
    alu1 a20(out[20], cin[21], A[20], B[20], cin[20], control);
    alu1 a21(out[21], cin[22], A[21], B[21], cin[21], control);
    alu1 a22(out[22], cin[23], A[22], B[22], cin[22], control);
    alu1 a23(out[23], cin[24], A[23], B[23], cin[23], control);
    alu1 a24(out[24], cin[25], A[24], B[24], cin[24], control);
    alu1 a25(out[25], cin[26], A[25], B[25], cin[25], control);
    alu1 a26(out[26], cin[27], A[26], B[26], cin[26], control);
    alu1 a27(out[27], cin[28], A[27], B[27], cin[27], control);
    alu1 a28(out[28], cin[29], A[28], B[28], cin[28], control);
    alu1 a29(out[29], cin[30], A[29], B[29], cin[29], control);
    alu1 a30(out[30], cin[31], A[30], B[30], cin[30], control);
    alu1 a31(out[31], cout, A[31], B[31], cin[31], control);


//Zero flag	
	or o1(result[1], out[1], out[0]);
    or o2(result[2], out[2], result[1]);
    or o3(result[3], out[3], result[2]);
    or o4(result[4], out[4], result[3]);
    or o5(result[5], out[5], result[4]);
    or o6(result[6], out[6], result[5]);
    or o7(result[7], out[7], result[6]);
    or o8(result[8], out[8], result[7]);
    or o9(result[9], out[9], result[8]);
    or o10(result[10], out[10], result[9]);
    or o11(result[11], out[11], result[10]);
    or o12(result[12], out[12], result[11]);
    or o13(result[13], out[13], result[12]);
    or o14(result[14], out[14], result[13]);
    or o15(result[15], out[15], result[14]);
    or o16(result[16], out[16], result[15]);
    or o17(result[17], out[17], result[16]);
    or o18(result[18], out[18], result[17]);
    or o19(result[19], out[19], result[18]);
    or o20(result[20], out[20], result[19]);
    or o21(result[21], out[21], result[20]);
    or o22(result[22], out[22], result[21]);
    or o23(result[23], out[23], result[22]);
    or o24(result[24], out[24], result[23]);
    or o25(result[25], out[25], result[24]);
    or o26(result[26], out[26], result[25]);
    or o27(result[27], out[27], result[26]);
    or o28(result[28], out[28], result[27]);
    or o29(result[29], out[29], result[28]);
    or o30(result[30], out[30], result[29]);
    or o31(result[31], out[31], result[30]);
    not n0(zero, result[31]);

//Overflow flag
	xor of(overflow, cout, cin[31]);

//Negative flag
	assign negative = out[31];

endmodule // alu32
   
