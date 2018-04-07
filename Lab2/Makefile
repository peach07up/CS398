
all: p1 p2

p1 : p1.c extractMessage.c
	gcc -std=c99 -o p1 extractMessage.c bmp.c p1.c


p2 : countOnes.c p2.c
	gcc -std=c99 -o p2 countOnes.c p2.c