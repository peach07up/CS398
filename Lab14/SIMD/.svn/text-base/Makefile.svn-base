CXX = g++
CFLAGS = -Wall -g -msse -O2

all: mv-mult mandelbrot

mv-mult-main.o: mv-mult-main.c mv-mult.h
	$(CXX) $(CFLAGS) -c mv-mult-main.c

mv-mult.o: mv-mult.c mv-mult.h
	$(CXX) $(CFLAGS) -c mv-mult.c

mv-mult: mv-mult-main.o mv-mult.o
	$(CXX) $(CFLAGS) mv-mult-main.o mv-mult.o -o mv-mult

mandelbrot-main.o: mandelbrot-main.c mandelbrot.h
	$(CXX) $(CFLAGS) -c mandelbrot-main.c

mandelbrot.o: mandelbrot.c mandelbrot.h
	$(CXX) $(CFLAGS) -c mandelbrot.c

mandelbrot: mandelbrot-main.o mandelbrot.o
	$(CXX) $(CFLAGS) mandelbrot-main.o mandelbrot.o -o mandelbrot



clean:
	rm -f mv-mult mandelbrot *.o



