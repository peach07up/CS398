########################### problem2.s testing code ##########################

## int snake_x[10] = {50, 50, 200, 200, 150, 150, -1, -1, -1, -1};
## int snake_y[10] = {180, 120, 120, 100, 100, 50, -1, -1, -1, -1};

.data
snake_x: .word 50, 50, 200, 200, 150, 150, -1, -1, -1, -1
snake_y: .word 180, 120, 120, 100, 100, 50, -1, -1, -1, -1


.text         # Code segment
print_int_and_space:            # the int to print is already in $a0
        li   $v0, 1             # load the syscall option for printing ints
        syscall                 # print the integer
        
        li   $a0, ' '           # print a black space
        li   $v0, 11            # load the syscall option for printing chars
        syscall                 # print the char
        
        jr      $ra             # return to the calling procedure


.globl main
main:	sub	$sp, $sp, 20
	sw	$ra, 8($sp)
	sw	$s0, 12($sp)
	sw	$s1, 16($sp)

	la	$s0, snake_x	# these will be arguments 5 and 6 (passed on the stack)
	la	$s1, snake_y    # keep them in callee-saved registers, so they live across calls

	li	$a0, 180	# TEST 1: snake head at (180, 200), apple at (180, 60)
	li	$a1, 200
	li	$a2, 180
	li	$a3, 60
	sw	$s0, 0($sp)	# these arguments can be overwritten by the caller, 
	sw	$s1, 4($sp)     # so we must write them each time
	jal	collision
	move 	$a0, $v0
	jal  	print_int_and_space
		
	li	$a0, 180	# TEST 2: snake head at (180, 110), apple at (180, 60)
	li	$a1, 110
	li	$a2, 180
	li	$a3, 60
	sw	$s0, 0($sp)	# these arguments can be overwritten by the caller, 
	sw	$s1, 4($sp)     # so we must write them each time
	jal	collision
	move 	$a0, $v0
	jal  	print_int_and_space
		
	li	$a0, 40		# TEST 3: snake head at (40, 200), apple at (40, 60)
	li	$a1, 200
	li	$a2, 40
	li	$a3, 60
	sw	$s0, 0($sp)	# these arguments can be overwritten by the caller, 
	sw	$s1, 4($sp)     # so we must write them each time
	jal	collision
	move 	$a0, $v0
	jal  	print_int_and_space
		
	li	$a0, 120	# TEST 4: snake head at (120, 60), apple at (260, 60)
	li	$a1, 60
	li	$a2, 260
	li	$a3, 60
	sw	$s0, 0($sp)	# these arguments can be overwritten by the caller, 
	sw	$s1, 4($sp)     # so we must write them each time
	jal	collision
	move 	$a0, $v0
	jal  	print_int_and_space

	li	$a0, 180	# TEST 5: snake head at (180, 60), apple at (180, 60)
	li	$a1, 60
	li	$a2, 180
	li	$a3, 60
	sw	$s0, 0($sp)	# these arguments can be overwritten by the caller, 
	sw	$s1, 4($sp)     # so we must write them each time
	jal	collision
	move 	$a0, $v0
	jal  	print_int_and_space
		
	lw	$ra, 8($sp)
	lw	$s0, 12($sp)
	lw	$s1, 16($sp)
	add	$sp, $sp, 20
	jr	$ra

