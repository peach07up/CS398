// mips_decode: a decoder for MIPS arithmetic instructions
//
// alu_op      (output) - control signal to be sent to the ALU
// writeenable (output) - should a new value be captured by the register file
// itype       (output) - should the ALU receive 1 reg. value and 1 immediate (1) or 2 reg values (0)
// except      (output) - set to 1 when we don't recognize an opdcode & funct combination
// control_type[1:0] (output) - 00 = fallthrough, 01 = branch_target, 10 = jump_target, 11 = jump_register 
// mem_read    (output) - the register value written is coming from the memory
// word_we     (output) - we're writing a word's worth of data
// byte_we     (output) - we're only writing a byte's worth of data
// byte_load   (output) - we're doing a byte load
// lui         (output) - the instruction is a lui
// slt         (output) - the instruction is an slt
// opcode       (input) - the opcode field from the instruction
// funct        (input) - the function field from the instruction
// zero         (input) - from the ALU
//

module mips_decode(alu_op, writeenable, itype, except, control_type,
		   mem_read, word_we, byte_we, byte_load, lui, slt, 
		   opcode, funct, zero);
   output [2:0] alu_op;
   output 	writeenable, itype, except;
   output [1:0] control_type;
   output 	mem_read, word_we, byte_we, byte_load, lui, slt;
   input  [5:0] opcode, funct;
   input 	zero;
   
   wire 	xor10;
   wire 	add, sub, andd, orr, norr, xorr, addi, andi, ori, xori;
   wire		beq, bne, j, jr, lui, slt, lw, lbu, sw, sb;
   
   assign add = (opcode == `OP_OTHER0) & (funct == `OP0_ADD);
   assign sub = (opcode == `OP_OTHER0) & (funct == `OP0_SUB);
   assign andd = (opcode == `OP_OTHER0) & (funct == `OP0_AND);
   assign orr = (opcode == `OP_OTHER0) & (funct == `OP0_OR);
   assign norr = (opcode == `OP_OTHER0) & (funct == `OP0_NOR);
   assign xorr = (opcode == `OP_OTHER0) & (funct == `OP0_XOR);
   assign addi = (opcode == `OP_ADDI);
   assign andi = (opcode == `OP_ANDI);
   assign ori = (opcode == `OP_ORI);
   assign xori = (opcode == `OP_XORI);
   assign beq = (opcode == `OP_BEQ);
   assign bne = (opcode == `OP_BNE);
   assign j = (opcode == `OP_J);
   assign jr = (opcode == `OP_OTHER0) & (funct == `OP0_JR);
   assign lui = (opcode == `OP_LUI);
   assign slt = (opcode == `OP_OTHER0) & (funct == `OP0_SLT);
   assign lw = (opcode == `OP_LW);
   assign lbu = (opcode == `OP_LBU);
   assign sb = (opcode == `OP_SB);
   assign sw = (opcode == `OP_SW);
   assign alu_op[2] = andd|orr|xorr|norr|andi|ori|xori;
   assign alu_op[1] = ~(andd|orr|andi|ori);
   assign alu_op[0] = sub|orr|xorr|ori|xori|beq|bne|slt;
   assign except = (!add&!sub&!andd&!orr&!norr&!xorr&!addi&!andi&!ori&!xori&!beq&!bne&!j&!jr&!lui&!slt&!lw&!lbu&!sw&!sb);
   assign writeenable = !beq&!bne&!j&!jr&!sw&!sb;
   assign itype = addi|andi|ori|xori|lui|lw|lbu|sw|sb;
   assign control_type[1] = j|jr;
   assign control_type[0] = (beq & zero)|(bne & ~zero)|jr;
   assign mem_read = lw|lbu;
   assign word_we = sw;
   assign byte_we = sb;
   assign byte_load = lbu;
endmodule // mips_decode


// full_machine: execute a series of MIPS instructions from an instruction cache
//
// except (output) - set to 1 when an unrecognized instruction is to be executed.
// clk     (input) - the clock signal
// reset   (input) - set to 1 to set all registers to zero, set to 0 for normal execution.

module full_machine(except, clk, reset);
   output 	except;
   input        clk, reset;

   wire [31:0] 	inst;  

   // DO NOT comment out or rename this wire
   // and make sure you use it to hold the current PC
   // otherwise the test bench will break
   wire [31:0] 	PC;
   
   
   wire [2:0]	alu_op;
   wire [1:0]	control_type;
   wire 		mem_rd, wd_we, bt_we, bt_ld, lui, slt, wr_en, itype;
   wire [4:0]	rDest;
   wire [31:0]	out, rsData, rtData, B, ext, neg32, word, byte, lui32, data_out, n_PC, PC0, PC1, PC2, offset;
   wire 		overf, zero, neg, dc0, dcneg;
   wire [7:0]	byte8;
   wire			bitt = 0;
   wire [31:0]	r_bl, r_mr, r_lui, r_neg;
   register #(32) PC_reg(PC,  n_PC, clk, 1, reset);

   // DO NOT comment out or rename this module
   // or the test bench will break
   regfile rf (inst[25:21], inst[20:16], rDest, 
              	rsData, rtData, r_lui, 
                wr_en, clk, reset);

   /* add other modules */
   //Mips_decoder
   mips_decode mips(alu_op, wr_en, itype, except, control_type,
		   mem_rd, wd_we, bt_we, bt_ld, lui, slt, 
		   inst[31:26], inst[5:0], zero);//mips
   //ALU
   alu32 #(32)main(out, overf, zero, neg, rsData, B, alu_op);//main alu-done
   alu32 next(PC0, overf, dc0, dcneg, PC, 4, 2);//add4 alu-done
   alu32 branch(PC1, overf, dc0, dcneg, PC0, offset, 2);//branch offset alu-done
   

   //MUX
   mux2v #(5) rdest(rDest, inst[15:11], inst[20:16], itype);//-done
   mux2v b(B, rtData, ext, itype);//-done
   mux2v slt0(r_neg, out, neg32, slt);//-done
   mux2v btld(r_bl, word, byte, bt_ld);//-done
   mux2v mrd(r_mr, r_neg, r_bl, mem_rd);//-done
   mux2v lui0(r_lui, r_mr, lui32, lui);//-done
   mux4v #(8) ldbt(byte8, word[7:0], word[15:8], word[23:16], word[31:24], out[1:0]);//-done
   mux4v #(32) flow(n_PC, PC0, PC1, PC2, rsData, control_type);//done
   
   //Data Memory
   data_mem d_m(word, out, rtData, wd_we, bt_we, clk, reset);//-done
   
   //Extenders
   assign ext = {{16{inst[15]}}, inst[15:0]};//Sign extenders
   assign neg32 = neg;//mux2v slt0
   assign byte = byte8;
   assign lui32 = {inst[15:0], {16{bitt}}};
   assign PC2 = {PC[31:28], inst[25:0], {2{bitt}}};
   assign offset[31:2] = ext[29:0];
   assign offset[1:0] = 2'b0;
   
   //Instruction Memory
   instruction_memory im(PC[31:2], inst);
   
endmodule // full_machine
