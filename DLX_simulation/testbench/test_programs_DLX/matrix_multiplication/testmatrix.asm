addi r1,r0,#1 ;S11
addi r2,r0,#1 ;S12
addi r3,r0,#1 ;S13
addi r4,r0,#1 ;S14
addi r5,r0,#1 ;S21
addi r6,r0,#1 ;S22
addi r7,r0,#1 ;S23
addi r8,r0,#1 ;S24
addi r9,r0,#1 ;S31
addi r10,r0,#1 ;S32
addi r11,r0,#1 ;S33
addi r12,r0,#1 ;S34
addi r13,r0,#1 ;S41
addi r14,r0,#1 ;S42
addi r15,r0,#1 ;S43
addi r16,r0,#1;S44
sw 4(r0),r1 ; store S11
addi r17,r0,#1 ;S11
addi r18,r0,#1 ;S12
addi r19,r0,#1 ;S13
addi r20,r0,#1 ;S14
addi r21,r0,#1 ;S21
addi r22,r0,#1 ;S22
addi r23,r0,#1 ;S23
addi r24,r0,#1 ;S24
addi r25,r0,#1 ;S31
addi r26,r0,#1 ;S32
addi r27,r0,#1 ;S33
addi r28,r0,#1 ;S34
addi r29,r0,#1 ;S41
addi r30,r0,#1 ;S42
addi r31,r0,#1 ;S43
addi r1,r0,#1 ;S44
sw 8(r0),r2 ; store S12
sw 12(r0),r3 ; store S13
sw 16(r0),r4 ; store S14
sw 20(r0),r5 ; store S21
sw 24(r0),r6 ; store S22
sw 28(r0),r7 ; store S23
sw 32(r0),r8 ; store S24
sw 36(r0),r9 ; store S31
sw 40(r0),r10 ; store S32
sw 44(r0),r11 ; store S33
sw 48(r0),r12 ; store S34
sw 52(r0),r13 ; store S41
sw 56(r0),r14 ; store S42
sw 60(r0),r15 ; store S43
sw 64(r0),r16 ; store S44
sw 68(r0),r17 ; store S11
sw 72(r0),r18 ; store S12
sw 76(r0),r19 ; store S13
sw 80(r0),r20 ; store S14
sw 84(r0),r21 ; store S21
sw 88(r0),r22 ; store S22
sw 92(r0),r23 ; store S23
sw 96(r0),r24 ; store S24
sw 100(r0),r25 ; store S31
sw 104(r0),r26 ; store S32
sw 108(r0),r27 ; store S33
sw 112(r0),r28 ; store S34
sw 116(r0),r29 ; store S41
sw 120(r0),r30 ; store S42
sw 124(r0),r31 ; store S43
sw 128(r0),r1 ; store S44
addi r16,r0,#64 ; 
addi r17,r0,#4 ; start address matrix 1
addi r10,r0,#0 ; reset accumulator
addi r31,r0,#4 ;number of row
addi r29,r0,#4 ;number of column
addi r20,r0,#160 ; memory start address for result matrix
addi r30,r0,#16 ;number of operations
addi r3,r0,#4 ; first address of matrix 1
addi r4,r0,#68 ; first address of matrix 2
addi r1,r0,#0 
addi r2,r0,#0 
nop
nop
mulsum:
lw r5,0(r3) ;load number of matrix 1
lw r6,0(r4) ;load number of matrix 2
subi r31,r31,#1 ;update counter of column
addi r3,r3,#4 ; update address row
addi r4,r4,#16 ; update column address
nop
nop
mult r7,r5,r6 ;product 
nop
nop
nop
nop
nop
add r10,r10,r7 ; sum of product
bnez r31,mulsum
subi r29,r29,#1 ; update number of operation in row
subi r30,r30,#1 ; update number of calculation
addi r31,r0,#4 ; restore counter of column
subi r4,r4,#60 ; new column
nop
nop
nop
bnez r29,firstrow
addi r17,r17,#16 ; new row
addi r4,r0,#68 ; restore first address of matrix 2
addi r29,r0,#4 ;
nop
nop
nop
nop
firstrow:
add r3,r0,r17 ; new row start address
nop
sw 0(r20),r10 ; store result of multiplication 164 184 204 224
addi r20,r20,#4 ; update store address for result
addi r10,r0,#0 ; reset accumulator
nop
nop
bnez r30,mulsum
nop
nop
nop
nop
nop