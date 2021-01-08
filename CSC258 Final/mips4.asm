	.data

	.text
main:	
	addi $t7, $0, 4294967295
	xori $sp, $sp, 65535
	
	li $v0, 1					# end the program
	add $a0, $0, $t7
	syscall
	
	li $v0, 10
	syscall
