.data
my_array:
	.space 20
.text

main:


jal reverse_my_string
add $a0, $v0, $zero

li $v0,4
syscall



li $v0,10
syscall






reverse_my_string:
li $v0,8
la $a0, my_array
li $a1, 20
syscall

la $t1, my_array 
li $t3,0

read_loop:
lb $t2, ($t1)
addi $t1, $t1,1 #cursor
beq $t2,$zero, reverse #end of text
addi $t3, $t3,1 #counter
j read_loop

reverse: 
add $t3,$t3,-1
la  $t1, my_array  #get cursor at the beginning
div $t6,$t3,2  #get half elements in an array
add $t0, $t3, -1
add $t7, $t1,$t0 #end of the index

swap_and_write:
lb $t2, ($t1)
lb $t8, ($t7)
addi $t1, $t1, 1
addi $t7, $t7, -1
sb $t8,-1($t1)     # write the end of the array into the beginning
sb $t2,1($t7)      # write the beginning of array into the end.
add $t6,$t6,-1     # decrease the counter
beq $t6,$zero, getout
j swap_and_write



getout:
la $v0, my_array
jr $ra


