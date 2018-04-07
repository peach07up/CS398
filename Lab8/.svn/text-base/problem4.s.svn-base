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
				lw		$t0, 0($a0)		#matrix->size
				li		$v0, 0			#ret
				beq		$t0, $a2, check
				li		$t0, 0			#t0 = i, need to save
		loop:	lw		$t1, 0($a1)		#list->size
				bge		$t0, $t1, end
				li		$t1, 1
				sllv	$t1, $t1, $t0	#1L<<i
				and		$t1, $a3, $t1
				bne		$t1, 0, endif
				li		$t1, 0			#t1 = j

				lw		$t2, 4($a0)		#matrix->data
				mul		$t3, $a2, 4
				add		$t2, $t2, $t3
				lw		$t2, 0($t2)		#t2 = matrix->data[depth][0]
				
				lw		$t3, 4($a1)		#list->data
				mul		$t4, $t0, 4
				add		$t3, $t3, $t4
				lw		$t3, 0($t3)		#t3 = list->data[i][0]
								
		loop2:	lw		$t4, 0($a0)		#list->size
				bge		$t1, $t4, next				
				add		$t4, $t2, $t1	
				add		$t5, $t3, $t1
				lb		$t5, 0($t5)		#t5 = list->data[i][j]
				sb		$t5, 0($t4)
				add		$t1, $t1, 1
				j		loop2			#end loop2
				
		next:	sub		$sp, $sp, 12	#stack
				sw		$ra, 0($sp)		#$ra
				sw		$a3, 4($sp)		#bitmask
				sw		$t0, 8($sp)
				add		$a2, $a2, 1		#depth+1
				li		$t2, 1
				sllv	$t2, $t2, $t0	#1L<<i
				or		$a3, $t2, $a3	#(1L<<i)|bitmask
				jal		solve
				sub		$a2, $a2, 1
				lw		$ra, 0($sp)
				lw		$a3, 4($sp)
				lw		$t0, 8($sp)
				add		$sp, $sp, 12
				beq		$v0, 1, end		#end if
				j		endif
		end:	jr      $ra
		check:	sub		$sp, $sp, 8
				sw		$ra, 0($sp)
				sw		$a2, 4($sp)
				move	$a2, $a3
				jal		check_remaining_columns
				move	$a3, $a2
				lw		$a2, 4($sp)
				lw		$ra, 0($sp)
				add		$sp, $sp, 8
				j		end
		endif:	add		$t0, $t0, 1
				j		loop
				
