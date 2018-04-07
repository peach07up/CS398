.text

## int
## new_angle(int my_x, int my_y, int apple_x, int apple_y) {
##   if (my_x != apple_x) {
##     if (my_x < apple_x) {
##       return 0;
##     }
##     return 180;
##   } else {  // my_x == apple_x
##     if (my_y < apple_y) {
##       return 90;
##     }
##     return 270;
##   }
## }

## int
## new_angle(int my_x, int my_y, int apple_x, int apple_y) {
##   int angle = 270;
##   if (my_x != apple_x) {
##     if (my_x > apple_x) {
##       angle = 0;
##     }
##     angle 180;
##   } else {  // my_x == apple_x
##     if (my_y < apple_y) {
##       angle = 90;
##     }
##   }
##   return angle;
## }
	
.globl new_angle
new_angle:
	beq  	$a0, $a2, na_do_y
	bgt	$a0, $a2, na_180
	li	$v0, 0
	jr 	$ra
na_180:	li	$v0, 180
	jr 	$ra
na_do_y:bge	$a1, $a3, na_270
	li	$v0, 90
	jr	$ra
na_270:	li	$v0, 270
	jr	$ra
	
	
