/* Header file: bmp.h
 *
 * This header file describes the C functions that your code should
 * invoke in order to process BMP files. The actual code for these
 * functions is in the file bmp.c -- you do not need to refer to this
 * code in order to solve the MP.
 *
 * In addition, two datatypes that you will need are defined in this
 * file: pixel_t and bmp_t
 *
 * To see how to use these datatypes and operations, please refer to
 * the example code given in the file: sample.c
*/

#ifndef BMP_H
#define BMP_H

#include <stdint.h>

/* Datatype: pixel_t
 *
 * A pixel has three components, named blue, green and red. Each of
 * these can take values from 0 to 255 (0xFF). Here are some examples
 * of how to define variables of type "pixel", and use them:
 *
 *     pixel_t pureGreen, pink;
 *
 *     pureGreen.blue = 0; pureGreen.green = 255; pureGreen.red = 0;
 *     pink.blue = 150; pink.green = 0; pink.red = 211;
*/

typedef struct {
	uint8_t blue;
	uint8_t green;
	uint8_t red;
} pixel_t;


/* Datatype: bmp_t
 *
 * A bmp_t's internal representation is not needed for client code.
 * Instead, just use pointers, similar to how FILE * is used.
 *
 * Here is how to declare a variable of type pointer to bmp_t:
 *
 * bmp_t *myfile;
 *
*/

typedef struct bmp bmp_t;

/* Operations on bmp_t *'s:
 *
 * We will now look at some of the basic operations that can be
 * performed on variables of type bmp_t *. You will need to use
 * these operations in your solution to the MP.
*/

/* Creating a bmp_t * with the given width and height
 * Be sure to check for NULL return when BMP can't be created */
bmp_t *createBmp(uint32_t width, uint32_t height);

/* Opening a bmp_t * with a given name
 * Be sure to check for NULL return when file can't be opened */
bmp_t *openBmp(const char *name);

/* Example:
 *
 *       bmp_t *myBmp;
 *       myBmp = openBmp("picture.bmp");
*/


/* Width of a bmp_t * (in pixels) */
uint32_t getWidth(bmp_t *bmp);


/* Height of a bmp_t * (in pixels) */
uint32_t getHeight(bmp_t *bmp);


/* Reading a pixel at the (x,y)-th co-ordinate of the image */
pixel_t getPixel(bmp_t *bmp, uint32_t x, uint32_t y);

/* Example:
 *
 * pixel_t p = getPixel(myBmp, 10, 5);
*/


/* Writing a pixel to the (x,y)-th co-ordinate of the image */
void putPixel(bmp_t *bmp, pixel_t p, uint32_t x, uint32_t y);

/* Example:
 *
 * p.red = 0xFF;
 * putPixel(myBmp, p, 10, 5);
*/


/* Writing a bmp_t * to an output image */
void writeBmp(bmp_t *bmp, const char *name);


/* Closing a bmp_t * */
void closeBmp(bmp_t *bmp);

#endif
