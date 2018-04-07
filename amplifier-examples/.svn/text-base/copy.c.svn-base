#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define SIZE (1<<14)  // 16384

void copy1(int** image1, int** image2)
{

	clock_t c2, c3;
	c2 = clock(); 


	for (int i = 0 ; i < SIZE ; i ++) { 
		for (int j = 0 ; j < SIZE ; j ++) {
			image1[i][j]= image2[i][j];
		} 
	}
	c3 = clock();   

	printf("Copy rows Elapsed CPU time without optimization is %lf seconds\n",
	   (((double)c3)-c2)/CLOCKS_PER_SEC);

	printf(" Image %d \n", image2[random() % SIZE][2]);
}

void copy2(int** image1, int** image2)
{

	clock_t c2, c3;
	c2 = clock(); 


	for (int i = 0 ; i < SIZE ; i ++) { 
		for (int j = 0 ; j < SIZE ; j ++) {
			image1[j][i]= image2[j][i];
		} 
	}
	c3 = clock();	

	printf("Copy cols Elapsed CPU time without optimization is %lf seconds\n",
	   (((double)c3)-c2)/CLOCKS_PER_SEC);


	printf(" Image %d \n", image1[random() % SIZE][2]);
}

int main(int argc, char* argv[])
 {
	int ** image1, **image2, **image3;
	image1 = (int**) malloc(SIZE * sizeof (int*));
	image2 = (int**) malloc(SIZE * sizeof (int*));
	image3 = (int**) malloc(SIZE * sizeof (int*));
	for (int x=0; x < SIZE ; x++){
		image1[x]= (int*) malloc (SIZE * sizeof(int));
		image2[x]= (int*) malloc (SIZE * sizeof(int));
		image3[x]= (int*) malloc(SIZE * sizeof(int));
		
	}
   for (int i=0; i < SIZE ; i++){
	   for (int j=0; j < SIZE ; j++){
		   image2[i][j] = random() % 10;
	   }
   }
	
	 copy1(image1, image2);
	 copy2(image3, image2);
	
}
	

