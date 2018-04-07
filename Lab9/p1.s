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
#interrupt_handler:
#.ktext 0x80000180
interrupt_handler:
.set noat
      move      $k1, $at               # Save $at                              
.set at
      la      $k0, chunkIH                
      sw      $a0, 0($k0)              # Get some free registers                  
      sw      $a1, 4($k0)              # by storing them to a global variable
        sw $t0,8($k0)
        sw $t1,12($k0)  
        sw $t2,16($k0)  
        sw $t3,20($k0)  
        sw $t4,24($k0)  
        sw $t5,28($k0)
        sw $t6,32($k0)
        sw $t7,36($k0)
        sw $t8,40($k0)
        sw $t9,44($k0)
        sw $v0,48($k0)
     
 
      mfc0    $k0, $13                 # Get Cause register                      
      srl     $a0, $k0, 2                
      and     $a0, $a0, 0xf            # ExcCode field                            
      bne     $a0, 0, non_intrpt        
 
interrupt_dispatch:                    # Interrupt:                            
      mfc0    $k0, $13                 # Get Cause register, again                
      beq     $k0, $zero, done         # handled all outstanding interrupts    
 
      and     $a0, $k0, 0x1000         # is there a bonk interrupt?                
      bne     $a0, 0, bonk_interrupt  
 
      and     $a0, $k0, 0x8000         # is there a timer interrupt?
      bne     $a0, 0, timer_interrupt
 
                         # add dispatch for other interrupt types here.
 
      li      $v0, 4                   # Unhandled interrupt types
 
      la      $a0, unhandled_str
      syscall
      j       done
 
bonk_interrupt:
      sw      $zero, 0xffff0010($zero) # ???
      sw      $a1, 0xffff0060($zero)   # acknowledge interrupt
 
      j       interrupt_dispatch       # see if other interrupts are waiting
 
timer_interrupt:
    sw      $a1, 0xffff006c($zero)   # acknowledge interrupt
    lw $t0,0xffff0020($0)
    lw $t1,0xffff0070($0)
    beq $t1,$t0,end1
    bge $t0,$t1,set180
    j set0
end1:
        lw $t0,0xffff0024($0)
    lw $t1,0xffff0074($0)
    bge $t0,$t1,set270
    j set90
set0:
        add $t2,$0,0
        j angcomp
set90:
        add $t2,$0,90
        j angcomp
set270:
        add $t2,$0,270
        j angcomp
set180:
        add $t2,$0,180
        j angcomp
angcomp:
        la $t3,prev_angle
        lw $t3,0($t3)
        sub $t4,$t3,$t2
        abs $t4,$t4
        bne $t4,180,finish1
        add $t5,$t2,90
        sw $t5,0xffff0014($0)
        add $t1,$0,1
        sw $t1,0xffff0018($0)
      lw      $v0, 0xffff001c($0)      # current time
      add     $v0, $v0, 5000
      sw      $v0, 0xffff001c($0)      # request timer in 50000
 
 
 
 
finish1:
        sw $t2,0xffff0014($0)
        add $t1,$0,1
        sw $t1,0xffff0018($0)
        la $t3, prev_angle
        sw $t2,0($t3)
      lw      $v0, 0xffff001c($0)      # current time
      add     $v0, $v0, 500
      sw      $v0, 0xffff001c($0)      # request timer in 50000
 
      j       interrupt_dispatch       # see if other interrupts are waiting
 
non_intrpt:                            # was some non-interrupt
      li      $v0, 4
      la      $a0, non_intrpt_str
      syscall                          # print out an error message
 
      # fall through to done
 
done:  
      la      $k0, chunkIH
      lw      $a0, 0($k0)              # Restore saved registers
      lw      $a1, 4($k0)
        lw $t0,8($k0)
        lw $t1,12($k0)  
        lw $t2,16($k0)  
        lw $t3,20($k0)  
        lw $t4,24($k0)  
        lw $t5,28($k0)
        lw $t6,32($k0)
        lw $t7,36($k0)
        lw $t8,40($k0)
        lw $t9,44($k0)
        lw $v0,48($k0)
.set noat
      move    $at, $k1                 # Restore $at
.set at
      eret
