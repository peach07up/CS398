#include <stdio.h>
#include <stdlib.h>

int
new_angle(int my_x, int my_y, int apple_x, int apple_y) {
  if (my_x != apple_x) {
    if (my_x < apple_x) {
      return 0;
    }
    return 180;
  } else {  // my_x == apple_x
    if (my_y < apple_y) {
      return 90;
    }
    return 270;
  }
}

int
main(int argc, char **argv) {

  if (argc != 5) { 
	 printf("Need 4 arguments\n");
	 return 0;
  }

  int my_x = atoi(argv[1]);
  int my_y = atoi(argv[2]);
  int apple_x = atoi(argv[3]);
  int apple_y = atoi(argv[4]);

  int angle = new_angle(my_x, my_y, apple_x, apple_y);
  printf("angle = %d\n", angle);
}
