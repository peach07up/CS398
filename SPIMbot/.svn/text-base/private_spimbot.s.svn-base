	

    # spimbot constants
    ANGLE = 0xffff0014
    ANGLE_CONTROL = 0xffff0018
    TIMER = 0xffff001c
    HEAD_X = 0xffff0020
    HEAD_Y = 0xffff0024
    BONK_ACKNOWLEDGE = 0xffff0060
    TIMER_ACKNOWLEDGE = 0xffff006c
    APPLE_X = 0xffff0070                            #public 0xfff0070
    APPLE_Y = 0xffff0074                            #public 0xfff0074
    OTHER_BOT_0xfff0020 = 0
    OTHER_BOT_0xfff0024 = 0
    REQUEST_PUZZLE = 0xffff0090
    SUBMIT_PUZZLE = 0xffff0094
    PIVOT_NODES_X = 0xffff00c0
    PIVOT_NODES_Y = 0xffff00c4
     
    .globl main
    main:                                  # ENABLE INTERRUPTS
         li     $t4, 0x8000                # timer interrupt enable bit
         or     $t4, $t4, 0x1000           # bonk interrupt bit
         or     $t4, $t4, 1                # global interrupt enable
         mtc0   $t4, $12                   # set interrupt mask (Status register)
         
                                           # REQUEST TIMER INTERRUPT
         lw     $v0, 0xffff001c($0)        # read current time
         add    $v0, $v0, 50               # add 50 to current time
         sw     $v0, 0xffff001c($0)        # request timer interrupt in 50 cycles
           
    infinite:
         j      infinite
         nop
     
    ########################### DATA SEGMENT ##############################
    .kdata
    chunkIH:.space 32      # space for eight registers
    non_intrpt_str:   .asciiz "Non-interrupt exception\n"
    unhandled_str:    .asciiz "Unhandled interrupt type\n"
    .globl prev_angle
    prev_angle: .word 0
    .globl turn_counter
    .globl pivot_y
    pivot_y: .space 1024
    .globl pivot_x
    pivot_x: .space 1024
    turn_counter: .word 0
    #HexList: .word 8, list
    #p_row: .word l0, l1, l2, l3, l4, l5, l6, l7
    #l0: .size 4
    #l1: .size 4
    #l2: .size 4
    #l3: .size 4
    #l4: .size 4
    #l5: .size 4
    #l6: .size 4
    #l7: .size 4
    ######################################################################
     
     
     
     
     
     
    .ktext 0x80000180
    interrupt_handler:
    .set noat
                                    move    $k1, $at
    .set at
                                    la              $k0, chunkIH
                                    sw              $a0, 0($k0)
                                    sw              $a1, 4($k0)
                                   
                                    mfc0    $k0, $13
                                    srl             $a0, $k0, 2
                                    and             $a0, $k0, 0xf
                                    bne             $a0, 0, non_intr
                                   
    intr_dsph:                                                                                              #$a0 = 0, $v0 = 0 at this stage
                                    mfc0    $k0, $13                                                #k0 gets overwritten
                                    beq             $k0, $zero, done                       
                                                                                                           
                                    and             $a0, $k0, 0x8000
                                    bne             $a0, 0, timer_intr
     
                                    and     $a0, $k0, 0x1000                        # is there a bonk interrupt?                
                                    bne     $a0, 0, bonk_intr  
                                   
                                   
                                    li              $v0, 4
                                    and             $a0, $k0, 0x1000
                                    sw              $a0, 0xffff0084($0)
                                    la              $a0, unhandled_str
                                    syscall
                                    j               done
                                   
    bonk_intr:             
                                    sw      $a1, 0xffff0060($0)
                                    lw              $t0, 0xffff0040($0)
                                    lw              $t2, 0xffff0020($0)
                                    lw              $t3, 0xffff0024($0)
                                    li              $t4, 0
                                    beq             $t0, 180, lr
                                    beq             $t0, 0, lr
                                    la              $t1, pivot_x
                                    sw              $t1, 0xffff00c0($0)                             #get pivot_x since we are travelling vertically
                    bloopx: lw              $t4, 0($t1)
                                    beq             $t4, $t2, out_blx                               #Compare the x-coords, get the segment
                                    add             $t1, $t1, 4                                            
                                    j               bloopx
                    out_blx:lw              $t5, 4($t1)                                             # $t5=endpoint
                                    sub     $t4, $t5, $t4
                                    blt             $t4, 0, set180
                                    li              $t4, 0
                                    j               fill
                    set180: li              $t4, 180
                                    j               fill
                    lr:             la              $t1, pivot_y
                                    sw              $t1, 0xffff00c4($0)                             #get pivot_y
                    bloopy: lw              $t4, 0($t1)
                                    beq             $t4, $t3, out_bly
                                    add             $t1, $t1, 4
                                    j               bloopy
                    out_bly:lw              $t5, 4($t1)
                                    sub             $t4, $t5, $t4
                                    blt             $t4, 0, set270
                                    li              $t4, 0
                                    j               fill
                    set270: li              $t4, 270
                    fill:   sw              $t4, 0xffff0014($0)
                                    li              $t4, 1
                                    sw              $t4, 0xffff0018($0)
                                    li              $t4, 256
                                    sw              $t4, 0xffff0084($0)
                                    j               intr_dsph
     
     
    timer_intr:                                                                                             #$a0 != 0 at this stage
                                    sw              $a1, 0xffff006c($0)                             #$a1 gets overwritten here
                                    lw              $t0, 0xffff0020($0)
                                    lw              $t1, 0xffff0024($0)                             #read snake's head
                                    lw              $t2, 0xffff0070($0)
                                    lw              $t3, 0xffff0074($0)                             #read public apple
                                   
                                    beq             $t0, $t2, eqx
                                    bge             $t0, $t2, gex0
                                    li              $t0, 0
                                    j               wait
                    gex0:   li              $t0, 180
                                    j               wait
            eqx:            bge             $t1, $t3, gey
                                    li              $t0, 90
                                    j               wait
                    gey:    li              $t0, 270
                                    j               wait
                                   
            wait:           lw              $t1, prev_angle
                                    sub             $t1, $t1, $t0
                                    abs             $t1, $t1
                                    bne             $t1, 180, sett
                                    add             $t1, $t0, 90
                                    sw              $t1, 0xffff0014($0)
                                    li              $t1, 1
                                    sw              $t1, 0xffff0018($0)
                                    li              $t1, 5000
                    tloop:  beq             $t1, 0, sett
                                    sub             $t1, $t1, 1    
                                    j               tloop
                                   
            sett:           sw              $t0, 0xffff0014($0)
                                    li              $t1, 1
                                    sw              $t1, 0xffff0018($0)
                                    sw              $t0, prev_angle
                                   
                                    lw              $v0, 0xffff001c($0)                                     #$v0 gets overwritten here
                                    add             $v0, $v0, 500
                                    sw              $v0, 0xffff001c($0)
                                                                                                            #What does the value of $v0 for?
                                    j               intr_dsph
                                   
    non_intr:                                                                                       #$a0 = 0 at this stage, a parallel unit with dsph
                                    li              $v0, 4                                          #$v0 gets overwritten here, but so far we don't mind...?
                                    la              $a0, non_intrpt_str
                                    syscall
                                    j               done
                                   
    done:                  
                                    la              $k0, chunkIH
                                    lw              $a0, 0($k0)
                                    lw              $a1, 4($k0)
    .set noat
                                    move    $at, $k1
    .set at
                                    eret


