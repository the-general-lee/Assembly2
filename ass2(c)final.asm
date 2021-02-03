.data
user_num:
	.space 42
welcome_msg:
	.asciiz "please enter the number you want converted with prefix 0b if it is binary, 0O if octal and 0X if hex, no prefix if decimal note you can only enter 10 digits after prefix"
newline:
	.asciiz "\n"
bva:
	.ascii"b"
Ova:
	.asciiz"O"
Xva:
	.asciiz "X"
zero:
	.asciiz"0"
con_msg:
	.asciiz "what system do you want to convert this number to enter 2 for binary 8 for oct, 10 for dec, 16 for hex"
num_in_form:
	.asciiz"The number is already in the form you want it converted to"
final_num:
	.space 42
.text
main: 
li $v0, 4                       # out put a message of instructions
la $a0, welcome_msg             
syscall

li $v0, 4
la $a0, newline
syscall

li $v0,8
la $a0, user_num                # enter the number you want converted
li $a1, 42
syscall

jal check_num1  # from this we get the system of the entered number in t9
add $t9, $v0,$zero
la $t1, user_num
li $t3, 0 # t3 was used to represent zero string now we use it as a counter to represent how many digits in my number
read_loop:
lb $t2, ($t1)
addi $t1, $t1,1 #cursor
beq $t2,$zero, input #end of num
addi $t3, $t3,1 #counter
j read_loop


input:
addi $t3,$t3,-1
la $t1, user_num
addi $t1, $t1, 1
input_again:
li $v0, 4
la $a0, con_msg # ask the user to what system does he/she wants to convert the number to
syscall

li $v0 ,5       #actually entering the number
syscall
li $t0,0
add $t0, $v0, $zero

jal convert_to_decimal # this convert the number into a decimal and return this decimal value in a register v0
add $t9, $v0,$zero

jal convert_from_decimal  #this function convert the decimal number into the desired form and return the value in memory with v0 pointing to the first address of that memory

beq $t3, 1, exit_main    # this is necessary because sometimes the new number is only one digit long and the function reverse requires two elements, remember two cursors ,at least or else an error occurs
jal reverse_my_string    # this stored value in memory will be reversed, MSF reads from right not left, hence this function returns it right and return first address in v0


exit_main:
add $a0, $v0, $zero
li $v0, 4
syscall
li $v0,10
syscall


check_num1:
li $v1,1
la $t3, zero          #load the value of b into t4 then comparing it with the second input of my number
lb $t4, ($t3)
la $t1, user_num
lb $t2, ($t1)
beq $t2, $t4, check_num2 # number has first letter of a prefix
j assign_dec               # number doesn't have the first letter of prefix hence has no prefix and is decimal
check_num2:
addi $t1, $t1, 1
lb $t2, ($t1)
la $t3, bva          #load the value of b into t4 then comparing it with the second input of my number
lb $t4, ($t3)
beq $t2, $t4, assign_bin
la $t3, Ova	    # do the same for value of O
lb $t4, ($t3)
beq $t2, $t4, assign_oct
la $t3, Xva         # do the same for value of X
lb $t4, ($t3)
beq $t2, $t4, assign_hex
j assign_dec        # if the value of the number is none of these it is already decimal 

assign_bin:
li $v0, 2           # make t9 identifier of the system if it is bin 2 if hex 16 and so on
li $v1, 0
jr $ra

assign_oct:
li $v0, 8
li $v1,0
jr $ra

assign_hex:
li $v0, 16
li $v1,0
jr $ra

assign_dec:
li $v0,10
li $v1,0
jr $ra

convert_to_decimal: # we will let t7 be the register in which we store value of number, t6 will be where we store value of digit
li $v1,-1
li $t7, 0
li $t6, 0
beq $t9, 2, convert_binary_to_decimal
beq $t9, 8, convert_octal_to_decimal
beq $t9, 10, convert_decimal_to_decimal
beq $t9, 16, convert_hex_to_decimal


convert_binary_to_decimal:
addi $t5,$t3,-2  # degrees of the entered number
la $t1, user_num
addi $t1, $t1, 2

loop_of_converting_numberbd:
lb $t2,($t1)              # load the number you want converted
add $t2, $t2, -48         #convert to integer
addi $t1, $t1, 1          # get the address of the next number
addi $t5,$t5,-1           # decrease the digits
add $t7, $t7,$t6          # this saves the value of the digit to the whole value of number
add $t8, $t5,$zero        # this is to decrease the order but we can't get order zero
bne $t5,0,loop_of_converting_digitbd
beq $t5, 0, end_conversion_bd

loop_of_converting_digitbd:
mul $t2, $t2, 2
add $t6, $t2, $zero
addi $t8, $t8, -1
beq $t8, $zero, loop_of_converting_numberbd
j loop_of_converting_digitbd

end_conversion_bd:
add $t7, $t7, $t2 # since we multiply by two to the power zero i just add whatever number is left in units it will have its own value anyway
add $v0, $t7, $zero
li $v1,0
jr $ra
convert_octal_to_decimal:
addi $t5,$t3,-2  # degrees of the entered number
la $t1, user_num
addi $t1, $t1, 2

loop_of_converting_numberod:
lb $t2,($t1)              # load the number you want converted
add $t2, $t2, -48         #convert to integer
addi $t1, $t1, 1          # get the address of the next number
addi $t5,$t5,-1           # decrease the order
add $t7, $t7,$t6          # this saves the value of the digit to the whole value of number
add $t8, $t5,$zero
bne $t5,0,loop_of_converting_digitod
beq $t5, 0, end_conversion_od 


loop_of_converting_digitod:
mul $t2, $t2, 8
add $t6, $t2, $zero
addi $t8, $t8, -1
beq $t8, $zero, loop_of_converting_numberod
j loop_of_converting_digitod

end_conversion_od:
add $t7, $t7, $t2
add $v0, $t7, $zero
li $v1,0
jr $ra

convert_decimal_to_decimal:
add $t5,$t3,$zero  # degrees of the entered number
la $t1, user_num

loop_of_converting_numberdd:
lb $t2,($t1)              # load the number you want converted
add $t2, $t2, -48         #convert to integer
addi $t1, $t1, 1          # get the address of the next number
addi $t5,$t5,-1           # decrease the order
add $t7, $t7,$t6          # this saves the value of the digit to the whole value of number
add $t8, $t5,$zero
bne $t5,0,loop_of_converting_digitdd
beq $t5, 0, end_conversion_dd 


loop_of_converting_digitdd:
mul $t2, $t2, 10
add $t6, $t2, $zero
addi $t8, $t8, -1
beq $t8, $zero, loop_of_converting_numberdd
j loop_of_converting_digitdd

end_conversion_dd:
add $t7, $t7, $t2
add $v0, $t7, $zero
li $v1,0
jr $ra

jr $ra

convert_hex_to_decimal:
addi $t5,$t3,-2  # degrees of the entered number
la $t1, user_num
addi $t1, $t1, 2

loop_of_converting_numberhd:
lb $t2,($t1)              # load the number you want converted
bge $t2, 58,hexletter
add $t2, $t2, -48         #convert to integer
continueyourlife:
addi $t1, $t1, 1          # get the address of the next number
addi $t5,$t5,-1           # decrease the order
add $t7, $t7,$t6          # this saves the value of the digit to the whole value of number
add $t8, $t5,$zero
bne $t5,0,loop_of_converting_digithd
beq $t5, 0, end_conversion_hd 

hexletter:
addi $t2,$t2, -87
j continueyourlife


loop_of_converting_digithd:
mul $t2, $t2, 16
add $t6,$t2,$zero
addi $t8, $t8, -1
beq $t8, $zero, loop_of_converting_numberhd
j loop_of_converting_digithd

end_conversion_hd:
add $t7, $t7, $t2
add $v0, $t7, $zero
li $v1,0
jr $ra


convert_from_decimal:
li $v1, -1
li $t3, 0 # we are making this counter to know how many digits are there in the new number to reverse it later
beq $t0, 2, convert_decimal_to_binary
beq $t0, 8, convert_decimal_to_octal
beq $t0, 10, convert_decimal_to_decimal_stored
beq $t0, 16, convert_decimal_to_hex

convert_decimal_to_binary:
la $t7,final_num
loop:
div $t9,$t9,2
mfhi $t6 
add $t6, $t6, 48
sb $t6,($t7)
addi $t3, $t3, 1
add $t7, $t7, 1
beq $t9,$zero, exit_db
j loop
exit_db:
la $v0, final_num
li $v1, 0
jr $ra

convert_decimal_to_octal:
la $t7,final_num
loops:
div $t9,$t9,8
mfhi $t6 
add $t6, $t6, 48
sb $t6,($t7)
addi $t3, $t3, 1
add $t7, $t7, 1
beq $t9,$zero, exit_do
j loops
exit_do:
la $v0, final_num
li $v1, 0
jr $ra


convert_decimal_to_decimal_stored:

la $t7,final_num
loopss:
div $t9,$t9,10
mfhi $t6 
add $t6, $t6, 48
sb $t6,($t7)
addi $t3, $t3, 1
add $t7, $t7, 1
beq $t9,$zero, exit_dd
j loopss
exit_dd:
la $v0, final_num
li $v1, 0
jr $ra


convert_decimal_to_hex:

la $t7,final_num
loopsss:
div $t9,$t9,16
mfhi $t6 
bge $t6,10, hex
add $t6, $t6, 48
continue_your_thing:
sb $t6,($t7)
addi $t3, $t3, 1
add $t7, $t7, 1
beq $t9,$zero, exit_db
j loopsss
hex:
add $t6,$t6, 87
j continue_your_thing
exit_dh:
la $v0, final_num
li $v1, 0
jr $ra

reverse_my_string:
li $v1,-1
la $t1, final_num 


reverse: 
la  $t1, final_num  #get cursor at the beginning
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
la $v0, final_num
li $v1,0
jr $ra
