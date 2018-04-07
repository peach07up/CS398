#include <stdio.h>
#include <stdlib.h>
#include "omp.h"
#include "pi_calc.h"



/**
 * Serial pi calculator. NOT GRADED, used for comparison.
 */
double serialCalculatePi(long num_steps) {
	// determine the width of our intervals, dx
	double dx = 1.0 / num_steps;

	double sum = 0;
	// this is the "N" in our summation
	for (long i = 0; i < num_steps; i++) {
		// calculate the mid point in our rectangle
		double x_i = (i + 0.5) * dx;
		sum += 4.0/(1.0 + x_i * x_i);
	}
	// multiply our sum by our dx (we pulled dx out of the summation)
	double pi = sum * dx;
	return pi;
}


double parallelcalculatePi(long num_steps) {
	// determine the width of our intervals, dx
	double dx = 1.0 / num_steps;
	double partialsum[NUM_THREADS];
	
	double sum = 0;
	for (int i=0; i< NUM_THREADS; i++) {
	   partialsum[i]=0.0;
	}
	
	// this is the "N" in our summation
   #pragma omp parallel 
	{
	   int threadid = omp_get_thread_num();
	   double temp = 0;
	   #pragma omp for
	   for (long i = 0; i < num_steps; i++) {
	   	// calculate the mid point in our rectangle
	   	double x_i = (i + 0.5) * dx;
	   	temp += 4.0/(1.0+x_i*x_i);
	   }
	   partialsum[threadid] = temp;
	}
	for (int i=0; i< NUM_THREADS; i++){
	   sum += partialsum[i];
	}
		
	// multiply our sum by our dx (we pulled dx out of the summation)
	double pi = sum * dx;
	return pi;
}
