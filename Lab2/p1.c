/**************************** p1.c *****************************
 *
 * This file is to facilitate your testing of the extractMessage
 * function.
 * 
 * We will not look at this file during grading, so don't put code
 * you want graded here.
 *
 */

/* Compiling and running this code:
 *
 * To compile the code, give the following command:
 *
 *   make p1
 *
 * Running the code:
 *
 * The compiler (gcc) will create a file called p1, which can be run
 * by giving the following command:
 *
 *   ./p1 picture.bmp
 *
 * The argument to the program (picture.bmp in the above example) is 
 * the name of a file in the bitmap image file format.
 *
 */

#include <stdio.h>
#include <stdlib.h>
#include "bmp.h"

// forward declaration of extractMessage function
void extractMessage(BMPfile bmpfile, char* msg);
 
int 
main(int argc, char *argv[]) {
	BMPfile bmpfile;	/* bmpfile is a variable of type BMPfile */
	char* msg;		/* message that was in the BMPfile */

	/* Check for the correct number of arguments. The first argument
	 * (i.e. argv[0]) is always the program name (i.e. p1), so we
	 * require argc to be at least 2.
	 */
  	if (argc < 2) {
		/* Print error message and quit program */
	 	fprintf(stderr, "Usage: %s filename\n", argv[0]);
	 	exit(-1);
  	}
  
	/* Open the image file */
  	bmpfile = openBMPfile(argv[1]);
	
	/* Allocate the buffer */
	msg = (char*) malloc(getWidth(bmpfile) * getHeight(bmpfile));

	/* Extract the hidden message */
  	extractMessage(bmpfile, msg);

	/* Display the extracted message */
	printf("Extracted Message:\t%s\n", msg);

	/* Close open image file */
  	closeBMPfile(bmpfile);
}

