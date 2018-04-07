.data

#typedef struct HexMatrix {
#    int size;
#    unsigned char** data;
#} HexMatrix;

#typedef struct HexList {
#    int size;
#    unsigned char** data;
#} HexList;

########################## MATRIX 1 ########################## 
M2050: .byte 0x4, 0xf
M2070: .byte 0xd, 0x5
M2030: .word M2050, M2070
matrix1: .word 2, M2030

##########################  LIST 1  ########################## 
L20e0: .byte 0xf, 0x5
L2100: .byte 0xd, 0x5
L2120: .byte 0x4, 0xd
L2140: .byte 0x4, 0xf
L20b0: .word L20e0, L2100, L2120, L2140
list1: .word 4, L20b0


########################## MATRIX 2 ########################## 
M21b0: .byte 0x4, 0xf, 0xd, 0x5
M21d0: .byte 0xa, 0x3, 0x6, 0x9
M21f0: .byte 0xd, 0x1, 0xf, 0xe
M2210: .byte 0x1, 0xc, 0xe, 0xd
M2180: .word M21b0, M21d0, M21f0, M2210
matrix2: .word 4, M2180

##########################  LIST 2  ########################## 
L22a0: .byte 0x5, 0x9, 0xe, 0xd
L22c0: .byte 0xa, 0x3, 0x6, 0x9
L22e0: .byte 0xd, 0x6, 0xf, 0xe
L2300: .byte 0x1, 0xc, 0xe, 0xd
L2320: .byte 0xf, 0x3, 0x1, 0xc
L2340: .byte 0x4, 0xa, 0xd, 0x1
L2360: .byte 0xd, 0x1, 0xf, 0xe
L2380: .byte 0x4, 0xf, 0xd, 0x5
L2250: .word L22a0, L22c0, L22e0, L2300, L2320, L2340, L2360, L2380
list2: .word 8, L2250


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
        
        la   $a0, matrix1       # TEST 1: (matrix1, list1, 0)
        la   $a1, list1
        li   $a2, 0
        jal  any_matrix_column_matches_list_row          # call your function
        move $a0, $v0
        jal  print_int_and_space

        la   $a0, matrix1       # TEST 2: (matrix1, list1, 2)
        la   $a1, list1
        li   $a2, 2
        jal  any_matrix_column_matches_list_row          # call your function
        move $a0, $v0
        jal  print_int_and_space
        
        la   $a0, matrix1       # TEST 3: (matrix1, list1, 3)
        la   $a1, list1
        li   $a2, 3
        jal  any_matrix_column_matches_list_row          # call your function
        move $a0, $v0
        jal  print_int_and_space
        
        la   $a0, matrix2       # TEST 4: (matrix2, list2, 2)
        la   $a1, list2
        li   $a2, 2
        jal  any_matrix_column_matches_list_row          # call your function
        move $a0, $v0
        jal  print_int_and_space
        
        la   $a0, matrix2       # TEST 4: (matrix2, list2, 3)
        la   $a1, list2
        li   $a2, 3
        jal  any_matrix_column_matches_list_row          # call your function
        move $a0, $v0
        jal  print_int_and_space

        la   $a0, matrix2       # TEST 4: (matrix2, list2, 5)
        la   $a1, list2
        li   $a2, 5
        jal  any_matrix_column_matches_list_row          # call your function
        move $a0, $v0
        jal  print_int_and_space
        
        lw   $ra, 0($sp)        # restore $ra
        addi $sp, $sp, 4
        
        jr   $ra












