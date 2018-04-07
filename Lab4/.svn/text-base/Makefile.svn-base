all: steering word_reader rf

steering: steering.vcd

steering_exe: steering.v steering_tb.v
	iverilog -o steering_exe -Wall steering.v steering_tb.v

steering.vcd: steering_exe
	./steering_exe

word_reader: wr.vcd

word_reader_exe: word_reader.v word_reader_tb.v 
	iverilog -o word_reader_exe -Wall word_reader.v word_reader_tb.v 

wr.vcd: word_reader_exe
	./word_reader_exe


rf: rf.vcd

rf_exe: rf.v rf_tb.v 
	iverilog -o rf_exe -Wall rf.v rf_tb.v mux_lib.v

rf.vcd: rf_exe
	./rf_exe
