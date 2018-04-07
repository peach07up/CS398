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

########################## MATRIX 1 ########################## 
M3050: .byte 0x4, 0xd
M3070: .byte 0xd, 0x5
M3030: .word M3050, M3070
matrix1a: .word 2, M3030


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

########################## MATRIX 2 ########################## 
M31b0: .byte 0x4, 0xf, 0xd, 0x5
M31d0: .byte 0xa, 0x3, 0x6, 0x9
M31f0: .byte 0xd, 0x6, 0xf, 0xe
M3210: .byte 0x1, 0xc, 0xe, 0xd
M3180: .word M31b0, M31d0, M31f0, M3210
matrix2a: .word 4, M3180


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
        
        la   $a0, matrix1       # TEST 1: (matrix1, list1, 0xa)
        la   $a1, list1
        li   $a2, 0xa		# 4'b1010
        jal  check_remaining_columns          # call your function
        move $a0, $v0
        jal  print_int_and_space

        la   $a0, matrix1       # TEST 2: (matrix1, list1, 0x3)
        la   $a1, list1
        li   $a2, 0x3                         # 4'b0011
        jal  check_remaining_columns          # call your function
        move $a0, $v0
        jal  print_int_and_space
        
        la   $a0, matrix1a      # TEST 3: (matrix1a, list1, 0x6)
        la   $a1, list1
        li   $a2, 0x6                         # 4'b0110
        jal  check_remaining_columns          # call your function
        move $a0, $v0
        jal  print_int_and_space
        
        la   $a0, matrix2       # TEST 4: (matrix2, list2, 0xca)
        la   $a1, list2
        li   $a2, 0xca                        # 8'b11001010
        jal  check_remaining_columns          # call your function
        move $a0, $v0
        jal  print_int_and_space
        
        la   $a0, matrix2       # TEST 4: (matrix2, list2, 0xfa)
        la   $a1, list2
        li   $a2, 0xf0                        # 8'b11110000
        jal  check_remaining_columns          # call your function
        move $a0, $v0
        jal  print_int_and_space

        la   $a0, matrix2a       # TEST 4: (matrix2, list2, 0x8e)
        la   $a1, list2
        li   $a2, 0x8e                        # 8'b10001110
        jal  check_remaining_columns          # call your function
        move $a0, $v0
        jal  print_int_and_space
        
        lw   $ra, 0($sp)        # restore $ra
        addi $sp, $sp, 4
        
        jr   $ra

