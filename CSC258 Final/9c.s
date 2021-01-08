	.data
len:	.word	10
list:	.word	11,10,9,10,14,16,3,8,2,12

	.text
	j main
get_min:	# check if end of list
		bge  $t9, $a2, return				# if (i >= len)		
		# find list[i]
		sll $t0, $t9, 2					# x4 of index
		add $t1, $a1, $t0				# list + place
		lw $t2, 0($t1)					# load value at list[i] to t2
		
		# if statements
		blt $t2, $v1, change_min			# if (list[i] < min)
		
		# else recurse
get_min1:	addi $t9, $t9, 1				# a3 += 1
		
		# save the ra before going
		addi $sp, $sp, -4
		sw $ra, 0($sp)
		jal get_min
		lw $ra, 0($sp)					# when returned here, load the correct ra onto $ra
		addi $sp, $sp, 4				# change stack pointer
		jr $ra
		
return:		jr $ra

change_min:	add $v1, $zero, $t2
		j get_min1
		

# t9 is the list, t8 is the length
main: 		la $t5, list
		la $a1, list					# list
		lw $a2, len					# lenth of list
		add $t9, $0, 0					# counter i starting at 0 (up to 9 for list of length 10)
		lw $v1, 0($t5)					# min value
	
	
		jal get_min					# call function get_n
		sw $v1, 0($sp)
		
		li $v0, 1
		add $a0, $0, $v1
		syscall
