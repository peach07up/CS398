## In this file, please implement the any_matrix_column_matches_list_row function as shown below.
##
## Do not include any testing code in this file (especially not any
##  "main" labels).  Load this file and p2_main.s and problem1.s into QtSpim for
## testing

## int 
## any_matrix_column_matches_list_row(HexMatrix* matrix, HexList* list, int row) {
##     for (int col = 0; col < matrix->size; ++ col)    // check against the col'th column
##     {
##         if (matrix_column_matches_list_row(matrix, col, list, row)) 
##         { 
##             return 1;
##         }
##     }
##     return 0;
## }

.text
.globl any_matrix_column_matches_list_row
any_matrix_column_matches_list_row:
    sub     $sp, $sp, 24
    sw      $ra, 0($sp)
    sw      $a0, 4($sp)
    sw      $a1, 8($sp)
    sw      $a2, 12($sp)
    sw      $s0, 16($sp)
    sw      $s1, 20($sp)

    li      $s0, 0          # $s0 = col = 0

amcmlr_loop_cond:
    lw      $a0, 4($sp)     # $a0 = matrix
    lw      $s1, 0($a0)     # $s1 = matrix->size
    bge     $s0, $s1, amcmlr_loop_end

amcmlr_loop:
    move    $a1, $s0        # $a1 = col
    lw      $a2, 8($sp)     # $a2 = list
    lw      $a3, 12($sp)    # $a3 = row

    jal     matrix_column_matches_list_row  # matrix_column_matches_list_row(matrix, col, list, row)

    beq     $v0, 0, amcmlr_if_end

    li      $v0, 1          # return 1
    j       amcmlr_return

amcmlr_if_end:
    add     $s0, $s0, 1     # ++ col
    j       amcmlr_loop_cond

amcmlr_loop_end:
    li      $v0, 0          # return 0

amcmlr_return:
    lw      $ra, 0($sp)
    lw      $s0, 16($sp)
    lw      $s1, 20($sp)
    add     $sp, $sp, 24

    jr      $ra






