all: pipelined_machine
.PHONY: all pipelined_machine clean no_deps_or_beqs beqs_but_no_deps deps_but_no_beqs pipeline_test

pipelined_machine: pipelined_machine_exe 
	./pipelined_machine_exe | grep -v 'VCD warning'

pipelined_machine_exe: mips_defines.v modules.v rom.v pipelined_machine.v pipelined_machine_tb.v 
	iverilog -o pipelined_machine_exe -Wall pipelined_machine_tb.v

clean:
	rm -f pipelined_machine_exe pm.vcd


no_deps_or_beqs: 
	rm -f memory.text.dat
	rm -f memory.data.dat
	ln -s no_deps_or_beq.text.dat memory.text.dat
	ln -s no_deps_or_beq.data.dat memory.data.dat


beqs_but_no_deps: 
	rm -f memory.text.dat
	rm -f memory.data.dat
	ln -s beqs_but_no_deps.text.dat memory.text.dat
	ln -s beqs_but_no_deps.data.dat memory.data.dat

deps_but_no_beqs:
	rm -f memory.text.dat
	rm -f memory.data.dat
	ln -s deps_but_no_beqs.text.dat memory.text.dat
	ln -s deps_but_no_beqs.data.dat memory.data.dat

pipeline_test:
	rm -f memory.text.dat
	rm -f memory.data.dat
	ln -s pipeline_test.text.dat memory.text.dat
	ln -s pipeline_test.data.dat memory.data.dat
	



