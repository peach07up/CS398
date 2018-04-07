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
	
//DO K2 = 1, M, B//  DO J2 = 1, M, B//    DO I = 1, M//      DO K1 = K2, MIN(K2 + B - 1, M)//         DO J1 = J2, MIN(J2 + B - 1, M)//            Z(J1, I) = Z(J1, I) + X(K1, I) * Y(J1, K1)


	

