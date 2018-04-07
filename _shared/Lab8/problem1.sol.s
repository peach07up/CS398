## In this file, please implement the matrix_column_matches_list_row function as shown below.
##
## Do not include any testing code in this file (especially not any
##  "main" labels).  Load both this file and p1_main.s into QtSpim for
## testing

## int 
## matrix_column_matches_list_row(HexMatrix* matrix, int col, HexList* list, int row) {
##     for (int k = 0; k < matrix->size; ++ k)    // check each element in row against column
##     {
##         if (matrix->data[k][col] != list->data[row][k])   
##         {
##             return 0;                          // if an element doesn't match, the row doesn't
##         }
##     }
##     return 1;
## }

.text
.globl matrix_column_matches_list_row
matrix_column_matches_list_row:
    li      $t0, 0          # $t0 = k = 0

mcmlr_loop_cond:
    lw      $t1, 0($a0)     # $t1 = matrix->size
    bge     $t0, $t1, mcmlr_loop_end

mcmlr_loop:
    lw      $t2, 4($a0)     # $t2 = matrix->data
    mul     $t3, $t0, 4     # $t3 = 4 * k
    add     $t2, $t2, $t3   # $t2 = &matrix->data[k]
    lw      $t2, 0($t2)     # $t2 = matrix->data[k]
    add     $t2, $t2, $a1   # $t2 = &matrix->data[k][col]
    lb      $t2, 0($t2)     # $t2 = matrix->data[k][col]

    lw      $t3, 4($a2)     # $t3 = list->data
    mul     $t4, $a3, 4     # $t4 = 4 * row
    add     $t3, $t3, $t4   # $t3 = &list->data[row]
    lw      $t3, 0($t3)     # $t3 = list->data[row]
    add     $t3, $t3, $t0   # $t3 = &list->data[row][k]
    lb      $t3, 0($t3)     # $t3 = list->data[row][k]

    beq     $t2, $t3, mcmlr_if_end

    li      $v0, 0          # return 0
    j       mcmlr_return

mcmlr_if_end:
    add     $t0, $t0, 1     # ++ k
    j       mcmlr_loop_cond

mcmlr_loop_end:
    li      $v0, 1          # return 1

mcmlr_return:
    jr      $ra





