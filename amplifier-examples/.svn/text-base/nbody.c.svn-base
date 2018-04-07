#include "nbody.h"
#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <time.h>
#include <stdbool.h>
#include "globals.h"

int INPUT_SIZE = 0, NTIMESTEPS = 0; 
double DTIME = 0, DTHF = 0, EPS = 0;
const double THRESHOLD = 2.0;

/*
 * Print out the points for a given vector of either 
 * holders or body objects.
 */
void printPoints(const nbody_t* points)
{
  int i;
  //int INPUT_SIZE = 10;
  for (i = 0; i < INPUT_SIZE; i++)
  {
     printf("%lf %lf %lf\n", points[i].x,
        points[i].y, points[i].z);
  }
}

/*
 * Returns a vector of n_body structures containing each
 * of the points contained in the input file.
 */
nbody_t* getPoints()
{
  char cur_line[1024];
  int* outputs[] = { &INPUT_SIZE, &NTIMESTEPS };
  double* doubles[] = { &DTIME, &EPS };
  for (int i = 0; i < 4; i++) {
    fgets(cur_line, 1024, stdin);
    if (i < 2)
      sscanf(cur_line, "%d", outputs[i]);
    else
      sscanf(cur_line, "%lf", doubles[i-2]);
  }
  DTHF = 0.5 * DTIME;
  nbody_t* retVal = malloc(INPUT_SIZE * sizeof(nbody_t));
  fgets(cur_line, 1024, stdin); // ignore TOL
  for (int i=0; i<INPUT_SIZE; i++) 
  {
	fgets(cur_line, 1024, stdin);
    retVal[i].ax = 0;
    retVal[i].ay = 0;
    retVal[i].az = 0;
    sscanf(cur_line,"%lf %lf %lf %lf %lf %lf %lf",
        &(retVal[i].mass), &(retVal[i].x), &(retVal[i].y), &(retVal[i].z),
        &(retVal[i].vx), &(retVal[i].vy), &(retVal[i].vz));
  }
  return retVal;
}

int compareBodies(const void* bodyA, const void* bodyB)
{
  const nbody_t* body_A = bodyA;
  const nbody_t* body_B = bodyB;
  return body_A->x - body_B->x;
}

void computeInteractions(nbody_t* points)
{
  for (int step = 0; step <NTIMESTEPS ; step++) 
  {
    for (int i = 0; i < INPUT_SIZE; i++) 
    {
      for (int j = i+1; j < INPUT_SIZE; j++) 
      {
        double dist = abs(points[i].x - points[j].x);
		  if (dist < THRESHOLD){
          computeForce(&points[i], &points[j]);
		  }
      }
      updatePosition(&points[i]);
    }
  }
}


void computeSortedInteractions(nbody_t* points) {
  // Use qsort to sort the points by x value
  for (int step = 0; step < NTIMESTEPS; step++) 
  {
    qsort(points, INPUT_SIZE, sizeof(nbody_t), compareBodies);
    for (int i = 0; i < INPUT_SIZE; i++) 
    {
      for (int j = i+1; j < INPUT_SIZE; j++) 
      {
        double dist = abs(points[i].x - points[j].x);
        if (dist < THRESHOLD)
          computeForce(&points[i], &points[j]);
        else break;
      }
      updatePosition(&points[i]);
    }
  }
}

// computes the acceleration delta for this particular interaction
void computeForce(nbody_t* first, nbody_t* second)
{
	double xDist = second->x - first->x;
	double yDist = second->y - first->y;
	double zDist = second->z - first->z;
	
 
	double rSquared = xDist * xDist + yDist * yDist + zDist * zDist;
	double coefficient1 = second->mass / pow(rSquared, 1.5);
	double coefficient2 = first->mass / pow(rSquared, 1.5);

	first->ax += coefficient1 * xDist;
	first->ay += coefficient1 * yDist;
	first->az += coefficient1 * zDist;
	
	second->ax += coefficient2 * xDist;
	second->ay += coefficient2 * yDist;
	second->az += coefficient2 * zDist;
}

// computes the final position for a body
void updatePosition(nbody_t* body)
{
  double halfXDelta = body->ax * DTHF;
  double halfYDelta = body->ay * DTHF;
  double halfZDelta = body->az * DTHF;

  double meanXVel = body->vx + halfXDelta;
  double meanYVel = body->vy + halfYDelta;
  double meanZVel = body->vz + halfZDelta;

  body->x += meanXVel * DTIME;
  body->y += meanYVel * DTIME;
  body->z += meanZVel * DTIME;

  body->vx = meanXVel + halfXDelta;
  body->vy = meanYVel + halfYDelta;
  body->vz = meanZVel + halfZDelta;
  
  body->ax =0;
  body->ay =0;
  body->az =0;
}
