addi r2,r0,#1 ;first number of fibonacci's serie
addi r1,r0,#1 ;second number of fibonacci's serie
addi r4,r0,#30 ;total number of the serie that i want to compute and store in the memory
addi r5,r0,8 ; start address for the memory
nop
nop
nop
nop
subi r4,r4,#2
sw 0(r0),r1 ; store first number of fibonacci's serie
sw 4(r0),r2 ; store second number of fibonacci's serie
nop
nop
nop
nop
fibonacci:
lw r2,-8(r5) ;load number n-2 of fibonacci's serie
lw r1,-4(r5)	;load number n-1 of fibonacci's serie
subi r4,r4,#1 ; decrease number of iterations
nop
nop
nop
nop
nop
add r3,r1,r2 ;compute number n of fibonacci's serie
nop
nop
nop
nop
nop
sw 0(r5),r3 ;store number n of fibonacci's serie
addi r5,r5,#4 ;increase memory address
nop
nop
nop
nop
bnez r4,fibonacci ;check iterations
nop
nop
nop
nop
nop
nop
