## In this file, please implement the solve function as shown below.
##
## Do not include any testing code in this file (especially not any
##  "main" labels).  Load this file and p4_main.s, problem1.s, 
## problem2.s and problem3.s into QtSpim for testing

## // assume matrixSize is at most 32
## int 
## solve(HexMatrix* matrix, HexList* list, int depth, unsigned int bitmask)
## {
##     if (depth == matrix->size) {  // check to see if the remaining list items match the columns
##         return check_remaining_columns(matrix, list, bitmask);
##     }
## 
##     for (int i = 0; i < list->size; ++ i) {
##         if (((1L << i) & bitmask) == 0)
##         {
##             for (int j = 0; j < matrix->size; ++ j)
##             {
##                 matrix->data[depth][j] = list->data[i][j];
##             }
## 
##             if (solve(matrix, list, depth + 1, (1L << i) | bitmask))
##             {
##                 return 1;
##             }
##         }
##     }
##     return 0;
## }

.text
.globl solve
solve:
    sub     $sp, $sp, 28
    sw      $ra, 0($sp)	    # save return address

    lw      $t0, 0($a0)     # matrix->size
    bne     $a2, $t0, solve_recurse

    move    $a2, $a3        # pass args (matrix, list, bitmask)
    jal     check_remaining_columns      # return value in $v0

    lw      $ra, 0($sp)
    add     $sp, $sp, 28
    jr      $ra

solve_recurse:
    sw      $s0, 4($sp)     # save a bunch of $s registers
    sw      $s1, 8($sp)
    sw      $s2, 12($sp)
    sw      $s3, 16($sp)
    sw      $s4, 20($sp)    
    sw      $s5, 24($sp)

    move    $s0, $a0       # copy arguments to $s registers
    move    $s1, $a1
    move    $s2, $a2
    move    $s3, $a3

    li      $s4, 0          # $s4 = i = 0

solve_loop:
    lw      $t0, 0($s1)     # $t0 = list->size
    bge     $s4, $t0, solve_return0

    li      $t0, 1          # 1
    sll     $t0, $t0, $s4   # $t0 = (1 << i)
    and     $t1, $t0, $s3   # $t1 = (1L << i) & bitmask
    bne     $t1, 0, solve_continue

    li      $s5, 0          # $s4 = j = 0

solve_inner_loop:
    lw      $t2, 0($s0)     # $t2 = matrix->size
    bge     $s5, $t2, solve_inner_done

    lw      $t3, 4($s0)     # $t3 = matrix->data
    mul     $t4, $s2, 4     # $t4 = 4 * depth
    add     $t4, $t3, $t4   # $t4 = &matrix->data[depth]
    lw      $t4, 0($t4)     # $t4 = matrix->data[depth]
    add     $t4, $t4, $s5   # $t4 = &matrix->data[depth][j]

    lw      $t5, 4($s1)     # $t5 = list->data
    mul     $t6, $s4, 4     # $t6 = 4 * i
    add     $t6, $t5, $t6   # $t6 = &list->data[i]
    lw      $t6, 0($t6)     # $t6 = list->data[i]
    add     $t6, $t6, $s5   # $t6 = &list->data[i][j]
    lb      $t6, 0($t6)     # $t6 = list->data[i][j]

    sb      $t6, 0($t4)     # matrix->data[depth][j] = list->data[i][j]

    add     $s5, $s5, 1     # ++ j
    j       solve_inner_loop

solve_inner_done:
    move    $a0, $s0
    move    $a1, $s1
    add     $a2, $s2, 1     # $a2 = depth + 1
    or      $a3, $s3, $t0   # $a3 = (1L << i) | bitmask
    jal     solve           # new_solve(matrix, list, depth + 1, (1L << i) | bitmask)

    beq     $v0, 0, solve_continue

    li      $v0, 1          # return 1
    j       solve_done

solve_continue:
    add     $s4, $s4, 1     # ++ i
    j       solve_loop

solve_return0:
    li      $v0, 0          # return 0

solve_done:
    lw      $ra, 0($sp)
    lw      $s0, 4($sp)     # save a bunch of $s registers
    lw      $s1, 8($sp)
    lw      $s2, 12($sp)
    lw      $s3, 16($sp)
    lw      $s4, 20($sp)    
    lw      $s5, 24($sp)
    add     $sp, $sp, 28
    jr      $ra
