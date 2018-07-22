addi r1,r0,#15
addi r2,r0,#-7
nop
nop
nop
nop
nop
sw 1(r0),r1; store word 15 in mem(1,2,3,4) 15=0000000F
sb 1(r1),r2; store byte -7 in mem(16) -7=FFFFFFF9
nop
nop
nop
nop
nop
lw r3,1(r0); load mem(1,2,3,4) in r3= 0000000F
lw r4,1(r1); load mem(16,17,18,19) in r4= F9000000
lb r5,1(r0); load mem(1) in r5= 00000000
lb r6,1(r1); load mem(16) in r6= FFFFFFF9
lbu r7,1(r0); load mem(1) in r7= 00000000
lbu r8,1(r1); load mem(16) in r8= 000000F9
lhu r9,1(r0); load mem(1,2) in r9= 00000000
lhu r10,1(r1); load mem(16) in r10= 0000F900
nop
nop
nop
nop
nop
nop
nop

