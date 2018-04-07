LABNAME = cachesim

COMPILER = g++ 
COMPILER_OPTS = -c -g -Wall
LINKER = g++

OBJS = cache.o parse_input.o


$(LABNAME): cache.o parse_input.o
	$(LINKER) $(OBJS) -o $(LABNAME)

cache.o : cache.h cache.c
	$(COMPILER) $(COMPILER_OPTS) cache.c

parse_input.o : parse_input.c
	 $(COMPILER) $(COMPILER_OPTS) parse_input.c

clean:
	-rm -f *.o $(LABNAME)
