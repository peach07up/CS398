/* Header file: bmp.h
 *
 * This header file describes the C functions that your code should
 * invoke in order to process BMP files. The actual code for these
 * functions is in the file bmp.c -- you do not need to refer to this
 * code in order to solve the MP.
 *
 * In addition, two datatypes that you will need are defined in this
 * file: pixel and BMPfile.
 *
 * To see how to use these datatypes and operations, please refer to
 * the example code given in the file: sample.c
*/

#ifndef BMP_H
#define BMP_H

#include <stdio.h>

/* Datatype: pixel
 *
 * A pixel has three components, named blue, green and red. Each of
 * these can take values from 0 to 255 (0xFF). Here are some examples
 * of how to define variables of type "pixel", and use them:
 *
 *     pixel pureGreen, pink;
 *
 *     pureGreen.blue = 0; pureGreen.green = 255; pureGreen.red = 0;
 *     pink.blue = 150; pink.green = 0; pink.red = 211;
*/

typedef struct
{
	unsigned char blue;
	unsigned char green;
	unsigned char red;
} pixel;


/* Datatype: BMPfile
 *
 * A BMPfile has 4 components: file (pointer to an actual file),
 * offset (needed to access the pixels within the file), width
 * (picture width, in pixels) and height (picture height, in pixels)
 *
 * Here is how to declare a variable of type BMPfile:
 *
 * BMPfile myfile;
 *
*/

typedef struct
{
	FILE *file;
	unsigned int offset;
	int width;
	int height;
} BMPfile;

/* Operations on BMPfiles:
 *
 * We will now look at some of the basic operations that can be
 * performed on variables of type "BMPfile". You will need to use
 * these operations in your solution to the MP.
*/

/* Opening a BMPfile with a given name */

BMPfile openBMPfile(char name[]);

/* Example:
 *
 *       BMPfile myfile;
 *       myfile = openBMPfile("picture.bmp");
*/


/* Width of a BMPfile (in pixels) */

int getWidth(BMPfile bmpfile);


/* Width of a BMPfile (in pixels) */

int getHeight(BMPfile bmpfile);


/* Reading a pixel at the (x,y)-th co-ordinate of the image */

pixel getPixel(BMPfile bmpfile, int x, int y);

/* Example:
 *
 * pixel p = getPixel(myfile, 10, 5);
*/


/* Writing a pixel to the (x,y)-th co-ordinate of the image */

void putPixel(BMPfile bmpfile, pixel newPixel, int x, int y);

/* Example:
 *
 * p.red = 0xFF;
 * putPixel(myfile, p, 10, 5);
*/


/* Closing a BMPfile */

void closeBMPfile(BMPfile bmpfile);

#endif
