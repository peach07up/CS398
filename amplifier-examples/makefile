CFLAGS = -std=c99 -Wall -g
CXX = gcc
LIBS = -lm

all: copy mmm sum nbody 

copy: copy.c
	$(CXX) $(CFLAGS) copy.c -o copy

mmm: mmm.c
	$(CXX) $(CFLAGS) mmm.c -o mmm

sum: sum.c
	$(CXX) $(CFLAGS) sum.c -o sum

nbody: main.c nbody.c
	$(CXX) $(CFLAGS) main.c nbody.c $(LIBS) -o nbody

clean:
	rm -f copy mmm sum nbody 
