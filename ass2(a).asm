.data
my_array:
	.word 45, 12, 13, 19
msg:
	.asciiz "what integer are you looking for"
msg2:
	.asciiz" what is the size of your array"
msg3:
	.asciiz "your number is located at"
newline:
	.asciiz"\n"
.text
main:

jal search_array

add $t8,  $v0,  $zero
# put the number you want in t8

li $v0, 4
la $a0, msg3
syscall

li $v0, 4
la $a0, newline
syscall

li $v0, 1
add $a0, $t8,$zero
syscall






li $v0, 10
syscall


search_array:

li $v0,  4  #asking about the enteger wanted to be searched
la $a0, msg
syscall


li $v0,5
syscall

add $t3, $v0, $zero # entering the wanted  number into t3

li $v0, 4
la $a0, msg2
syscall

li $v0, 5         #entering the wanted number of elements
syscall

add $t6, $v0, $zero # number of elements in an array

la $t1, my_array 
lw $t2, ($t1)	    #loading array into t2 
li $t4, 0           #index

search:

beq $t3, $t2, get_index #if the number wanted equals the number loaded from the array
beq $t6, $zero, No_index # if the number wanted is not present
addi $t1, $t1, 4
addi $t4, $t4, 1
lw $t2, ($t1)
addi $t6,  $t6, -1 #decrease the number of elements left in an array
j search
get_index:
add $v0, $t4, $zero
jr $ra

No_index:
addi $v0, $zero,-1
jr $ra








