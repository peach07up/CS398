########################### problem1.s testing code ##########################

.text         # Code segment

print_int_and_space:
                                # the int to print is already in $a0
        li   $v0, 1             # load the syscall option for printing ints
        syscall                 # print the integer
        
        li   $a0, ' '           # print a black space
        li   $v0, 11            # load the syscall option for printing chars
        syscall                 # print the char
        
        jr      $ra             # return to the calling procedure


# main function

.globl main
main:
        sub  $sp, $sp 4
        sw   $ra, 0($sp)        # save $ra on stack
        
        li   $a0, 50            # TEST 1: snake head at (50, 100), apple at (200, 200)
        li   $a1, 100
        li   $a2, 200
        li   $a3, 200
        jal  new_angle          # call your function
        move $a0, $v0
        jal  print_int_and_space
        
        li   $a0, 200            # TEST 2: snake head at (200, 200), apple at (50, 100)
        li   $a1, 200
        li   $a2, 50
        li   $a3, 100
        jal  new_angle          # call your function
        move $a0, $v0
        jal  print_int_and_space
        
        li   $a0, 50            # TEST 3: snake head at (50, 100), apple at (50, 200)
        li   $a1, 100
        li   $a2, 50
        li   $a3, 200
        jal  new_angle          # call your function
        move $a0, $v0
        jal  print_int_and_space
        
        li   $a0, 200            # TEST 4: snake head at (200, 200), apple at (200, 100)
        li   $a1, 200
        li   $a2, 200
        li   $a3, 100
        jal  new_angle          # call your function
        move $a0, $v0
        jal  print_int_and_space
        
        li   $a0, 50            # TEST 5: snake head at (50, 100), apple at (50, 100)
        li   $a1, 100
        li   $a2, 50
        li   $a3, 100
        jal  new_angle          # call your function
        move $a0, $v0
        jal  print_int_and_space
        
        lw   $ra, 0($sp)        # restore $ra
        addi $sp, $sp, 4
        
        jr   $ra

