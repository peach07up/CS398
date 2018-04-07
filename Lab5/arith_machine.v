// mips_decode: a decoder for MIPS arithmetic instructions
//
// alu_op      (output) - control signal to be sent to the ALU
// writeenable (output) - should a new value be captured by the register file
// itype       (output) - should the ALU receive 1 reg. value and 1 immediate (1) or 2 reg values (0)
// except      (output) - set to 1 when 
// opcode       (input) - the opcode field from the instruction
// funct        (input) - the function field from the instruction
//

module mips_decode(alu_op, writeenable, itype, except, opcode, funct);
   output [2:0] alu_op;
   output 	writeenable, itype, except;
   input  [5:0] opcode, funct;
   wire [5:0] read;
   wire xor10;
   wire 	add, sub, andd, orr, norr, xorr, addi, andi, ori, xori;
   
   assign add = (opcode == `OP_OTHER0) & (funct == `OP0_ADD);
   //assign add = (funct == `OP0_ADD);
   assign sub = (opcode == `OP_OTHER0) & (funct == `OP0_SUB);
   //assign sub = (funct == `OP0_SUB);
   assign andd = (opcode == `OP_OTHER0) & (funct == `OP0_AND);
   //assign andd = (funct == `OP0_AND);
   assign orr = (opcode == `OP_OTHER0) & (funct == `OP0_OR);
   //assign orr = (funct == `OP0_OR);
   assign norr = (opcode == `OP_OTHER0) & (funct == `OP0_NOR);
   //assign norr = (funct == `OP0_NOR);
   assign xorr = (opcode == `OP_OTHER0) & (funct == `OP0_XOR);
   //assign xorr = (funct == `OP0_XOR);
   //assign addi = (opcode == `OP_ADDI) & (funct == `OP_OTHER0);
   assign addi = (opcode == `OP_ADDI) ;
   //assign andi = (opcode == `OP_ANDI) & (funct == `OP_OTHER0);
   assign andi = (opcode == `OP_ANDI);
   //assign ori = (opcode == `OP_ORI) & (funct == `OP_OTHER0);
   assign ori = (opcode == `OP_ORI);
   //assign xori = (opcode == `OP_XORI) & (funct == `OP_OTHER0);
   assign xori = (opcode == `OP_XORI);
   assign alu_op[2] = (!add & !sub) & (!addi);
   assign alu_op[1] = ~(((andd|orr)|andi)|ori);
   assign alu_op[0] = sub|orr|xorr|ori|xori;
   assign except = (!add&!sub&!andd&!orr&!norr&!xorr&!addi&!andi&!ori&!xori);
   assign writeenable = 1'b1;
   assign itype = addi|andi|ori|xori;
endmodule // mips_decode

// arith_machine: execute a series of arithmetic instructions from an instruction cache
//
// except (output) - set to 1 when an unrecognized instruction is to be executed.
// clk     (input) - the clock signal
// reset   (input) - set to 1 to set all registers to zero, set to 0 for normal execution.

module arith_machine(except, clk, reset);
   output 	except;
   input        clk, reset;

   wire [31:0] 	inst;  
   wire [31:0] 	PC;  
   wire [4:0]	Rdest;
   wire 		itype, wr_en, overflow, zero, negative;
   wire [2:0]	alu_op;
   wire [31:0]	rtData, out, imm32, A, B, nextPC;

   register #(32) PC_reg(PC, nextPC, clk, 1, reset);
   alu32 alu0(nextPC, overflow, zero, negative, PC, 32'b100, 3'b10);
   
   
   /* add other modules */
   mips_decode mip0(alu_op, wr_en, itype, except, inst[31:26], inst[5:0]);
   instruction_memory im(PC[31:2], inst);
   regfile rf (inst[25:21], inst[20:16], Rdest, A, rtData, out, wr_en, clk, reset);
   mux2v #(5) itype0(Rdest, inst[15:11], inst[20:16], itype);
   mux2v itype1(B, rtData, imm32, itype);
   assign imm32 = {{16{inst[15]}}, inst[15:0]};//Sign extender
   alu32 main_alu(out, overflow, zero, negative, A, B, alu_op);
endmodule // arith_machine

