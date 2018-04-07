all: arith_machine
.PHONY: all arith_machine clean

arith_machine: arith_machine_exe memory.text.dat
	./arith_machine_exe

arith_machine_exe: mips_defines.v rf.v alu32.v rom.v arith_machine.v arith_machine_tb.v 
	iverilog -o arith_machine_exe -Wall arith_machine_tb.v

clean:
	rm -rf arith_machine_exe am.vcd
