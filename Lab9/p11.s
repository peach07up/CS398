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

    move $k1, $at                   # Save $at   

                           

.set at

    la $k0, chunkIH                

    sw $a0, 0($k0)                  # Get some free registers                  

    sw $a1, 4($k0)                  # by storing them to a global variable     

    sw $v0, 8($k0)

    sw $t1, 12($k0)

    sw $t2, 16($k0)

    sw $t3, 20($k0)

    sw $t4, 24($k0)

    sw $t5, 28($k0)

    mfc0 $k0, $13                   # Get Cause register                       

    srl  $a0, $k0, 2                

    and  $a0, $a0, 0xf              # ExcCode field                            

    bne  $a0, 0, non_intrpt         

#######################Interrupt####################################################

interrupt_dispatch:                                                   

         mfc0 $k0, $13                     # Get Cause register, again                 

         beq  $k0, $zero, done             # handled all outstanding interrupts     

         and  $a0, $k0, 0x1000             # is there a bonk interrupt?                

         bne  $a0, 0, bonk_interrupt   

        and  $a0, $k0, 0x8000             # is there a timer interrupt?

        bne  $a0, 0, timer_interrupt

                       # add dispatch for other interrupt types here.

         li $v0, 4                        # Unhandled interrupt types

         la $a0, unhandled_str

         syscall

         j  done

bonk_interrupt:

         sw $zero, 0xffff0010($zero)

         sw $a1, 0xffff0060($zero)       # acknowledge interrupt

         j  interrupt_dispatch           # see if other interrupts are waiting

timer_interrupt:

         sw $a1, 0xffff006c($zero)       # acknowledge interrupt

    lw $t1, HEAD_X($0)        # my_x = HEAD_X

    lw $t2, HEAD_Y($0)         # my_y = HEAD_Y

    lw $t3, APPLE_X($0)        # apply_x = APPLE_X

    lw $t4, APPLE_Y($0)        # apply_y = APPLE_Y

    beq $t1, $t3, else

    bge $t1, $t3, angle180

    li  $t5, 0

    j   ab

else:    bge $t2, $t4, angle270

    li  $t5, 90

    j   ab

ab:    lw  $t1, prev_angle($0)        # prev_angle to $t1

    sub $t2, $t1, $t5        # prev_angle - desired_angle

    abs $t2, $t2            # abs(prev_angle - desired_angle)

    bne $t2, 180, last

    add $t3, $t5, 90        # desired_angle + 90

    sw  $t3, ANGLE($0)

    li  $t4, 1

    sw  $t4, ANGLE_CONTROL($0)    # SET_ABSOLUTE_ANGLE(desired_angle + 90)

   

    li  $t1, 2500            # i = 2500

for:    beq $t1, 0, last

    sub $t1, $t1, 1            # i--

    j   for   

   

last:    sw  $t5, ANGLE($0)

    li  $t4, 1

    sw  $t4, ANGLE_CONTROL($0)    # SET_ABSOLUTE_ANGLE(desired_angle)

    sw  $t5, prev_angle($0)   

           

         lw  $v0, TIMER($0)          # current time

         add $v0, $v0, 500  

         sw  $v0, TIMER($0)          # request timer in 500

         j   interrupt_dispatch          # see if other interrupts are waiting

non_intrpt:li $v0, 4

            la $a0, non_intrpt_str

            syscall                     # print out an error message

angle180:li $t5, 180

     j  ab

angle270:li $t5, 270

     j  ab


done:    la $k0, chunkIH

         lw $a0, 0($k0)                  # Restore saved registers

         lw $a1, 4($k0)

    lw $v0, 8($k0)

    lw $t1, 12($k0)

    lw $t2, 16($k0)

    lw $t3, 20($k0)

    lw $t4, 24($k0)

    lw $t5, 28($k0)


.set noat

         move    $at, $k1                # Restore $at

.set at

         eret
