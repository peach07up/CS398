#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>
#include "mandelbrot.h"

int *mandelbrot(float x[SIZE], float y[SIZE]);

int main(int argc, char **argv) {
   float x[SIZE];
   float y[SIZE];

   struct timeval start, end;

   for (int i = 0 ; i < SIZE ; i ++) {
      x[i] = 1.0 / (float)(i + 3);
      y[i] = 1.0 / (float)(i + 3);
   }

   gettimeofday(&start, NULL);

   for (int i = 0 ; i < ITER ; i ++) {
      mandelbrot(x, y);
   }

   gettimeofday(&end, NULL);

   int usec = (end.tv_sec - start.tv_sec) * 1000000 + (end.tv_usec - start.tv_usec);
   printf("%d iterations, %d usec\n", ITER, usec);

   return 0;
}
