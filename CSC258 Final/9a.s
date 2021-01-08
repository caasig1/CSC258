	.data
len:	.word 	5
list:	.word 	-4, 6, 7, -2, 1 #check for if end is largest in case list is weird indexing
	.text 
# v1 = max, t2 = n, t7 = addr(list[n]), t8 = len, t9 = list
main:	la $t9, list				# t9 holds address of array list
	lw $t8, len				# t8 holds len
	addi $t7, $t9, 0			# t2 = addr(list[0])
	lw $v1, 0($t7)				# max = list[0]
	addi $t2, $0, 0				# n = 0
	
LOOP:	ble   $t8, $t2, end			# while (n < len) [ends when len <= n]
	lw $t3, 0($t7) 				# t3 = list[n]
	blt $v1, $t3, if			# if(max < list[n]) go to if	
	addi $t2, $t2, 1			# n += 1
	sll $t4, $t2, 2 			# $t4 = $t0 * 4 = n * 4 = offset
	add $t7, $t9, $t4 			# $t7 = addr(list) + i*4 = addr(list[n])
	j LOOP
	
if:	lw $v1, 0($t7)		 		# $v1 = list[n]
	j LOOP
	
end:	sw $v1, 0($sp)
	li $v0, 1
	add $a0, $0, $v1
	syscall
