# a[i] = a[i] + a[i-1]
addi x1, x0, 0x100   # base
addi x2, x0, 5       # count
addi x3, x0, 1
sw   x3, 0(x1)
addi x1, x1, 8

loop:
lw   x4, -8(x1)
add  x3, x3, x4      
sw   x3, 0(x1)
addi x1, x1, 8
addi x2, x2, -1
bne  x2, x0, loop
