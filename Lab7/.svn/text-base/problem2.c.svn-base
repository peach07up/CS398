#include <stdio.h>
#include <stdlib.h>

int MAX_LENGTH = 10;
int snake_x[10] = {50, 50, 200, 200, 150, 150, -1, -1, -1, -1};
int snake_y[10] = {180, 120, 120, 100, 100, 50, -1, -1, -1, -1};

// The code that you have to implement doesn't have the "else" clause,
// but we've included it here (commented out) in case you want to
// implement it sometime.

int
collision(int my_x, int my_y, int target_x, int target_y, int *snake_x, int *snake_y) {

  int i = 0;

  if (my_x == target_x) {              // going up or down
	 if (snake_x[0] == snake_x[1]) {    // first segment is verticle
		i ++;                            // skip first segment
	 }
	 for ( ; (i < MAX_LENGTH) && (snake_y[i] != -1) ; i += 2) {
		int my_loc_above = (my_y < snake_y[i]);
		int target_loc_above = (target_y < snake_y[i]);
		int left = (my_x < snake_x[i]) && (my_x < snake_x[i+1]);
		int right = (my_x > snake_x[i]) && (my_x > snake_x[i+1]);

		int intersection = (my_loc_above ^ target_loc_above) && !left && !right;
		if (intersection) {
		  return i;
		}
	 }
  } else {              // going left or right
	 // if (snake_y[0] == snake_y[1]) {    // first segment is horizontal
	 // 	i ++;                            // skip first segment
	 // }
	 // for ( ; (i < MAX_LENGTH) && (snake_y[i] != -1) ; i += 2) {
	 // 	int my_loc_left = (my_x < snake_x[i]);
	 // 	int target_loc_left = (target_x < snake_x[i]);
	 // 	int above = (my_y < snake_y[i]) && (my_y < snake_y[i+1]);
	 // 	int below = (my_y > snake_y[i]) && (my_y > snake_y[i+1]);
	 // 
	 // 	int intersection = (my_loc_left ^ target_loc_left) && !above && !below;
	 // 	if (intersection) {
	 // 	  return i;
	 // 	}
	 // }
  } 

  return -1;
}
	 
int
main(int argc, char **argv) {

  if (argc != 5) { 
	 printf("Need 4 arguments\n");
	 return 0;
  }

  int my_x = atoi(argv[1]);
  int my_y = atoi(argv[2]);
  int target_x = atoi(argv[3]);
  int target_y = atoi(argv[4]);

  int collide = collision(my_x, my_y, target_x, target_y, snake_x, snake_y);
  if (collide != -1) {
	 printf("COLLISION (%d-%d): (%d,%d) (%d,%d)\n", 
			  collide, collide+1, 
			  snake_x[collide], snake_y[collide], snake_x[collide+1], snake_y[collide+1]);
  } else {
	 printf("NO COLLISION\n");
  }
}
