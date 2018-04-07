# make sure you run: source /software/intel-composer-2011u5-x86_64/bin/compilervars.sh intel64

CXX = icpc
CFLAGS = -Wall -g -O2
VECTOR_FLAGS = -vec-report2 -restrict
NO_VECTOR_FLAGS = -no-vec -restrict

all: t1-scalar t1-vector t2-scalar t2-vector t3-scalar t3-vector t4-scalar t4-vector t5-scalar t5-vector t6-scalar t6-vector

t1-main.o: t1-main.c 
	$(CXX) $(CFLAGS) $(VECTOR_FLAGS) -c t1-main.c

t1-scalar.o: t1.c
	$(CXX) $(CFLAGS) $(NO_VECTOR_FLAGS) -c t1.c -o t1-scalar.o

t1-scalar: t1-main.o t1-scalar.o
	$(CXX) $(CFLAGS) $(NO_VECTOR_FLAGS) t1-main.o t1-scalar.o -o t1-scalar

t1-vector.o: t1.c
	$(CXX) $(CFLAGS) $(VECTOR_FLAGS) -c t1.c -o t1-vector.o

t1-vector: t1-main.o t1-vector.o
	$(CXX) $(CFLAGS) $(VECTOR_FLAGS) t1-main.o t1-vector.o -o t1-vector

######  t2

t2-main.o: t2-main.c 
	$(CXX) $(CFLAGS) $(VECTOR_FLAGS) -c t2-main.c

t2-scalar.o: t2.c
	$(CXX) $(CFLAGS) $(NO_VECTOR_FLAGS) -c t2.c -o t2-scalar.o

t2-scalar: t2-main.o t2-scalar.o
	$(CXX) $(CFLAGS) $(NO_VECTOR_FLAGS) t2-main.o t2-scalar.o -o t2-scalar

t2-vector.o: t2.c
	$(CXX) $(CFLAGS) $(VECTOR_FLAGS) -c t2.c -o t2-vector.o

t2-vector: t2-main.o t2-vector.o
	$(CXX) $(CFLAGS) $(VECTOR_FLAGS) t2-main.o t2-vector.o -o t2-vector

######  t3

t3-main.o: t3-main.c 
	$(CXX) $(CFLAGS) $(VECTOR_FLAGS) -c t3-main.c

t3-scalar.o: t3.c
	$(CXX) $(CFLAGS) $(NO_VECTOR_FLAGS) -c t3.c -o t3-scalar.o

t3-scalar: t3-main.o t3-scalar.o
	$(CXX) $(CFLAGS) $(NO_VECTOR_FLAGS) t3-main.o t3-scalar.o -o t3-scalar

t3-vector.o: t3.c
	$(CXX) $(CFLAGS) $(VECTOR_FLAGS) -c t3.c -o t3-vector.o

t3-vector: t3-main.o t3-vector.o
	$(CXX) $(CFLAGS) $(VECTOR_FLAGS) t3-main.o t3-vector.o -o t3-vector

######  t4

t4-main.o: t4-main.c 
	$(CXX) $(CFLAGS) $(VECTOR_FLAGS) -c t4-main.c

t4-scalar.o: t4.c
	$(CXX) $(CFLAGS) $(NO_VECTOR_FLAGS) -c t4.c -o t4-scalar.o

t4-scalar: t4-main.o t4-scalar.o
	$(CXX) $(CFLAGS) $(NO_VECTOR_FLAGS) t4-main.o t4-scalar.o -o t4-scalar

t4-vector.o: t4.c
	$(CXX) $(CFLAGS) $(VECTOR_FLAGS) -c t4.c -o t4-vector.o

t4-vector: t4-main.o t4-vector.o
	$(CXX) $(CFLAGS) $(VECTOR_FLAGS) t4-main.o t4-vector.o -o t4-vector

######  t5

t5-main.o: t5-main.c 
	$(CXX) $(CFLAGS) $(VECTOR_FLAGS) -c t5-main.c

t5-scalar.o: t5.c
	$(CXX) $(CFLAGS) $(NO_VECTOR_FLAGS) -c t5.c -o t5-scalar.o

t5-scalar: t5-main.o t5-scalar.o
	$(CXX) $(CFLAGS) $(NO_VECTOR_FLAGS) t5-main.o t5-scalar.o -o t5-scalar

t5-vector.o: t5.c
	$(CXX) $(CFLAGS) $(VECTOR_FLAGS) -c t5.c -o t5-vector.o

t5-vector: t5-main.o t5-vector.o
	$(CXX) $(CFLAGS) $(VECTOR_FLAGS) t5-main.o t5-vector.o -o t5-vector

######  t6

t6-main.o: t6-main.c 
	$(CXX) $(CFLAGS) $(VECTOR_FLAGS) -c t6-main.c

t6-scalar.o: t6.c
	$(CXX) $(CFLAGS) $(NO_VECTOR_FLAGS) -c t6.c -o t6-scalar.o

t6-scalar: t6-main.o t6-scalar.o
	$(CXX) $(CFLAGS) $(NO_VECTOR_FLAGS) t6-main.o t6-scalar.o -o t6-scalar

t6-vector.o: t6.c
	$(CXX) $(CFLAGS) $(VECTOR_FLAGS) -c t6.c -o t6-vector.o

t6-vector: t6-main.o t6-vector.o
	$(CXX) $(CFLAGS) $(VECTOR_FLAGS) t6-main.o t6-vector.o -o t6-vector





clean:
	rm -f t*-scalar t*-vector  *.o



