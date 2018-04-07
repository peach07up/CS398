#include "mandelbrot.h"

typedef float v4sf __attribute__ ((vector_size (4*sizeof(float))));
//typedef float v4sf __attribute__ ((mode(V4SF)));
// mandelbrot() takes a set of SIZE (x,y) coordinates - these are actually
// complex numbers (x + yi), but we can also view them as points on a plane.
// It then runs 200 iterations of f, using the (x,y) point, and checks
// the magnitude of the result.  If the magnitude is over 4.0, it assumes
// that the function will diverge to infinity.

int *
mandelbrot(float x[SIZE], float y[SIZE]) {
	static int ret[SIZE];
	float x1, y1, x2, y2;
	int i;
	for (i = 0; i < SIZE; i += 4) {
		//x1 = y1 = 0.0;
		v4sf X, Y, tX, tY, uX, uY;
		float tempX[4], tempY[4];
		// Run M_ITER iterations
		X = __builtin_ia32_loadups(&x[i]);
		Y = __builtin_ia32_loadups(&y[i]);
		tX = __builtin_ia32_xorps(tX, tX);
		tY = __builtin_ia32_xorps(tY, tY);
		for (int j = 0; j < M_ITER; j ++) {
			// Calculate the real part of (x1 + y1 * i)^2 + (x + y * i)
			uX = __builtin_ia32_subps(__builtin_ia32_mulps(tX, tX), __builtin_ia32_mulps(tY, tY));
			uX = __builtin_ia32_addps(uX, X);
			// Calculate the imaginary part of (x1 + y1 * i)^2 + (x + y * i)
			uY = __builtin_ia32_addps(__builtin_ia32_mulps(tX, tY), __builtin_ia32_mulps(tX, tY));
			uY = __builtin_ia32_addps(uY, Y);
			// Use the new complex number as input for the next iteration
			tX = uX;
			tY = uY;
		}
		__builtin_ia32_storeups(tempX, tX);
		__builtin_ia32_storeups(tempY, tY);
		for(int k = 0; k < 4; k ++){
			ret[i+k] = ((tempX[k] * tempX[k]) + (tempY[k] * tempY[k])) < (M_MAG * M_MAG);
		}
		// caculate the magnitude of the result
		// We could take the square root, but instead we just
		// compare squares
	}
	for(; i < SIZE; i ++){
		x1 = y1 = 0.0;
		for (int j = 0; j < M_ITER; j ++) {
			x2 = (x1 * x1) - (y1 * y1) + x[i];
			y2 = 2 * (x1 * y1) + y[i];x1 = x2;
			y1 = y2;
		}
		ret[i] = ((x2 * x2) + (y2 * y2)) < (M_MAG * M_MAG);
	}
	return ret;
}

