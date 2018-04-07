########################### problem1.s testing code ##########################
#
# Do not edit this code.
# 
# This code does:
# 1. enable timer and bonk interrupts
# 2. requests a timer interrupt in 50 cycles
# 3. allocates space for a prev_angle variable and initializes it to 0
#
#############################################################################

# spimbot constants
TIMER = 0xffff001c

.globl main
main:                                  # ENABLE INTERRUPTS
     li     $t4, 0x8000                # timer interrupt enable bit
     or     $t4, $t4, 0x1000           # bonk interrupt bit
     or     $t4, $t4, 1                # global interrupt enable
     mtc0   $t4, $12                   # set interrupt mask (Status register)
     
                                       # REQUEST TIMER INTERRUPT
     lw     $v0, TIMER($0)             # read current time
     add    $v0, $v0, 50               # add 50 to current time
     sw     $v0, TIMER($0)             # request timer interrupt in 50 cycles

infinite: 
     j      infinite
     nop


.kdata
.globl prev_angle
prev_angle: .word 0




