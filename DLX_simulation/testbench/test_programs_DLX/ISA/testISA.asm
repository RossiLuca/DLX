lhi r3,#1
addi r1,r0,#1; r1=1
addi r2,r0,#31; r2=31
addi r3,r0,#1; r3=1
addi r4,r0,#1; r4=1
nop
nop
addi r0,r0,#0; r0=0
nop
nop
nop
nop
beqz r0,pippo; jump to pippo
subi r2,r2,#1; no effect
nop
nop
nop
nop
nop
nop
nop
nop
pippo:
nop
bnez r1,pluto; jump to pluto
subi r2,r2,#1 ; no effect
nop
nop
nop
nop
nop
nop
nop
pluto:
addi r0,r0,#0 ; r0=0
j paperino ; jump to paperino
nop
nop
nop
nop
nop
nop
nop
nop
nop
paperino:
addi r9,r0,#184 ;r9=184
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
jal topolino ; jump to topolino and save in r31=topolino+4
nop
nop
nop
nop
nop
nop
nop
nop
nop
topolino:
addi r7, r0, minni ;save address corresponding to the label topolino into r7
nop
nop
nop
nop
nop
jr r7  ;jump minni
addi r0,r1,#5 ; no effect
andi r0,r1,#0 ; no effect
nop
nop
nop
minni:
subi r0,r0,#0 ; r0=0
addi r7,r0,basettoni ; save address corresponding to the label basettoni in r7
nop
nop
nop
nop
nop
jalr r7 ;jump basettoni
addi r0,r1,#5 ; no effect
andi r0,r1,#0 ; no effect
nop
nop
nop
basettoni:
addi r1,r0,#15 ; r1=15
addi r2,r0,#-7 ; r2=-7
nop
nop
nop
nop
nop
sw 1(r0),r1 ; store word 15 in memory mem(1)=00 mem(2)=00 mem(3)=00 mem(4)=0F
sb 1(r1),r2 ; store byte -7 in memory mem(16)=9
nop
nop
nop
nop
nop
lw r3,1(r0); r3=000F
lw r4,1(r1); r4=9000
lb r5,1(r0); r5=0000
lb r6,1(r1); r6=9000
lbu r7,1(r0); r7=0000
lbu r8,1(r1); r8=0009
lhu r9,1(r0); r9=
lhu r10,1(r1) r10=
nop
nop
nop
nop
nop
addi r1,r0,#1 ;r1=1
addi r2,r0,#31 ;r2=31
addi r3,r0,#1 ;r3=1
addi r4,r0,#1 ;r4=1
nop
nop
nop
nop
nop
sge r5,r1,r3 ;r5=1
sle r6,r1,r2 ;r6=1
sgei r7,r2,#1 ;r7=1
slei r8,r1,#1 ;r8=1
sne r9,r0,r1 ;r9=1
snei r10,r0,#1 ;r10=1
seq r11,r3,r1 ;r11=1
seqi r12,r0,#0 ;r12=1
sgeu r13,r0,r0 ;r13=1
sgeui r14,r2,#30 ;r14=1
sgt r15,r1,r0 ;r15=1
sgti r16,r2,#30 ;r16=1
sgtu r17,r2,r1 ;r17=1
sgtui r18,r2,#5 ;r18=1
slt r19,r0,r2 ;r19=1
slti r20,r0,#8 ;r20=1
sltu r21,r0,r2 ;r21=1
sltui r22,r2,#32 ;r22=1
sra r23,r1,r3 ;r23=0000
srai r24,r1,#2 ;r24=0000
addui r25,r0,#-1;r25=FFFF
nop
nop
nop
nop
nop
addu r26,r25,r0 ;r26=FFFF
nop
nop
nop
nop
nop
subu r1,r25,r26 ;r1=0
subui r2,r25,#-1 ;r2=0
nop
nop
nop
nop
nop
mult r27,r3,r4; r27=1
mult r3,r0,r5;  r3=0
mult r28,r25,r26; r28=1
add r29,r0,r4; r29=1
and r30,r4,r4; r30=1
andi r5,r6,#0; r5=0
or   r7,r0,r0; r7=0
ori	 r1,r0,#2; r1=2
sll  r2,r8,r9; r2=2
slli  r3,r8,#1; r3=2
srl  r4,r8,r9; r4=0
srli r5,r8,#1; r5=0
sub r6,r8,r9; r6=0
xor r8,r9,r10; r8=0
xori r9,r0,#-1; r9=FFFF
ror r10,r1,r2; r10= 1000 0000 0000 0000 
rori r11,r1,#2; r11= 1000 0000 0000 0000
nop
nop
nop
nop
nop
rol r10,r10,r2; r10= 0000 0000 0000 0010 2
roli r11,r11,#2; r11= 0000 0000 0000 0010 2
nop
nop
nop
nop
nop