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
any_matrix_column_matches_list_row:					lw		$t0, 0($a0)	#matrix->size
					sub		$sp, $sp, 8
					sw		$ra, 0($sp)
					sw		$t0, 4($sp)
					move	$a3, $a2
					move	$a2, $a1
					li		$a1, 0
					li		$v0, 0
			loop:	bge		$a1, $t0, end
					jal		matrix_column_matches_list_row
					add		$a1, $a1, 1
					lw		$t0, 4($sp)
					bne		$v0, 1, loop
			end:	move	$a1, $a2
					move	$a2, $a3
					lw		$ra, 0($sp)
					add		$sp, $sp, 8
					jr      $ra






