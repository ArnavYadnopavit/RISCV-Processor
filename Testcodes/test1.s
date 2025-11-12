#Numbers in x5,x6 and quotient in x7, remainder in x8,x9 info of sign

addi x5,x0,-50
addi x6,x0,-6
addi x7,x0,0
addi x9,x0,0

jal x1,SignDividend
nop
jal x1,SignDivisor
nop


beq x9,x0,PosDiv
nop
beq x0,x0,NegDiv
nop

SignDividend:
    blt x5,x0,L1
    nop
    jalr x0,x1,0
    nop

L1:
    sub x5,x0,x5
    addi x9,x9,1
    jalr x0,x1,0
    nop


SignDivisor:
    blt x6,x0,L2
    nop
    jalr x0,x1,0
    nop

L2:
    sub x6,x0,x6
    addi x9,x9,-1
    jalr x0,x1,0
    nop

PosDiv:
    blt x5,x6,Exit
    nop
    addi x7,x7,1
    sub x5,x5,x6
    beq x0,x0,PosDiv
    nop

NegDiv:
    blt x5,x6,NegExit
    nop
    addi x7,x7,1
    sub x5,x5,x6
    beq x0,x0,NegDiv
    nop


NegExit:
    sub x7,x0,x7
    beq x0,x0,Exit
    nop

Exit:
    addi x8,x5,0
    nop