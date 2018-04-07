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
				li		$t0, 0			#k
				lw		$t1, 0($a0)		#matrix->size
				lw		$t2, 4($a0)		#matrix->data
				lw		$t5, 4($a2)
				mul		$t4, $a3, 4
				add		$t4, $t5, $t4
				lw		$t4, 0($t4)
		loop:	bge		$t0, $t1, end
				mul		$t3, $t0, 4
				add		$t3, $t2, $t3
				lw		$t3, 0($t3)		#matrix->data[k]
				add		$t3, $a1, $t3
				lbu		$t3, 0($t3)		#matrix->data[k][col]
				add		$t5, $t4, $t0
				lbu		$t5, 0($t5)		#list[row][k]
				add		$t0, 1
				beq		$t3, $t5, loop
				li		$v0, 0
				j		out
		end:	li		$v0, 1
    	out:	jr      $ra





