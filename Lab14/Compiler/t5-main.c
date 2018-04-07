#include "declarations.h"

int main(){
   float* A = (float*) memalign(16, LEN5*sizeof(float));
   float* B = (float*) memalign(16, LEN5*sizeof(float));
   float* C = (float*) memalign(16, LEN5*sizeof(float));
   float* D = (float*) memalign(16, LEN5*sizeof(float));
   float* E = (float*) memalign(16, LEN5*sizeof(float));
   
   for (int i = 0 ; i < LEN5 ; i ++) {
      A[i] = (float)(i)/(float)LEN5;
      B[i] = (float)(i+1)/(float)LEN5;
      C[i] = (float)(i+2)/(float)LEN5;
      D[i] = (float)(i+3)/(float)LEN5;
      E[i] = (float)(i+4)/(float)LEN5;
   }

   unsigned long long start_c, end_c, diff_c;
   start_c = _rdtsc();

   t5(A,B,C,D,E);

   end_c = _rdtsc(); 
   diff_c = end_c - start_c;
   float giga_cycle = diff_c / 1000000000.0;
   
   float ttt = (float)0.;
#pragma novector
   for (int i = 0 ; i < LEN5 ; i ++) {
      ttt += A[i];
   }

   printf("t5 took\t %.2f and the result is %f\n", giga_cycle, ttt);
}
