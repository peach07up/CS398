# SPIMbot MMIO
velocity    = 0xffff0010    # -10 to 10, Immediately updates SPIMbot's velocity
angle       = 0xffff0014   # -360 to 360, used when orientation_control is written to turn SPIMbot
angle_type  = 0xffff0018    # 0 relative, 1 absolute
timer       = 0xffff001c    # 0 to 0xffffffff, reading gives the number of elapsed cycles, writing requests an interrupt at given time
x_loc       = 0xffff0020    # 0 to 300, gives SPIMbot's x coord
y_loc       = 0xffff0024    # 0 to 300, gives SPIMbot's y coord
print_int   = 0xffff0080    # Prints an int to the screen
print_float = 0xffff0084    # Prints a float to the screen
scan_x 		= 0xffff0050 
scan_y 		= 0xffff0054
scan_radius	= 0xffff0058 
scan_addr	= 0xffff005c
stupid_botx	= 0xffff00a0
stupid_boty	= 0xffff00a4




.data

index:    .word 0
state:    .word 0
chunkLIST:   .space 20000

listed:   .word 0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	
xcord:    .word 0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	
ycord:    .word 0	0	0	0	0	0	0	0	0	0	0	0	0	0	0


three   : .float 3.0
five    : .float 5.0
PI      : .float 3.14159
F180    : .float 180.0

.text
main:
	lui     $s0, 0xffff  				#save one instruction per cycle
	sw		$0,  velocity($0)			# stop the bot
	jal		initialize

infinite:    
	j		infinite

initialize:
    li		$t4, 0x2000					# scan interrupt enable bit
    ori		$t4, $t4, 0x8000			# timer interrupt enable bit
	ori		$t4, $t4, 0x1000			# bonk interrupt enable bit
	
	ori		$t4, $t4, 1    
	mtc0	$t4, $12            		# set interrupt mask (Status register)
	li		$t1, 10
	sw		$t1,  velocity($0)
	li		$t0, 150
	sw		$t0, scan_x($0)			
	li		$t0, 150
	sw		$t0, scan_y($0)			
	li		$t0, 300
	sw		$t0, scan_radius($0)	
	la		$t0, chunkLIST
	sw		$t0, scan_addr($0)		    #initialize scanner







    jr    $ra
   
   
.kdata
chunkIH: .space 88
non_intrpt_str:   .asciiz "Non-interrupt exception\n"
unhandled_str:    .asciiz "Unhandled interrupt type\n"

.ktext 0x80000180

interrupt_handler:
    .set noat
    move		$k1, $at        # Save $at
    .set at
             
      la      $k0, chunkIH                

	  	
	  li 	  $t7, 0
      mfc0    $k0, $13        # Get Cause register
      srl     $a0, $k0, 2        
      andi     $a0, $a0, 0xf        # ExcCode field
      bne     $a0, 0, non_intrpt

interrupt_dispatch:          
	mfc0     $k0, $13
    beq      $k0, $zero, done    
    andi  	 $a0, $k0, 0x2000
    bne  	 $a0, $0, scan_interrupt
    andi      $a0, $k0, 0x1000    
    bne      $a0, 0, bonk_interrupt    
    andi      $a0, $k0, 0x8000   
    bne      $a0, $0, timer_interrupt

   
    li $v0, 4          
    la $a0, unhandled_str
    syscall
    j     done
   
bonk_interrupt:
    sw      $a1, 0x60($s0) #acknowledge bonk interrupt
 	
    li      $t0, 160            #set angle to be 160 relative
    sw      $t0, angle($0)       
    li      $t0, 0
    sw      $t0, angle_type($0)
    
    li      $t0, 10             #set the velocity
    sw      $t0, velocity($0)   
 
	
    j       interrupt_dispatch  #see if other interrupts are waiting


scan_interrupt:

   sw    $a1, 0x64($s0)         #acknowledge scan interrupt
       
   li    $gp, 0  


   la    $s1,  chunkLIST      
   la    $s2,  xcord
   la    $s3,  ycord
 

scan_loop:

  bge $gp, 120, scan_done	#find all 15 tokens

  srl  $t8, $gp, 1			
  	
  add  $s5, $t8, $s2     	#xcord array index address
  add  $s6, $t8, $s3     	#ycord array index address

  add  $s4, $gp, $s1     	#have to make up our own array     

  move  $a0, $s4

  jal sort_list        		#sort the current token list

  move   $a0, $s4      

  la     $a1, listed    	#
  jal    compact			#compact function

  la  	 $t1, listed

  lw   $t4 , 0($t1)         #get the compacted 32bit number      
  srl  $t5, $t4, 16 		#extract x              
  sw   $t5, 0($s5)			#save for later use as a target array
  andi  $t4, $t4, 0xffff     #extract y      
  sw   $t4, 0($s6)			#save for later use as a target array
 
  add  $gp, $gp, 8
			#increment

  j   scan_loop

scan_done:


timer_interrupt:
sw    $0, 0x6c($s0)        #acknowledge interrupt
   


    lw     $a0, 0x20($s0)        #get current x
	lw     $s1, index($0)
    mul    $s1, $s1, 4
    lw     $s1, xcord($s1)           

	

    lw     $a1, 0x24($s0)        
    lw     $s2, index($0)
    mul    $s2, $s2, 4
    lw     $s2, ycord($s2)            # get the target y

	



	sub $a0,$s1,$a0				#get x's difference for arctan
	sub $a1,$s2,$a1			#get y's difference for arctan

    abs    $s2, $a0
	abs    $s3, $a1
    bge    $s2, 2, continue
	bge	   $s3, 2, continue
	j	next
continue:
	bnez $t7, request
	li $t7,1
	jal  sb_arctan
	move	$t8, $v0
request:
    lw     $k0, timer($0)        # get current time
    mul    $a0, $a0, 400
    add    $k0, $k0, $a0            # set next timer appropriately
    sw     $k0, timer($0)        # request timer



    move   $a0, $t8                #set angle to be arctan returns
    bgtz    $a1,t_drive

t_drive:
    sw    $a0, angle($0)        # set angle
    li    $k0, 1
    sw    $k0, angle_type($0)        # absolute
    li    $k0, 10
    sw    $k0, velocity($0)        # set velocity
    j    interrupt_dispatch

next:
    lw     $a1, index($0)            # increment index
    addi    $a1, $a1, 1
    sw     $a1, index($0)
	li     $t7,0

    j      timer_interrupt







non_intrpt:                
    li $v0, 4            
    la $a0, non_intrpt_str
    syscall               
    j done
done:
	  la      $k0, chunkIH

	  
    mfc0     $k0 $14            # EPC
    .set noat
    move    $at,  $k1            # Restore $at
    .set at
    rfe                # Return from exception handler
    jr     $k0
        nop
       
       
       
compact:

  li    $t1, 0x80000000  
  lw    $t0, 0($a0)      

compact_loop:
 

  beq   $t0, $0, compact_done  
  lw   $t2, 12($t0)   
  lw   $t3, 0($a1)      
  beq  $t2, $zero, compact_else_case
  or   $t3, $t3, $t1    
  j    compact_endif
 
compact_else_case:
  not  $t4, $t1         
  and  $t3, $t3, $t4    
compact_endif:
  sw   $t3, 0($a1)      
  srl  $t1, $t1, 1      
 
  bne  $t0, $zero, compact_loop_maintainance
  
  div  $a1, $a1, 4
  add  $a1, $a1, 1   
  mul $a1, $a1, 4      
  li   $t1, 0x80000000  
 
compact_loop_maintainance:
  lw $t0, 8($t0)     
  j    compact_loop
 
compact_done:
  jr   $ra              
 
insert_element_after:    
    # inserts the new element $a0 after $a1
    # if $a1 is 0, then we insert at the front of the list
    bne    $a1, $zero, iea_not_head # if a1 is null, we have to assign the head and tail
    lw     $t0, 0($a2)         # $t0 = mylist->head
    sw     $t0, 8($a0)        # node->next = mylist->head;
    beqz   $t0, iea_after_head    # if ( mylist->head != NULL ) {
    sw     $a0, 4($t0)        #   mylist->head->prev = node;
                         # }
iea_after_head:    
    sw      $a0, 0($a2)        # mylist->head = node;
    lw      $t0, 4($a2)        # $t0 = mylist->tail
    bnez    $t0, iea_done        # if ( mylist->tail == NULL ) {
    sw      $a0, 4($a2)        #   mylist->tail = node;
iea_done:                     # }
    jr    $ra
iea_not_head:
    lw     $t1, 8($a1)        # $t1 = prev->next
    bne    $t1, $zero, iea_not_tail# if ( prev->next == NULL ) {
    sw     $a0, 4($a2)        #   mylist->tail = node;
    b      iea_end            # }
iea_not_tail:                # else {
    sw    $t1, 8($a0)        #   node->next = prev->next;
    sw    $a0, 4($t1)        #   node->next->prev = node;
                         # }
iea_end:    
    sw    $a0, 8($a1)        # store the new pointer as the next of $a1
    sw    $a1, 4($a0)        # store the old pointer as prev of $a0
    jr    $ra            # return
    # END insert_element_after
remove_element:
    # removes the element at $a0 (list is in $a1)
    # if this element is the whole list, we have to empty the list
    lw    $t0, 0($a1)              # t0 = mylist->head
    lw    $t1, 4($a1)              # t1 = mylist->tail
    bne    $t0, $t1, re_not_empty_list
re_empty_list:
    sw    $zero, 0($a1)        # zero out the head ptr
    sw    $zero, 4($a1)        # zero out the tail ptr
    j    re_done
re_not_empty_list:
    lw    $t2, 4($a0)        # t2 = node->prev
    lw    $t3, 8($a0)        # t3 = node->next
    bne    $t2, $zero, re_not_first# if (node->prev == NULL) {
    sw    $t3, 0($a1)        # mylist->head = node->next;
    sw    $zero, 4($t3)        # node->next->prev = NULL;
    j    re_done
re_not_first:
    bne    $t3, $zero, re_not_last# if (node->next == NULL) {
    sw    $t2, 4($a1)        # mylist->tail = node->prev;
    sw    $zero, 8($t2)        # node->prev->next = NULL;
    j    re_done
re_not_last:
    sw    $t3, 8($t2)        # node->prev->next = node->next;
    sw    $t2, 4($t3)        # node->next->prev = node->prev;
re_done:
    sw    $zero, 4($a0)        # zero out $a0's prev
    sw    $zero, 8($a0)        # zero out $a0's next
    jr    $ra            # return
    # END remove_element
   
sort_list:  # $a0 = mylist
    lw    $t0, 0($a0)              # t0 = mylist->head, smallest
    lw    $t1, 4($a0)              # t1 = mylist->tail
    bne    $t0, $t1, sl_2_or_more    # if (mylist->head == mylist->tail) {
    jr    $ra                #    return;
sl_2_or_more:
    sub    $sp, $sp, 12
    sw    $ra, 0($sp)        # save $ra
    sw    $a0, 4($sp)        # save my_list
    lw    $t1, 8($t0)              # t1 = trav = smallest->next
sl_loop:
    beq    $t1, $zero, sl_loop_done # trav != NULL
    lw    $t3, 0($t1)         # trav->data
 
    lw    $t2, 0($t0)         # smallest->data
    bge    $t3, $t2, sl_skip    # inverse of: if (trav->data < smallest->data) {
    move    $t0, $t1        # smallest = trav;
sl_skip:
    lw    $t1, 8($t1)        # trav = trav->next
    j    sl_loop
   
sl_loop_done:
    sw    $t0, 8($sp)        # save smallest
    move    $a1, $a0        # my_list is arg2
    move     $a0, $t0        # smallest is arg1
    jal     remove_element        # remove_node(smallest, mylist);
    lw    $a0, 4($sp)        # restore my_list as arg1
    jal    sort_list        # sort_list(mylist);
    lw    $a0, 8($sp)        # restore smallest as arg1
    li    $a1, 0            # pass NULL as arg2
    lw    $a2, 4($sp)        # restore my_list as arg3
    jal    insert_element_after    # insert_node_after(smallest, NULL, mylist);
    lw    $ra, 0($sp)        # restore $ra
    add    $sp, $sp, 12
    jr    $ra
    # END sort_list
















sb_arctan:
	li	$v0, 0		# angle = 0;		#x is a0;y is a1;

	abs	$t2, $a0	# get absolute values
	abs	$t3, $a1
	ble	$t3, $t2, no_TURN_90	  

	## if (abs(y) > abs(x)) { rotate 90 degrees }
	move	$t2, $a1	# int temp = y;
	sub	$a1, $zero, $a0	# y = -x;      
	move	$a0, $t2	# x = temp;    
	li	$v0, 90		# angle = 90;  

no_TURN_90:
	bge	$a0, $zero, pos_x 	# skip if (x >= 0)

	## if (x < 0) 
	add	$v0, $v0, 180	# angle += 180;

pos_x:
	mtc1	$a0, $f0
	mtc1	$a1, $f1
	cvt.s.w $f0, $f0	# convert from ints to floats
	cvt.s.w $f1, $f1
	
	div.s	$f0, $f1, $f0	# float v = (float) y / (float) x;

	mul.s	$f1, $f0, $f0	# v^^2
	mul.s	$f2, $f1, $f0	# v^^3
	l.s	$f3, three($zero)	# load 5.0
	div.s 	$f3, $f2, $f3	# v^^3/3
	sub.s	$f6, $f0, $f3	# v - v^^3/3

	mul.s	$f4, $f1, $f2	# v^^5
	l.s	$f5, five($zero)	# load 3.0
	div.s 	$f5, $f4, $f5	# v^^5/5
	add.s	$f6, $f6, $f5	# value = v - v^^3/3 + v^^5/5

	l.s	$f8, PI($zero)		# load PI
	div.s	$f6, $f6, $f8	# value / PI
	l.s	$f7, F180($zero)	# load 180.0
	mul.s	$f6, $f6, $f7	# 180.0 * value / PI

	cvt.w.s $f6, $f6	# convert "delta" back to integer
	mfc1	$t2, $f6
	add	$v0, $v0, $t2	# angle += delta


	jr 	$ra

