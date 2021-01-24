#File: Assignmnent 2
#Roll No: 21-10451

.data
head: .word 0
tail: .word 0
insertMessage: .asciiz "Enter the index where you want to insert the node: "
deleteMessage: .asciiz "Enter the index from where you want to delete the node: "
name: .asciiz "Enter your name: "
rollNo: .asciiz "Enter your roll no: "
errorMessage: .asciiz "Please enter data"
addressMessage: .asciiz "Address of newly allocated block is: "
performTask: .asciiz "You can perform c (create Node), i (insert Node), d (delete Node), p (display List) and e(end program) operation on the linked list, please choose one opertaion from the given operations"
selected: .asciiz "c,i,d,p"
length: .word 0
error: .asciiz "Entered wrong input"

.text
main:

jal menu

create1:
jal createNode
#move $a0, $t1 #moving the address of allocated memory
move $t2, $t1

insert1:
#la $a1, head
la $t0, head
#la $a2, tail
la $t1, tail
li $v0, 51
la $a0, insertMessage
syscall
move $a3, $a0
move $a0, $t2
move $a1, $t0
move $a2, $t1
jal insertNode


delete1:
la $t0, head
la $t1, tail
li $v0, 51
la $a0, deleteMessage
syscall
move $a3, $a0
move $a0, $t2
la $a1,head
la $a2,tail
jal deleteNode

display1:
la $t0, head
move $a0, $t0
jal displayList

li $v0,10
syscall

menu:
sw $ra, 0($sp)
addi $sp, $sp, -4
#### DISPLAY OPTION OF CHOICES TO USER ####
li $v0, 54
la $a0, performTask
la $a1, selected         ##($t7)
li $a2, 6
syscall

move $t7, $a1

#if the input is c then run the function createNode

li $t1, 'c'
beq $t1, $t7, create
create:
j create1

#if the input is i then run the function insertNode

######### if the user ask for insertNode then first use the fiunction createNode #############
   
li $t2, 'i'
beq $t2, $t7, insert
insert:
j insert1

li $t3, 'd'
beq $t3, $t7, delete
delete:
j delete1

li $t4, 'p'
beq $t4, $t7, display
display:
j display1

li $t5, 'e'
beq $t5, $t7, exit

j main

addi $sp, $sp, 4
lw $ra, 0($sp)
jr $ra 

exit:
li $v0, 10
syscall




createNode: 
sw $ra, 0($sp)	
addi $sp, $sp, -4
#allocating memory on heap
		li $v0, 9
		li $a0, 40
		syscall
		#address of allocated memory
		move $t0, $v0
		#asking user for name
		li $v0, 54
		la $a0, name
		la $a1, ($t0)
		li $a2, 31
		syscall

		beq $a1, $zero, keep
		
		#la $t3, head					
		sw $v0, head
		
		li $v0, 55
		la $a0, errorMessage
		syscall	

		#asking the user for roll no
		keep:  li $v0, 51
		la $a0, rollNo
		syscall
		
		#move $t2, $v0
		move $t2, $a0
		
		beq $a1, $zero, do

		li $v0, 55
		la $a0, errorMessage
		syscall	
		
		
		do: sw $t2, 32($t0)
		#intialize next pointer
		
		### THINK ABOUT THIS AGAIN###
		### Removing the sw $zero command for the time being####
		
		sw $zero, 36($t0)
		#return address of newly allocated node 
		li $v0, 56
		la $a0, addressMessage
		la $a1, ($t0)
		syscall
		
		move $v0, $t0
		move $t1, $v0
	
		#li $v0, 56
		#la $a0, addressMessage
		#la $a1, ($t1)
		#syscall
		
		addi $sp, $sp, 4
		lw $ra, 0($sp)
		
		jr $ra




insertNode:
sw $ra, 0($sp)
addi $sp, $sp, -4

move $t0, $a1 #loading address of head

###move command can work here also #####
move $t1, $a0 #loading the address of newly created node

move $t6, $a2 #tail
move $t2, $a3 #index where node must be placed

lw $t9, length

bne $t9, $zero, listnotempty
j append

slt $t8,$t2, $zero
beq $t8, 1, errorInsert

j work

slt $s1, $t2, $t9
bne $s1, $zero, work

errorInsert: 
li $v0, 55
la $a0,error
syscall 



work:
#counter
li $t3, 0


#loop condition
seq $t5,$t3, $t2
bne $t5, $zero, changes

lw $t4, 0($t0)




changes:
#increment counter and next node address
addi $t3, $t3, 1
beq $t4, $zero, headChanges
addi $t9, $t9, 1

headChanges: 
sw $t1, 0($t0)
sw $t1, 0($t6)

##################addi $t4, $t4, 36  #######Think about the next address location ?????????????##########

j insertExit

sgt $s0,$t2, $t9
beq $s0, 1, append


append: 
#sw $ra, 0($sp)
#sw $s0, -4($sp)
#sw $s1, -8($sp)
#addi $sp, $sp, -12
la $t0, tail
lw $s0, 0($t0)
bne $s0, $zero, listnotempty
la $t0, head
sw $a0, 0($t0) #update head
la $t0, tail
sw $a0, 0($t0) #update tail
#j almostdone

j insertExit

listnotempty: la $t0, tail
lw $s0, 0($t0)
addi $s0, $s0, 4
sw $a0, 0($s0) #point next of tail node to the new node
sw $a0, 0($t0) #update tail pointer
#almostdone:
#addi $sp, $sp, 12
#lw $s1, -8($sp)
#lw $s0, -4($sp)
#lw $ra, 0($sp)
#jr $ra

#j insertExit
 

move $t7, $t4 #saving the address of the next node 

move $t4, $t2 #making the next of the curent node equivalent to the new node that needed to be inserted there

# make the next of the newly added node to the address of the next node


####THINK ABOUT THIS ADDI ######
addi $t2, $t2, 36

move $t2, $t7 #moving the pointer of previous node to  
 	
 	
insertExit:
addi $sp, $sp, 4
lw $ra, 0($sp)
jr $ra


deleteNode:
sw $ra, 0($sp)
addi $sp, $sp, -4
lw $t0,0($a1) #loading address of head
lw $t1,0($a2)
###move command can work here also #####
#lw $t1, 0($a0 )#loading the address of newly created node
beq $t0,$t1,singleelement


move $t2, $a3 #index where node must be placed
addi $t2, $t2, -1

la $t2, 0($t2)

#counter
li $t3, 0

#loop condition
seq $t5,$t3, $t2
bne $t5, $zero, deleteChange
la $t4, 0($t0)


deleteChange:
#increment counter and next node address
addi $t3, $t3, 1
#sw $s0,36($t4)
lw $t4, 0($t0)

#addi $t4, $t4, 36  #######Think about the next address location ?????????????##########


move $t6, $t4 #saving the address of the next node 

move $t4, $t2 #making the next of the curent node equivalent to the new node that needed to be inserted there

# make the next of the newly added node to the address of the next node

#addi $t2, $t2, 36
lw $t2, 36($t2)
move $t2, $t6 #moving the pointer of previous node to  
 	
 	
#li $v0, 1
#move $a0, $t2
#syscall
 	
singleelement:
bne $t2,$zero,errordel
sw $zero,0($a1)
sw $zero,0($a2)
addi $sp, $sp, 4 
lw $ra, 0($sp)
jr $ra

errordel:
li $v0,1
addi $sp, $sp, 4 
lw $ra, 0($sp)
jr $ra


displayList:
sw $ra, 0($sp)
addi $sp, $sp, -4

move $t0, $a0 #address of head

lw $t1, head

li $v0, 55
move $a0, $t1
syscall

move $t2, $t1
addi $t2, $t2, 32
lw $t2, 0($t2)
#lw $t3, 0($t2)

li $v0, 56
move $a1, $t2
syscall

addi $sp, $sp, 4
lw $ra, 0($sp)

jr $ra
