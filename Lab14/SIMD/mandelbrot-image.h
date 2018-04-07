#ifndef MANDLEBROT_IMAGE
#define MANDLEBROT_IMAGE

// remove mandelbrot.h definitions
#undef SIZE
#undef M_ITER
#undef M_MAG

// this is the number of pixels per unit along the coordinate axes
// change it to alter the resolution of the resulting image
#define PIXELS_PER_AXES_UNIT 600

// don't change any of these
#define WIDTH   (3 * PIXELS_PER_AXES_UNIT + 1)
#define HEIGHT  (2 * PIXELS_PER_AXES_UNIT + 1)
#define	SIZE	(WIDTH * HEIGHT)

#define	M_ITER	200
#define	M_MAG	2.0

#endif
