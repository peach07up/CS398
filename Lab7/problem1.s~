## In this file, please implement the new_angle function as shown below.
##
## Do not include any testing code in this file (especially not any
##  "main" labels).  Load both this file and p1_main.s into QtSpim for
## testing

## int
## new_angle(int my_x, int my_y, int apple_x, int apple_y) {
##   if (my_x != apple_x) {    // are we already aligned in x?
##     if (my_x < apple_x) {   // if not, are we too far to left?
##       return 0;             // then face to the right
##     }		       
##     return 180;             // otherwise face to the left
##   } else {                  // otherwise my_x == apple_x
##     if (my_y < apple_y) {   // are we above the apple?
##       return 90;            // then face down
##     }		       
##     return 270;             // otherwise face up
##   }
## }


# my_x = $a0, my_y = $a1, apple_x = $a2, apple_y = $$a3
.text
.globl new_angle
new_angle:	beq	$a0, $a2, sameX
			slt $t1, $a0, $a2
			beq $0, $t1, right
			li 	$v0, 0
			j	end
	right:	li 	$v0, 180
			j	end
	sameX:	slt $t1, $a1, $a3
			beq $0, $t1, down
			li 	$v0, 90
			j	end
	down:	li 	$v0, 270
			j	end
	end:	jr	$ra

