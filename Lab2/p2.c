/**************************** p2.c *****************************
 *
 * This file is to facilitate your testing of the countOnes function.
 * 
 * We will not look at this file during grading, so don't put code
 * you want graded here.
 * 
 */

/* Compiling and running this code:
 *
 * To compile the code, give the following command:
 *
 *   make p2
 *
 * Running the code:
 *
 * The compiler (gcc) will create a file called p2, which can be run
 * by giving the following command:
 *
 *   ./p2 55
 *
 * The argument to the program (55 in the above example) is a decimal
 * number (i.e. in base 10). Your program (once it is completed) will
 * count the number of ones in the decimal representation of this
 * argument and print the answer. Currently, the program just prints
 * the argument.
 *
 */

#include <stdio.h>
#include <stdlib.h>

// forward declaration of countOnes function
unsigned int countOnes(unsigned int input);

/* The two arguments to the "main" function are argv (argument-count,
 * i.e. the number of arguments) and argv (argument-vector, i.e. an
 * array of length 'argc' of strings that are arguments to the code
 */
int 
main(int argc, char *argv[]) {
  int input;
  int count;
  
  /* Check for the correct number of arguments. The first argument
	* (i.e. argv[0]) is always the program name (i.e. a.out), so we
	* require argc to be at least 2.
	*/
  
  if (argc < 2) {
	 /* Print error message and quit program */
	 fprintf(stderr,"Usage: %s number\n",argv[0]);
	 exit(-1);
  }
  
  /* Scan the input argument (assuming it is a decimal number) */
  sscanf(argv[1], "%d", &input);
  
  count = countOnes(input);
  
  /* Print the answer */
  printf("%d\n", count);
}

