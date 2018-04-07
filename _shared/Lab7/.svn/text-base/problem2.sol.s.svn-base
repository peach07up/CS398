###!!!! NOT YET FULLY DEBUGGED (or at all...)

.data
## int MAX_LENGTH = 10;
## int snake_x[10] = {50, 50, 200, 200, 150, 150, -1, -1, -1, -1};
snake_x: .word 50, 50, 200, 200, 150, 150, -1, -1, -1, -1
## int snake_y[10] = {180, 120, 120, 100, 100, 50, -1, -1, -1, -1};
snake_y: .word 180, 120, 120, 100, 100, 50, -1, -1, -1, -1

## int
## collision(int my_x, int my_y, int target_x, int target_y, int *snake_x, int *snake_y) {
## 
##   int i = 0;
## 
##   if (my_x == target_x) {              // going up or down
## 	 if (snake_x[0] == snake_x[1]) {    // first segment is verticle
## 		i ++;                            // skip first segment
## 	 }
## 	 for ( ; (i < MAX_LENGTH) && (snake_y[i] != -1) ; i += 2) {
## 		int my_loc_above = (my_y < snake_y[i]);
## 		int target_loc_above = (target_y < snake_y[i]);
## 		int left = (my_x < snake_x[i]) && (my_x < snake_x[i+1]);
## 		int right = (my_x > snake_x[i]) && (my_x > snake_x[i+1]);
## 
## 		int intersection = (my_loc_above ^ target_loc_above) && !left && !right;
## 		if (intersection) {
## 		  return i;
## 		}
## 	 }
##   } 
## 
##   return -1;
## }

MAX_LENGTH = 256

.text
.globl collision
collision:
	lw	$t4, 0($sp)	# snake_x (arg 5)
	lw	$t5, 4($sp)	# snake_y (arg 6)

	li	$t0, 0		# i = 0
	bne	$a0, $a2, left_right
	lw	$t1, 0($t4)	# snake_x[0]
	lw	$t2, 4($t4)	# snake_x[1]
	bne	$t1, $t2, loop1

	add	$t0, $t0, 1

loop1:
	bge	$t0, MAX_LENGTH, done1
	sll	$t1, $t0, 2	# i*4
	add	$t2, $t5, $t1	# &snake_y[i]
	lw	$t3, 0($t2)	# snake_y[i]
	beq	$t3, -1, done1

	slt	$t6, $a1, $t3	# (my_y < snake_y[i])
	slt	$t7, $a3, $t3	# (target_y < snake_y[i]);
	add	$t2, $t4, $t1	# &snake_x[i]
	lw	$t3, 4($t2)	# snake_x[i+1]
	lw	$t2, 0($t2)	# snake_x[i]

	# $t8 = (my_x < snake_x[i]) && (my_x < snake_x[i+1]);
	slt	$t8, $a0, $t2
	slt	$t9, $a0, $t3
	and	$t8, $t8, $t9

	# $t9 = (my_x > snake_x[i]) && (my_x > snake_x[i+1]);
	slt	$t9, $t2, $a0
	slt	$v0, $t3, $a0
	and	$t9, $t9, $v0

	# intersection = (my_loc_above ^ target_loc_above) && !left && !right;
	xor	$t6, $t6, $t7
	not	$t8, $t8
	and	$t6, $t6, $t8
	not	$t9, $t9
	and	$t6, $t6, $t9

	beq	$t6, $0, dont_return1	# if (intersection) {
	
	move	$v0, $t0		#   return i;
	jr	$ra			

dont_return1:
	add	$t0, $t0, 2		# i += 2
	j	loop1
	
left_right:

done1:
	li	$v0, -1
	jr	$ra




## ./a.out 120 40 260 40	 NO COLLISION
## ./a.out 120 60 260 60 	 COLLISION (4-5): (150,100) (150,50)
## ./a.out 180 60 180 60 	 NO COLLISION
## ./a.out 180 200 180 60 	 COLLISION (1-2): (50,120) (200,120)
## ./a.out 180 110 180 60	 COLLISION (3-4): (200,100) (150,100)
