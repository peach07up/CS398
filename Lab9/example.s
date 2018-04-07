.text 
main:                                  # ENABLE INTERRUPTS
     li     $t4, 0x8000                # timer interrupt enable bit
     or     $t4, $t4, 0x1000           # bonk interrupt bit
     or     $t4, $t4, 1                # global interrupt enable
     mtc0   $t4, $12                   # set interrupt mask (Status register)
     
                                       # REQUEST TIMER INTERRUPT
     lw     $v0, 0xffff001c($0)        # read current time
     add    $v0, $v0, 50               # add 50 to current time
     sw     $v0, 0xffff001c($0)        # request timer interrupt in 50 cycles

     li     $a0, 10
     sw     $a0, 0xffff0010($zero)     # drive

infinite: 
     j      infinite
     nop


.kdata                # interrupt handler data (separated just for readability)
chunkIH:.space 8      # space for two registers
non_intrpt_str:   .asciiz "Non-interrupt exception\n"
unhandled_str:    .asciiz "Unhandled interrupt type\n"
#bonk_str:    .asciiz "Bonk interrupt\n"


.ktext 0x80000180
interrupt_handler:
.set noat
      move      $k1, $at               # Save $at                               
.set at
      la      $k0, chunkIH                
      sw      $a0, 0($k0)              # Get some free registers                  
      sw      $a1, 4($k0)              # by storing them to a global variable     

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
      #sw      $zero, 0xffff0010($zero) # ???
      sw      $a1, 0xffff0060($zero)   # acknowledge interrupt
      li	  $t1, 90
      sw	  $t1, 0xffff0014($zero)
      li	  $t1, 1
      sw	  $t1, 0xffff0018($zero)
      j       interrupt_dispatch       # see if other interrupts are waiting

timer_interrupt:
      sw      $a1, 0xffff006c($zero)   # acknowledge interrupt

      li      $t0, 90                  # ???
      sw      $t0, 0xffff0014($zero)   # ???
      sw      $zero, 0xffff0018($zero) # ???

      lw      $v0, 0xffff001c($0)      # current time
      add     $v0, $v0, 60000  
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
.set noat
      move    $at, $k1                 # Restore $at
.set at 
      eret
