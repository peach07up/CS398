## In this file, please implement the check_remaining_columns as shown below.
##
## Do not include any testing code in this file (especially not any
## "main" labels).  Load this file and p3_main.s, problem1.s, and
## problem2.s into QtSpim for testing

## int 
## check_remaining_columns(HexMatrix* matrix, HexList* list, unsigned int bitmask) 
## {
##     for (int i = 0; i < list->size; ++ i) 
##     {
##         if ((1L << i) & bitmask) { continue; }   // continue if this was used as a row
##         if (!any_matrix_column_matches_list_row(matrix, list, i)) {  
##             return 0;   // if it doesn't match any columns, this matrix isn't a solution
##         }
##     }
##     return 1;
## }

.text
.globl check_remaining_columns
check_remaining_columns:
					#li		$t0, 0			#i
					sub		$sp, $sp, 8
					sw		$ra, 0($sp)		#reutrn address
					sw		$a2, 4($sp)		#mask
					li		$a2, 0
					lw		$t1, 0($a1)
					li		$v0, 1
			loop:	bge		$a2, $t1, out
					li		$t2, 1
					lw		$t4, 4($sp)
					sllv	$t3, $t2, $a2
					and		$t3, $t3, $t4
					#li		$t3, 1
					bne		$t3, 0, skip
					jal		any_matrix_column_matches_list_row
					beq		$v0, 1, skip
			out:	lw		$a2, 4($sp)
					lw		$ra, 0($sp)
					add		$sp, $sp, 8
					jr      $ra
			skip:	add		$a2, $a2, 1
					lw		$t1, 0($a1)		#list->size
					j		loop
