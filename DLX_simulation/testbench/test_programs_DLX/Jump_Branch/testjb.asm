j pippo
addi r1,r0,#8
nop
nop
nop
pippo:
addi r1,r0,#5
nop
nop
nop
beqz r0,pluto
addi r2,r0,#8
nop
nop
pluto:
addi r2,r0,#5
nop
nop
nop 
nop
nop; at the end if jump and branch are executed in the right way we have 5 in r1 and r2 otherwise there will be 13 in both the registers