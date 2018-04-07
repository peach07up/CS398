#include "declarations.h"

void 
t6(float* restrict A, float* restrict D) {  
	for (int nl = 0 ; nl < ntimes ; nl ++) {
		#pragma vector always
		for (int i = 0 ; i < (LEN6-1); i ++) {
			A[i] = D[0] + (float)(3.0*i + 1.0);
			D[i] = D[0] + (float)(3.0*i);
		}
	}      
}
