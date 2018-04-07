.text
.globl new_angle
MAX_LENGTH = 256
.text
.globl collision
# spimbot constants
ANGLE = 0xffff0014
ANGLE_CONTROL = 0xffff0018
TIMER = 0xffff001c
HEAD_X = 0xffff0020
HEAD_Y = 0xffff0024
BONK_ACKNOWLEDGE = 0xffff0060
TIMER_ACKNOWLEDGE = 0xffff006c
APPLE_X = 0xffff0070
APPLE_Y = 0xffff0074

.kdata                # interrupt handler data (separated just for readability)
chunkIH:.space 32      # space for eight registers
non_intrpt_str:   .asciiz "Non-interrupt exception\n"
unhandled_str:    .asciiz "Unhandled interrupt type\n"



.ktext 0x80000180
interrupt_handler:

.set noat
move $k1, $at               	# Save $at   

                           
.set at
la $k0, chunkIH                
sw $a0, 0($k0)              	# Get some free registers                  
sw $a1, 4($k0)              	# by storing them to a global variable     
sw $v0, 8($k0)
sw $t1, 12($k0)
sw $t2, 16($k0)
sw $t3, 20($k0)
sw $t4, 24($k0)
sw $t5, 28($k0)

mfc0 $k0, $13               	# Get Cause register                       
srl  $a0, $k0, 2                
and  $a0, $a0, 0xf          	# ExcCode field                            
bne  $a0, 0, non_intrpt         

#######################Interrupt####################################################

interrupt_dispatch:                                                   
     	mfc0 $k0, $13                 	# Get Cause register, again                 
     	beq  $k0, $zero, done         	# handled all outstanding interrupts     

     	and  $a0, $k0, 0x1000         	# is there a bonk interrupt?                
     	bne  $a0, 0, bonk_interrupt   

    	and  $a0, $k0, 0x8000         	# is there a timer interrupt?
    	bne  $a0, 0, timer_interrupt

       	# add dispatch for other interrupt types here.

     	li $v0, 4                    	# Unhandled interrupt types

     	la $a0, unhandled_str
     	syscall
     	j  done

bonk_interrupt:
     	sw $zero, 0xffff0010($zero)
     	sw $a1, 0xffff0060($zero)   	# acknowledge interrupt

     	j  interrupt_dispatch       	# see if other interrupts are waiting

timer_interrupt:
     	sw $a1, 0xffff006c($zero)   	# acknowledge interrupt

lw $t1, HEAD_X($0)	# my_x = HEAD_X
lw $t2, HEAD_Y($0) # my_y = HEAD_Y
lw $t3, APPLE_X($0)	# apply_x = APPLE_X
lw $t4, APPLE_Y($0)	# apply_y = APPLE_Y

beq $t1, $t3, else
bge $t1, $t3, angle180
li  $t5, 0
j   ab

else:	bge $t2, $t4, angle270
li  $t5, 90
j   ab

ab:	lw  $t1, prev_angle($0)	# prev_angle to $t1
sub $t2, $t1, $t5	# prev_angle - desired_angle
abs $t2, $t2	# abs(prev_angle - desired_angle)
bne $t2, 180, last

add $t3, $t5, 90	# desired_angle + 90
sw  $t3, ANGLE($0)
li  $t4, 1
sw  $t4, ANGLE_CONTROL($0)	# SET_ABSOLUTE_ANGLE(desired_angle + 90)

li  $t1, 2500	# i = 2500

for:	beq $t1, 0, last
sub $t1, $t1, 1	# i--
j   for	

last:	sw  $t5, ANGLE($0)
li  $t4, 1
sw  $t4, ANGLE_CONTROL($0)	# SET_ABSOLUTE_ANGLE(desired_angle)
sw  $t5, prev_angle($0)	


     	lw  $v0, TIMER($0)      	# current time
     	add $v0, $v0, 500  
     	sw  $v0, TIMER($0)      	# request timer in 500

     	j   interrupt_dispatch # see if other interrupts are waiting

non_intrpt:li $v0, 4
     	  la $a0, non_intrpt_str
     	  syscall                 	# print out an error message

angle180:li $t5, 180
j  ab

angle270:li $t5, 270
j  ab

############################################################
new_angle:

beq $a0, $a2, change_vertical

bgt $a0, $a2, change_direction

li  $v0, 0

jr  $ra

change_direction: li  $v0, 180

jr  $ra

change_vertical:  bgt $a1, $a3, face_up

li  $v0, 90

jr  $ra

face_up:	li  $v0, 270

jr $ra
################################################################
collision:

	lw $t0, 0($sp)      	## load address of x array into t0
	lw $t1, 4($sp)	## load address of y array into t1

	and $t2, $t2, $0  	## int i = 0

			     
	bne $a0, $a2, FINISH	## my_x == target_x


	lw $t4, 4($t0)        	
	lw $t3, 0($t0)	 	
	bne $t3, $t4, for_loop	## snake_x[0] == snake_x[1]

	addi $t2, $t2, 1	## i++

	for_loop:bge $t2, 256, FINISH	 	## i < MAX_LENGTH  

	mul $t7, $t2, 4	                       
	add $t8, $t0, $t7
	add $t9, $t1, $t7	
	lw  $t4, 0($t9)                ## y [i]
	lw  $t3, 0($t8)	## x [i]	
	move $t5, $t4	## snake_y[i]
	beq $t5, -1, FINISH ## snake_y[i] != -1

	slt $t5, $a1, $t4	## int my_loc_above = (my_y < snake_y[i]);

	slt $t6, $a3, $t4	## int target_loc_above = (target_y < snake_y[i]);


	slt $t7, $a0, $t3	
	lw  $t4, 4($t8)	
	slt $t8, $a0, $t4
	and $t7, $t7, $t8	## int left = (my_x < snake_x[i]) && (my_x < snake_x[i+1]);


	sgt $t8, $a0, $t3
	sgt $t9, $a0, $t4
	and $t8, $t8, $t9	## int right = (my_x > snake_x[i]) && (my_x > snake_x[i+1]);


	xor $t3, $t5, $t6
	not $t7, $t7
	not $t8, $t8
	and $t9, $t3, $t7
	and $t9, $t9, $t8	## int intersection = (my_loc_above ^ target_loc_above) && !left && !right;


	li $t8, 1
	beq $t9, $t8, RETURN_i	## if (intersection) { return i;}

	add $t2, $t2, 2	## i += 2
	j for_loop

	RETURN_i:move $v0, $t2
	jr   $ra

	FINISH:  add $v0, $0, -1	## return -1
	jr	$ra
	any_matrix_column_matches_list_row:

	   	
	sub $sp, $sp, 16

	li $t9, 0              	  	## int col = 0;
	lw $t8, 0($a0)	  	## t8 = matrix->size;

	for_2:    	bge $t9, $t8, return_zero_2	## col >= matrix->size

	sw $ra, 0($sp)
	sw $a1, 4($sp)
	sw $a2, 8($sp)
	sw $a3, 12($sp)

	move $t7, $a2
	move $a2, $a1
	move $a1, $t9	
	move $a3, $t7

jal matrix_column_matches_list_row

	lw $ra, 0($sp)
	lw $a1, 4($sp)
	lw $a2, 8($sp)
	lw $a3, 12($sp)

	beq $v0, 1, return_one	

	add $t9, $t9, 1	       	## col++
	j for_2

	return_zero_2:  li $v0, 0
	add $sp, $sp, 16	
	jr $ra

	return_one:     li $v1, 1
	add $sp, $sp, 16	
	jr $ra

	check_remaining_columns:

	  sub $sp, $sp, 20

	li $t0, 0                ## t0 = 0 = i
	lw $t1, 0($a1)	## t1 = list->size
	   sw $t1, 8($sp)
	   sw $ra, 0($sp)
	   sw $a2, 16($sp)

	sub $t0,$t0, -1
	for:
	add $t0, $t0, 1
	bge $t0, $t1, end

	li $t2, 1	## if ((1L << i) & bitmask)	
	sll $t2, $t2, $t0

	   and $t2, $a2, $t2	

	bne $t2, 0, for

	sw $t0, 4($sp)

	sw $t2, 12($sp)



	move $a2, $t0



jal any_matrix_column_matches_list_row


	lw $ra, 0($sp)
	lw $t0, 4($sp)
	lw $t1, 8($sp)
	lw $t2, 12($sp)
	lw $a2, 16($sp)

	beq $v0, 0, return_zero

	j for


	end:
	li $v0, 1
	add $sp, $sp, 20
	   jr      $ra
	return_zero:
	li $v0, 0
	add $sp, $sp, 20
	   jr      $ra
