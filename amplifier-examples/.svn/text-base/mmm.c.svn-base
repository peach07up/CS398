#include <time.h>
#include <stdlib.h>
#include <stdio.h>

//This code assumes that LEN2 is a multiple of BLOCK_SIZE
#define BLOCK_SIZE 64
#define LEN2 1024


int MMM1(float**  M1, float**  M2, float**  M3)
{
	
	clock_t start_t, end_t;
	
	start_t = clock();
	
	for (int i = 0; i < LEN2; i++) {
		for (int j = 0; j < LEN2; j++) {
			for (int k = 0; k < LEN2; k++) {
				M3[i][j] += M1[i][k]*M2[k][j];
			}
		}
	}
	
	end_t= clock(); 
	
	float ttt = (float)0.;
	for (int i = 0; i < LEN2; i++)
		for (int j = 0; j < LEN2; j++)
			ttt += M3[i][j];
	
	printf("MMM1 took\t %.2f seconds and the result is %.2f\n",  (((double)end_t) - start_t)/CLOCKS_PER_SEC, ttt);
	return 0;
}

int MMM2(float**  M1, float**  M2, float**  M3)
{
	
	clock_t start_t, end_t;
	
	start_t = clock();
	
	for (int i = 0; i < LEN2; i++) {
		for (int k = 0; k < LEN2; k++) {
			for (int j = 0; j < LEN2; j++) {
				M3[i][j] += M1[i][k]*M2[k][j];
			}
		}
	}
	
	end_t= clock(); 
	
    float ttt = (float)0.;
	for (int i = 0; i < LEN2; i++)
		for (int j = 0; j < LEN2; j++)
			ttt += M3[i][j];
	
	
	printf("MMM2 took\t %.2f and the result is %.2f\n",  (((double)end_t) - start_t)/CLOCKS_PER_SEC, ttt);
	return 0;
}

int MMM3(float**  M1, float**  M2, float**  M3)
{
	
	clock_t start_t, end_t;
	
	start_t = clock();
	
	for (int ii = 0; ii < LEN2; ii+=BLOCK_SIZE) {
		for (int kk = 0; kk < LEN2; kk+=BLOCK_SIZE) {
			for (int jj = 0; jj < LEN2; jj+= BLOCK_SIZE) {
				for (int i = ii; i < ii+BLOCK_SIZE; i++) {
					for (int k = kk; k < kk+BLOCK_SIZE; k++) {
						for (int j = jj; j < jj+BLOCK_SIZE ; j++) {
							M3[i][j] += M1[i][k]*M2[k][j];
						}
					}
			}
		}
	}}
	

	end_t = clock();
	float ttt = (float)0.;
	for (int i = 0; i < LEN2; i++)
		for (int j = 0; j < LEN2; j++)
			ttt += M3[i][j];
	
	printf("MMM3 took\t %.2f seconds and the result is %.2f\n",  (((double)end_t) - start_t)/CLOCKS_PER_SEC, ttt);
	return 0;
}

int main(){
	
	float** M1 = (float**) malloc(LEN2*sizeof(float*));
	float** M2 = (float**) malloc(LEN2*sizeof(float*));
	float** M3 = (float**) malloc(LEN2*sizeof(float*));
	float** M4 = (float**) malloc(LEN2*sizeof(float*));
	float** M5 = (float**) malloc(LEN2*sizeof(float*));
	
	for (int i = 0; i < LEN2; i++){
		M1[i] = (float*) malloc(LEN2*sizeof(float));
		M2[i] = (float*) malloc(LEN2*sizeof(float));
		M3[i] = (float*) malloc(LEN2*sizeof(float));
		M4[i] = (float*) malloc(LEN2*sizeof(float));
		M5[i] = (float*) malloc(LEN2*sizeof(float));
		}
				
	for (int i = 0; i < LEN2; i++){
		for (int j = 0; j < LEN2; j++){
			M1[i][j] = (float)(i+j)/(float)LEN2;
			M2[i][j] = (float)(i+j+1)/(float)LEN2;
			M3[i][j] = (float)(i+j+2)/(float)LEN2;
			M4[i][j] = M3[i][j];
			M5[i][j] = M3[i][j];
		}
	}
	MMM1(M1,M2,M3);
	MMM2(M1,M2,M4);
	MMM3(M1,M2,M5);
}
			
			
