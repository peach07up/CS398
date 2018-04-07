#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include "transpose.h"

int bSize = 32;

void 
transpose2(int** src, int** dest) {
	
	for (int i = 0; i < SIZE; i = i+bSize) { 
		for (int j = i ; j < SIZE ; j = j+bSize) {
				for (int p = i; p < i+bSize; p++){
					for (int q = j; q < j+bSize; q++){
							if(q>p) dest[p][q] = src[q][p];
					}
				}
		} 
	}
  // your code goes here.

}	
	
//DO K2 = 1, M, B


	
