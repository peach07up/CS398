#include <stdio.h>

#include "bmp.h"
#include "mandelbrot.h"
#include "mandelbrot-image.h"
// normally, including a .c file is a terrible idea
// however, I want to replace the constants in mandelbrot.h with my own values,
// and this is the easiest way to do so
#include "mandelbrot.c"

static float x_coords[SIZE], y_coords[SIZE];

int main(int argc, char *argv[]) {
	if (argc != 2) {
		printf("Usage: %s image-name\n", argv[0]);
		return 1;
	}

	// y axis goes from 1 to -1
	// x axis goes from -2 to 1
	for (int y = 0; y < HEIGHT; ++y) {
		float y_coord = 1.0 - (y * 2.0 / (HEIGHT - 1));
		for (int x = 0; x < WIDTH; ++x) {
			float x_coord = -2.0 + (x * 3.0 / (WIDTH - 1));
			x_coords[y * WIDTH + x] = x_coord;
			y_coords[y * WIDTH + x] = y_coord;
		}
	}

	int *in_set = mandelbrot(x_coords, y_coords);

	bmp_t *bmp = createBmp(WIDTH, HEIGHT);
	for (int y = 0; y < HEIGHT; ++y) {
		for (int x = 0; x < WIDTH; ++x) {
			// white for points out of set, black for points in set
			uint8_t color = !in_set[y * WIDTH + x] * 255;
			pixel_t p = { color, color, color };
			putPixel(bmp, p, x, y);
		}
	}

	writeBmp(bmp, argv[1]);
	closeBmp(bmp);
	return 0;
}
