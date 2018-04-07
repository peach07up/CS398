## This file is provided for your enjoyment.  Load both it and your debugged problem1.s
## into QtSpimbot and watch it go!

.text

# spimbot constants
ANGLE = 0xffff0014
ANGLE_CONTROL = 0xffff0018
HEAD_X = 0xffff0020
HEAD_Y = 0xffff0024
APPLE_QUERY = 0xffff0078
APPLE_X = 0xffff0070
APPLE_Y = 0xffff0074

.globl main
main:
	sub	$sp, $sp, 16
	sw	$ra, 0($sp)
	sw	$s0, 0($sp)
	sw	$s1, 0($sp)
	
	li 	$s0, 1  # absolute angle
	li	$s1, 0  # prev_angle

iterate_apples:
	lw 	$a0, HEAD_X
	lw 	$a1, HEAD_Y
	sw 	$0,  APPLE_QUERY
	lw 	$a2, APPLE_X
	lw 	$a3, APPLE_Y

	jal	new_angle

	sub	$t0, $s1, $v0	     # prev_angle - angle
	abs	$t0, $t0	     # if the abs of angle diffs is 180
	bne	$t0, 180, set_direction	# then this would be a U-turn
	add	$t0, $v0, 90         # can't do U-turns
	sw 	$t0, ANGLE      # set angle to + 90
	sw 	$s1, ANGLE_CONTROL

	li	$t0, 2500	     # and wait ~5000 cycles
wait:	add	$t0, $t0, -1
	bne	$t0, $0, wait

set_direction:	
	sw 	$v0, ANGLE
	sw 	$s0, ANGLE_CONTROL
	move	$s1, $v0	     # remember previous direction
	
	j	iterate_apples


	# this code is never reached, but I'm showing it for good style.
	lw	$ra, 0($sp)
	lw	$s0, 0($sp)
	lw	$s1, 0($sp)
	add	$sp, $sp, 16

	jr	$ra
