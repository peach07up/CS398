#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>
#include "mv-mult.h"

float *mv_mult(float mat[SIZE][SIZE], float vec[SIZE]);


int main(int argc, char **argv) {
	float mat[SIZE][SIZE];
	float vec[SIZE];
	int i, j;

	struct timeval start, end;

	for (i = 0; i < SIZE; i++) {
		for (j = 0; j < SIZE; j++)
			mat[i][j] = (float)i / (float)(j + 1);
		vec[i] = (float)i;
	}

	gettimeofday(&start, NULL);

	for (i = 0; i < ITER; i++)
		mv_mult(mat, vec);

	gettimeofday(&end, NULL);

	i = (end.tv_sec - start.tv_sec) * 1000000 + (end.tv_usec - start.tv_usec);
	printf("%d iterations, %d usec\n", ITER, i);

	return 0;
}
