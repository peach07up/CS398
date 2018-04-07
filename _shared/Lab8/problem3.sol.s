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
##         if ((1L << i) & bitmask) { continue; }
##         if (!any_matrix_column_matches_list_row(matrix, list, i)) {
##             return 0;
##         }
##     }
##     return 1;
## }

.text
.globl check_remaining_columns
check_remaining_columns:
    sub     $sp, $sp, 28
    sw      $ra, 0($sp)
    sw      $a0, 4($sp)		# save 1st two arguments
    sw      $a1, 8($sp)

    sw      $s0, 12($sp)	# save some callee-saved registers
    sw      $s1, 16($sp)
    sw      $s2, 20($sp)
    sw      $s3, 24($sp)

    li      $s0, 0          # $s0 = i = 0
    lw      $s1, 0($a1)     # $s1 = list->size
    li      $s2, 1          # $s2 = 1
    move    $s3, $a2	    # $s3 = bitmask

crc_loop:
    bge     $s0, $s1, crc_loop_end

    sll     $t0, $s2, $s0   # $t0 = 1L << i
    and     $t0, $t0, $s3   # $t0 = (1L << i) & bitmask
    bne     $t0, 0, crc_continue			

    lw      $a0, 4($sp)     # $a0 = matrix
    lw      $a1, 8($sp)     # $a1 = list
    move    $a2, $s0        # $a2 = i
    jal     any_matrix_column_matches_list_row
    beq     $v0, 0, crc_return	# if call returns zero, we return zero ($v0 is already 0)

crc_continue:
    add     $s0, $s0, 1      # ++ i
    j       crc_loop

crc_loop_end:
    li  $v0, 1              # return 1

crc_return:
    lw      $ra, 0($sp)
    lw      $s0, 12($sp)	# save some callee-saved registers
    lw      $s1, 16($sp)
    lw      $s2, 20($sp)
    lw      $s3, 24($sp)
    add     $sp, $sp, 28
    jr      $ra
