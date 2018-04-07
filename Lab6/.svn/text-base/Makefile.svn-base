all: full_machine
.PHONY: all full_machine all_test lwbr_test clean

full_machine: full_machine_exe
	./full_machine_exe | grep -v 'VCD warning'

full_machine_exe: mips_defines.v rf.v alu32.v rom.v full_machine.v full_machine_tb.v 
	iverilog -o full_machine_exe -Wall full_machine_tb.v

all_test: 
	rm -f memory.text.dat
	rm -f memory.data.dat
	ln -s all.text.dat memory.text.dat
	ln -s all.data.dat memory.data.dat

lwbr_test: 
	rm -f memory.text.dat
	rm -f memory.data.dat
	ln -s lwbr2.text.dat memory.text.dat
	ln -s lwbr2.data.dat memory.data.dat

clean:
	rm -f full_machine_exe fm.vcd
