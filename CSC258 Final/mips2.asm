		.data
len:		.word	5
list:		.word	-4, 6, 7, -2, 1
index_wanted: 	.word 	4

		.text
	j main
get_n:	addi $t0, $zero, 1				# variable for 1
	blt $a0, $t0 if					# if (n < 1)
	bgt $a0, $t8 if					# if (n > len)
	subi  $t1, $a0, 1				# first one is at 0, so we -1 from nth item
	sll $t2, $t1, 2					# x4 so we get the beginning of the bytes t2
	add $t3, $t9, $t2				# index of idem is now at t3
	lw $v1, 0($t3)					# return list[n]
get_n1: jr $ra
	
if:	subi  $v1, $zero, 1				# return -1
	j get_n1
# t9 is the list, t8 is the length
main: 	la $t9, list					# load the list
	lw $t8, len					# load the len
	lw $t7, index_wanted
	add $a0, $zero, $t7				# the argument n index
	jal get_n					# call function get_n
	sw $v1, 0($sp)

	li $v0, 1
	add $a0, $0, $v1
	syscall